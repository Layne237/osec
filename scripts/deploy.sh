#!/bin/bash
# ============================================
# OSEC Project — Deployment Script
# ============================================
# This script handles deployment of the backend
# API to AWS Elastic Beanstalk.
# ============================================

set -e

echo "============================================"
echo "  OSEC — Deployment"
echo "============================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
ENVIRONMENT=${1:-production}
BACKEND_DIR="backend"
DOCKER_IMAGE="osec-backend:latest"
AWS_REGION="${AWS_REGION:-eu-west-3}"

# Validate environment
if [ "$ENVIRONMENT" != "production" ] && [ "$ENVIRONMENT" != "staging" ]; then
    echo -e "${RED}Invalid environment: $ENVIRONMENT${NC}"
    echo "Usage: $0 [production|staging]"
    exit 1
fi

echo -e "Environment: ${YELLOW}$ENVIRONMENT${NC}"
echo ""

# 1. Load environment variables
if [ -f ".env.$ENVIRONMENT" ]; then
    echo -e "${YELLOW}Loading .env.$ENVIRONMENT...${NC}"
    export $(grep -v '^#' .env.$ENVIRONMENT | xargs)
elif [ -f ".env" ]; then
    echo -e "${YELLOW}Loading .env...${NC}"
    export $(grep -v '^#' .env | xargs)
else
    echo -e "${RED}No .env file found!${NC}"
    exit 1
fi

# 2. Run tests
echo -e "${YELLOW}Running backend tests...${NC}"
cd $BACKEND_DIR
npm test
cd ..

echo -e "  ${GREEN}✓${NC} Tests passed."
echo ""

# 3. Build Docker image
echo -e "${YELLOW}Building Docker image...${NC}"
docker build \
  -f infrastructure/docker/Dockerfile.backend \
  -t $DOCKER_IMAGE \
  --build-arg NODE_ENV=$ENVIRONMENT \
  .

echo -e "  ${GREEN}✓${NC} Docker image built: $DOCKER_IMAGE"
echo ""

# 4. Deploy to AWS Elastic Beanstalk
if [ "$ENVIRONMENT" == "production" ]; then
    EB_ENV="osec-production"
else
    EB_ENV="osec-staging"
fi

echo -e "${YELLOW}Deploying to Elastic Beanstalk: $EB_ENV...${NC}"

# Create deployment package
DEPLOY_DIR="deploy_$(date +%Y%m%d_%H%M%S)"
mkdir -p $DEPLOY_DIR

# Generate Dockerrun.aws.json
cat > $DEPLOY_DIR/Dockerrun.aws.json << EOF
{
  "AWSEBDockerrunVersion": "1",
  "Image": {
    "Name": "$DOCKER_IMAGE",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": "3000"
    }
  ],
  "Logging": "/var/log/osec"
}
EOF

# Deploy
if command -v eb &> /dev/null; then
    eb deploy $EB_ENV --timeout 20
    echo -e "  ${GREEN}✓${NC} Deployment to Elastic Beanstalk completed."
else
    echo -e "${YELLOW}EB CLI not found. Please install aws-cli and eb-cli.${NC}"
    echo -e "${YELLOW}Push Docker image manually and deploy via AWS Console.${NC}"
    
    # Push to ECR as fallback
    echo -e "${YELLOW}Pushing image to ECR...${NC}"
    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com
    docker tag $DOCKER_IMAGE $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/osec-backend:latest
    docker push $AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com/osec-backend:latest
    echo -e "  ${GREEN}✓${NC} Image pushed to ECR."
fi

# Cleanup
rm -rf $DEPLOY_DIR

echo ""
echo "============================================"
echo -e "  ${GREEN}Deployment to $ENVIRONMENT complete!${NC}"
echo "============================================"
