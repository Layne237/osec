const express = require('express');
const { body } = require('express-validator');
const notificationController = require('../controllers/notificationController');
const { validate } = require('../middlewares/validationMiddleware');

const router = express.Router();

router.post(
  '/register',
  validate([
    body('deviceToken').notEmpty().withMessage('deviceToken is required'),
    body('platform').notEmpty().withMessage('platform is required')
  ]),
  notificationController.registerDevice
);

router.get('/', notificationController.getNotifications);
router.patch('/:id/read', notificationController.markRead);

module.exports = router;
