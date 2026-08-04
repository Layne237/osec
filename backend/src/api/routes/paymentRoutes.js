const express = require('express');
const { body } = require('express-validator');
const paymentController = require('../controllers/paymentController');
const { validate } = require('../middlewares/validationMiddleware');

const router = express.Router();

router.post(
  '/initiate',
  validate([
    body('courseId').notEmpty().withMessage('courseId is required'),
    body('method').isIn(['mtn_momo', 'orange_money', 'card']).withMessage('Valid method required (mtn_momo, orange_money, card)'),
    body('phone').notEmpty().withMessage('Phone number is required')
  ]),
  paymentController.initiatePayment
);

router.post(
  '/confirm',
  validate([
    body('transactionId').notEmpty().withMessage('transactionId is required')
  ]),
  paymentController.confirmPayment
);

router.get('/history', paymentController.getHistory);

module.exports = router;
