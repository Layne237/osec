const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const dotenv = require('dotenv');

const authRoutes = require('./src/api/routes/authRoutes');
const courseRoutes = require('./src/api/routes/courseRoutes');
const paymentRoutes = require('./src/api/routes/paymentRoutes');
const videoRoutes = require('./src/api/routes/videoRoutes');
const notificationRoutes = require('./src/api/routes/notificationRoutes');
<<<<<<< HEAD
const errorHandler = require('./src/utils/errorHandler');
const logger = require('./src/utils/logger');
const { connectDatabase } = require('./src/config/database');
=======
const reviewRoutes = require('./src/api/routes/reviewRoutes');
const analyticsRoutes = require('./src/api/routes/analyticsRoutes');
const errorHandler = require('./src/utils/errorHandler');
const logger = require('./src/utils/logger');
const { connectDatabase } = require('./src/config/database');
const { seedData } = require('./src/utils/seed');
>>>>>>> baf62f8 (Initialize repository in project folder)

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CORS_ORIGIN || '*',
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 60 * 1000,
<<<<<<< HEAD
  max: 100,
=======
  max: 200,
>>>>>>> baf62f8 (Initialize repository in project folder)
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(limiter);

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/api/v1/health', (req, res) => {
  res.json({ success: true, message: 'OSEC API is running', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/courses', courseRoutes);
app.use('/api/v1/payments', paymentRoutes);
app.use('/api/v1/courses', videoRoutes);
app.use('/api/v1/notifications', notificationRoutes);
<<<<<<< HEAD
=======
app.use('/api/v1/reviews', reviewRoutes);
app.use('/api/v1/analytics', analyticsRoutes);
>>>>>>> baf62f8 (Initialize repository in project folder)

// Error handling
app.use(errorHandler);

// Start server
const startServer = async () => {
  try {
    await connectDatabase();
<<<<<<< HEAD
=======
    await seedData();
>>>>>>> baf62f8 (Initialize repository in project folder)
    app.listen(PORT, () => {
      logger.info(`OSEC API server running on port ${PORT}`);
    });
  } catch (error) {
    logger.error('Failed to start server:', error);
    process.exit(1);
  }
};

<<<<<<< HEAD
startServer();
=======
if (require.main === module) {
  startServer();
}
>>>>>>> baf62f8 (Initialize repository in project folder)

module.exports = app;
