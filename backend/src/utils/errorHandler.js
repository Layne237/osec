const logger = require('./logger');

const errorHandler = (err, req, res, next) => {
  logger.error(err.message || 'Unhandled error', err);

  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    error: {
      code: err.code || 'INTERNAL_ERROR',
      message: err.message || 'Internal server error'
    },
    timestamp: new Date().toISOString()
  });
};

module.exports = errorHandler;
