const express = require('express');
const { body } = require('express-validator');
const authController = require('../controllers/authController');
const { authenticate } = require('../middlewares/authMiddleware');
const { validate } = require('../middlewares/validationMiddleware');

const router = express.Router();

router.post(
  '/register',
  validate([
    body('phone').notEmpty().withMessage('Phone number is required'),
    body('email').isEmail().withMessage('Valid email is required'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
    body('fullName').notEmpty().withMessage('Full name is required')
  ]),
  authController.register
);

router.post(
  '/login',
  validate([
    body('emailOrPhone').notEmpty().withMessage('Email or phone is required'),
    body('password').notEmpty().withMessage('Password is required')
  ]),
  authController.login
);

router.post(
  '/otp/send',
  validate([
    body('phone').notEmpty().withMessage('Phone is required')
  ]),
  authController.sendOtp
);

router.post(
  '/otp/verify',
  validate([
    body('phone').notEmpty().withMessage('Phone is required'),
    body('otp').notEmpty().withMessage('OTP code is required')
  ]),
  authController.verifyOtp
);

router.post(
  '/refresh',
  validate([
    body('refreshToken').notEmpty().withMessage('Refresh token is required')
  ]),
  authController.refresh
);

router.get('/profile', authenticate, authController.getProfile);

module.exports = router;
