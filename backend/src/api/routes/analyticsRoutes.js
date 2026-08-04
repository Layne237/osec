const express = require('express');
const analyticsController = require('../controllers/analyticsController');
const { authenticate, authorize } = require('../middlewares/authMiddleware');

const router = express.Router();

router.get('/trainer', authenticate, authorize('trainer', 'admin'), analyticsController.getTrainerStats);
router.get('/admin', authenticate, authorize('admin'), analyticsController.getAdminStats);

module.exports = router;
