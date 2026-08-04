const notificationService = require('../../services/notificationService');

const createResponse = (data, message = 'Operation successful', statusCode = 200) => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString()
});

const registerDevice = async (req, res, next) => {
  try {
    const userId = req.user ? req.user.sub : 'user_demo';
    const data = await notificationService.registerDevice({ ...req.body, userId });
    res.json(createResponse(data, 'Device registered successfully'));
  } catch (error) {
    next(error);
  }
};

const getNotifications = async (req, res, next) => {
  try {
    const userId = req.user ? req.user.sub : 'user_demo';
    const data = await notificationService.getUserNotifications(userId);
    res.json(createResponse(data, 'Notifications retrieved'));
  } catch (error) {
    next(error);
  }
};

const markRead = async (req, res, next) => {
  try {
    const { id } = req.params;
    const userId = req.user ? req.user.sub : 'user_demo';
    const data = await notificationService.markAsRead(id, userId);
    res.json(createResponse(data, 'Notification marked as read'));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  registerDevice,
  getNotifications,
  markRead
};
