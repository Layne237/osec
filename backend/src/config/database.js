const mongoose = require('mongoose');
const logger = require('../utils/logger');

// Disable Mongoose command buffering when disconnected to prevent request hangs
mongoose.set('bufferCommands', false);

const connectDatabase = async () => {
  if (mongoose.connection.readyState >= 1) {
    return mongoose.connection;
  }

  // Fast skip if running tests or no local database available
  if (process.env.NODE_ENV === 'test' || process.env.SKIP_DB === 'true') {
    logger.info('Running with fast in-memory storage fallback');
    return mongoose.connection;
  }

  const uri = process.env.DATABASE_URL || 'mongodb://127.0.0.1:27017/osec';

  try {
    await mongoose.connect(uri, {
      serverSelectionTimeoutMS: 500
    });
    logger.info('Database connected');
  } catch (error) {
    logger.warn(`Database unavailable, continuing with in-memory persistence: ${error.message}`);
  }

  return mongoose.connection;
};

module.exports = { connectDatabase };
