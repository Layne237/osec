# OSEC Backend API

The Node.js/Express backend server for the OSEC platform. Handles authentication, course management, payments, video streaming, and notifications.

## Prerequisites

- [Node.js](https://nodejs.org/) >= 18.x
- [MongoDB](https://www.mongodb.com/) (local or Atlas)
- [Redis](https://redis.io/) (optional, for caching)

## Setup

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Copy environment variables
cp ../.env.example .env

# Edit .env with your configuration
# Required: DATABASE_URL, JWT_SECRET
```

## Running

```bash
# Development mode (with hot-reload)
npm run dev

# Production mode
npm start
```

The server starts on `http://localhost:3000` by default.

## Environment Variables

See `.env.example` at the repo root for all available variables. Key ones:

| Variable | Required | Description |
|----------|----------|-------------|
| `DATABASE_URL` | Yes | MongoDB connection string |
| `JWT_SECRET` | Yes | Secret key for JWT signing |
| `MTN_MOBILE_MONEY_API_KEY` | Yes | MTN Mobile Money API key |
| `ORANGE_MONEY_API_KEY` | Yes | Orange Money API key |
| `AWS_ACCESS_KEY_ID` | Yes | AWS access key for S3 |
| `S3_BUCKET_NAME` | Yes | S3 bucket for video storage |
| `CLOUDFRONT_DOMAIN` | Yes | CloudFront CDN domain |

## API Documentation

Full API documentation is available in [docs/architecture/api_design.md](../docs/architecture/api_design.md).

### Base URL

```
http://localhost:3000/api/v1
```

### Core Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/register` | Register a new user |
| POST | `/auth/otp/send` | Send OTP verification code |
| POST | `/auth/otp/verify` | Verify OTP and login |
| POST | `/auth/refresh` | Refresh access token |
| GET | `/courses` | List available courses |
| GET | `/courses/:id` | Get course details |
| POST | `/payments/initiate` | Initiate a payment |
| POST | `/payments/confirm` | Confirm payment (webhook) |
| GET | `/courses/:id/lessons/:lessonId/stream` | Get video stream URL |
| POST | `/notifications/register` | Register device for push |

## Database

This project uses MongoDB with Mongoose ODM. The database is automatically connected on server start using the `DATABASE_URL` environment variable.

### Models

- **User** — Authentication, profile, enrolled courses
- **Course** — Course metadata, chapters, lessons
- **Lesson** — Video metadata, encryption info, duration
- **Transaction** — Payment records, status, provider data
- **Review** — Ratings and feedback
- **Notification** — Push notification history

## Testing

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Watch mode
npm run test:watch
```

## Project Structure

```
backend/
├── src/
│   ├── api/
│   │   ├── routes/        # Express route definitions
│   │   └── controllers/   # Request handlers
│   ├── config/            # DB, encryption, payment configs
│   ├── models/            # Mongoose schemas
│   ├── services/
│   │   ├── auth/          # Authentication & OTP logic
│   │   ├── payments/      # MTN & Orange Money adapters
│   │   ├── video/         # Encryption & streaming
│   │   └── notifications/ # FCM push notification service
│   └── utils/             # Error handler, logger, validators
├── tests/                 # Jest test files
├── server.js              # Entry point
└── package.json
```
