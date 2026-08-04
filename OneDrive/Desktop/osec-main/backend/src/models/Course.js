const mongoose = require('mongoose');

const lessonSchema = new mongoose.Schema({
  id: { type: String, required: true },
  title: { type: String, required: true },
  duration: { type: String, default: '10:00' },
  isFree: { type: Boolean, default: false },
  order: { type: Number, default: 1 },
  videoKey: { type: String, default: '' }
});

const chapterSchema = new mongoose.Schema({
  id: { type: String, required: true },
  title: { type: String, required: true },
  lessons: [lessonSchema]
});

const courseSchema = new mongoose.Schema({
  courseId: {
    type: String,
    unique: true,
    sparse: true
  },
  title: {
    type: String,
    required: true,
    trim: true,
  },
  titleFr: {
    type: String,
    trim: true,
  },
  description: {
    type: String,
    required: true,
  },
  thumbnail: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
    min: 0,
  },
  currency: {
    type: String,
    default: 'XAF',
  },
  instructor: {
    name: { type: String, required: true },
    avatar: { type: String, default: 'https://cdn.osec.com/avatars/default.jpg' },
    bio: { type: String, default: '' },
    id: { type: String }
  },
  rating: {
    type: Number,
    default: 4.5,
    min: 0,
    max: 5,
  },
  reviewsCount: {
    type: Number,
    default: 0,
  },
  studentsCount: {
    type: Number,
    default: 0,
  },
  duration: {
    type: String,
    default: '10h 00m',
  },
  difficulty: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced'],
    default: 'beginner',
  },
  category: {
    type: String,
    default: 'general',
  },
  language: {
    type: String,
    enum: ['fr', 'en'],
    default: 'fr',
  },
  isPublished: {
    type: Boolean,
    default: true,
  },
  chapters: [chapterSchema],
  requirements: [{ type: String }],
  whatYouWillLearn: [{ type: String }],
}, {
  timestamps: true,
});

module.exports = mongoose.model('Course', courseSchema);
