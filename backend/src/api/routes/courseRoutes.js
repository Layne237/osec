const express = require('express');
const { body } = require('express-validator');
const courseController = require('../controllers/courseController');
const { authenticate, authorize } = require('../middlewares/authMiddleware');
const { validate } = require('../middlewares/validationMiddleware');

const router = express.Router();

router.get('/', courseController.getCourses);
router.get('/:id', courseController.getCourseById);

router.post(
  '/',
  authenticate,
  authorize('trainer', 'admin'),
  validate([
    body('title').notEmpty().withMessage('Course title is required'),
    body('description').notEmpty().withMessage('Description is required'),
    body('price').isNumeric().withMessage('Price must be a number'),
    body('thumbnail').notEmpty().withMessage('Thumbnail URL is required')
  ]),
  courseController.createCourse
);

module.exports = router;
