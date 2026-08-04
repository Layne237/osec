const express = require('express');
const videoController = require('../controllers/videoController');

const router = express.Router();

router.get('/:courseId/lessons/:lessonId/stream', videoController.getStreamUrl);
router.post('/:courseId/lessons/:lessonId/offline', videoController.getOfflinePackage);

module.exports = router;
