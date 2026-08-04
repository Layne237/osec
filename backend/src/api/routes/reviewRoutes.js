const express = require('express');
const { body } = require('express-validator');
const reviewController = require('../controllers/reviewController');
const { validate } = require('../middlewares/validationMiddleware');

const router = express.Router();

router.get('/:courseId', reviewController.getCourseReviews);
router.post(
  '/:courseId',
  validate([
    body('rating').isFloat({ min: 1, max: 5 }).withMessage('Rating must be between 1 and 5'),
    body('comment').notEmpty().withMessage('Comment is required')
  ]),
  reviewController.addReview
);

module.exports = router;
