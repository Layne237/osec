const Review = require('../../models/Review');
const Course = require('../../models/Course');

const inMemoryReviews = [
  {
    reviewId: 'rev_1',
    courseId: 'course_001',
    userId: 'user_101',
    userName: 'Amadou Diallo',
    userAvatar: 'https://cdn.osec.com/avatars/amadou.jpg',
    rating: 5,
    comment: 'Excellente formation! J\'ai pu lancer ma boutique en 2 semaines.',
    createdAt: new Date().toISOString()
  },
  {
    reviewId: 'rev_2',
    courseId: 'course_001',
    userId: 'user_102',
    userName: 'Fatou Ndiaye',
    userAvatar: 'https://cdn.osec.com/avatars/fatou.jpg',
    rating: 4.5,
    comment: 'Très clair et adapté au marché africain.',
    createdAt: new Date().toISOString()
  }
];

const createResponse = (data, message = 'Operation successful', statusCode = 200) => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString()
});

const getCourseReviews = async (req, res, next) => {
  try {
    const { courseId } = req.params;
    let list = [];

    try {
      list = await Review.find({ courseId }).sort({ createdAt: -1 });
    } catch (err) {
      list = inMemoryReviews.filter(r => r.courseId === courseId);
    }

    if (!list.length) {
      list = inMemoryReviews.filter(r => r.courseId === courseId);
    }

    res.json(createResponse({
      courseId,
      reviews: list,
      total: list.length,
      averageRating: list.length ? (list.reduce((acc, r) => acc + r.rating, 0) / list.length).toFixed(1) : 4.5
    }));
  } catch (error) {
    next(error);
  }
};

const addReview = async (req, res, next) => {
  try {
    const { courseId } = req.params;
    const { rating, comment } = req.body;
    const userId = req.user ? req.user.sub : 'user_demo';
    const userName = req.user && req.user.fullName ? req.user.fullName : 'OSEC Student';

    const reviewData = {
      reviewId: `rev_${Date.now()}`,
      courseId,
      userId,
      userName,
      userAvatar: 'https://cdn.osec.com/avatars/default.jpg',
      rating: parseFloat(rating),
      comment,
      createdAt: new Date().toISOString()
    };

    try {
      await Review.create(reviewData);
    } catch (err) {
      inMemoryReviews.push(reviewData);
    }

    res.status(201).json(createResponse(reviewData, 'Review added successfully', 201));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getCourseReviews,
  addReview
};
