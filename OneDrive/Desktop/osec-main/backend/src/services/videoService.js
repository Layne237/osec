const crypto = require('crypto');
const logger = require('../utils/logger');

const getVideoStreamUrl = async (courseId, lessonId, userId = 'user_demo') => {
  const expiresAt = Math.floor(Date.now() / 1000) + 3600; // 1 hour expiration
  const cdnDomain = process.env.CLOUDFRONT_DOMAIN || 'cdn.osec.com';

  // Generate HLS stream signature
  const hmac = crypto.createHmac('sha256', process.env.JWT_SECRET || 'dev-secret');
  hmac.update(`${courseId}/${lessonId}/${userId}/${expiresAt}`);
  const signature = hmac.digest('hex');

  // Encryption key and IV for DRM overlay playback in mobile app
  const encryptionKey = process.env.VIDEO_ENCRYPTION_KEY || crypto.randomBytes(16).toString('hex');
  const iv = process.env.VIDEO_ENCRYPTION_IV || crypto.randomBytes(8).toString('hex');

  logger.info(`[Video Service] Generated stream signature for course ${courseId}, lesson ${lessonId}`);

  return {
    streamUrl: `https://${cdnDomain}/encrypted/${courseId}/${lessonId}.m3u8?signature=${signature}&expires=${expiresAt}`,
    encryptionKey,
    iv,
    duration: 930,
    allowOffline: true,
    expiresAt: new Date(expiresAt * 1000).toISOString()
  };
};

const getOfflineDownloadUrl = async (courseId, lessonId, userId = 'user_demo') => {
  const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(); // 24 hour offline package token
  const cdnDomain = process.env.CLOUDFRONT_DOMAIN || 'cdn.osec.com';

  const token = crypto.randomBytes(32).toString('hex');

  return {
    downloadUrl: `https://${cdnDomain}/offline/encrypted/${lessonId}.bin?token=${token}`,
    packageSize: 154857600, // ~150 MB encrypted binary chunk
    checksum: crypto.createHash('sha256').update(lessonId).digest('hex'),
    expiresAt
  };
};

module.exports = {
  getVideoStreamUrl,
  getOfflineDownloadUrl
};
