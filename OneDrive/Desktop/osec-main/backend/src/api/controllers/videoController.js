const videoService = require('../../services/videoService');

const createResponse = (data, message = 'Operation successful', statusCode = 200) => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString()
});

const getStreamUrl = async (req, res, next) => {
  try {
    const { courseId, lessonId } = req.params;
    const userId = req.user ? req.user.sub : 'user_demo';
    const data = await videoService.getVideoStreamUrl(courseId, lessonId, userId);
    res.json(createResponse(data, 'Stream URL generated successfully'));
  } catch (error) {
    next(error);
  }
};

const getOfflinePackage = async (req, res, next) => {
  try {
    const { courseId, lessonId } = req.params;
    const userId = req.user ? req.user.sub : 'user_demo';
    const data = await videoService.getOfflineDownloadUrl(courseId, lessonId, userId);
    res.json(createResponse(data, 'Offline download package token generated successfully'));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getStreamUrl,
  getOfflinePackage
};
