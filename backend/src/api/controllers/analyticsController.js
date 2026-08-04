const analyticsService = require('../../services/analyticsService');

const createResponse = (data, message = 'Operation successful', statusCode = 200) => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString()
});

const getTrainerStats = async (req, res, next) => {
  try {
    const trainerId = req.user ? req.user.sub : 'trainer_001';
    const data = await analyticsService.getTrainerAnalytics(trainerId);
    res.json(createResponse(data, 'Trainer analytics fetched successfully'));
  } catch (error) {
    next(error);
  }
};

const getAdminStats = async (req, res, next) => {
  try {
    const data = await analyticsService.getAdminAnalytics();
    res.json(createResponse(data, 'Admin platform analytics fetched successfully'));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getTrainerStats,
  getAdminStats
};
