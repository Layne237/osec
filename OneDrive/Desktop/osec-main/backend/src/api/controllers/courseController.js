const Course = require('../../models/Course');

const initialCourses = [
  {
    id: 'course_001',
    courseId: 'course_001',
    title: 'Dropshipping Masterclass',
    titleFr: 'Masterclass Dropshipping',
    description: 'Learn complete dropshipping from A to Z across Francophone Africa.',
    thumbnail: 'https://cdn.osec.com/thumbnails/abc123.jpg',
    price: 25000,
    currency: 'XAF',
    instructor: { name: 'Jane Trainer', avatar: 'https://cdn.osec.com/avatars/jane.jpg' },
    rating: 4.7,
    studentsCount: 1234,
    duration: '12h 30m',
    difficulty: 'intermediate',
    category: 'business',
    language: 'fr',
    chapters: [
      {
        id: 'ch1',
        title: 'Getting Started',
        lessons: [
          { id: 'l1', title: 'Introduction to Dropshipping', duration: '15:30', isFree: true, order: 1, videoKey: 'intro.mp4' },
          { id: 'l2', title: 'Finding Winning Products', duration: '22:15', isFree: false, order: 2, videoKey: 'products.mp4' }
        ]
      }
    ],
    requirements: ['No prior experience needed', 'A smartphone or computer with internet'],
    whatYouWillLearn: ['Set up an e-commerce store', 'Target African consumers', 'Integrate Mobile Money payments']
  },
  {
    id: 'course_002',
    courseId: 'course_002',
    title: 'Mobile Money Growth',
    titleFr: 'Croissance par Mobile Money',
    description: 'Explore customer acquisition and seamless Mobile Money payment conversion journeys.',
    thumbnail: 'https://cdn.osec.com/thumbnails/xyz789.jpg',
    price: 18000,
    currency: 'XAF',
    instructor: { name: 'Kofi Trainer', avatar: 'https://cdn.osec.com/avatars/kofi.jpg' },
    rating: 4.5,
    studentsCount: 980,
    duration: '8h 15m',
    difficulty: 'beginner',
    category: 'marketing',
    language: 'en',
    chapters: [
      {
        id: 'ch1',
        title: 'Mobile Money Overview',
        lessons: [
          { id: 'l1', title: 'MTN & Orange Money Ecosystem', duration: '18:00', isFree: true, order: 1, videoKey: 'momo.mp4' }
        ]
      }
    ],
    requirements: ['Basic business knowledge'],
    whatYouWillLearn: ['Master MTN MoMo API concepts', 'Optimize checkout conversion rates']
  }
];

let inMemoryCourses = [...initialCourses];

const createResponse = (data, message = 'Operation successful', statusCode = 200) => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString()
});

const getCourses = async (req, res, next) => {
  try {
    const { page = 1, limit = 20, category, difficulty, language, search } = req.query;
    let list = [];

    try {
      const query = { isPublished: true };
      if (category) query.category = category;
      if (difficulty) query.difficulty = difficulty;
      if (language) query.language = language;
      if (search) {
        query.$or = [
          { title: { $regex: search, $options: 'i' } },
          { description: { $regex: search, $options: 'i' } }
        ];
      }

      list = await Course.find(query).limit(parseInt(limit)).skip((parseInt(page) - 1) * parseInt(limit));
    } catch (err) {
      list = inMemoryCourses;
    }

    if (!list || !list.length) {
      list = inMemoryCourses;
    }

    let filtered = list;
    if (category) filtered = filtered.filter(c => c.category === category);
    if (difficulty) filtered = filtered.filter(c => c.difficulty === difficulty);
    if (language) filtered = filtered.filter(c => c.language === language);
    if (search) {
      const q = search.toLowerCase();
      filtered = filtered.filter(c => (c.title && c.title.toLowerCase().includes(q)) || (c.description && c.description.toLowerCase().includes(q)));
    }

    const formattedCourses = filtered.map(c => ({
      id: c.courseId || c.id || c._id,
      title: c.title,
      titleFr: c.titleFr || c.title,
      description: c.description,
      thumbnail: c.thumbnail,
      price: c.price,
      currency: c.currency || 'XAF',
      instructor: c.instructor,
      rating: c.rating || 4.5,
      studentsCount: c.studentsCount || 0,
      duration: c.duration || '10h 00m',
      difficulty: c.difficulty || 'beginner',
      category: c.category || 'general',
      language: c.language || 'fr'
    }));

    res.json(createResponse({
      courses: formattedCourses,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: formattedCourses.length,
        pages: 1
      }
    }));
  } catch (error) {
    next(error);
  }
};

const getCourseById = async (req, res, next) => {
  try {
    const { id } = req.params;
    let course = null;

    try {
      course = await Course.findOne({ $or: [{ courseId: id }, { id }, { _id: id }] });
    } catch (err) {
      course = inMemoryCourses.find(c => c.id === id || c.courseId === id);
    }

    if (!course) {
      course = inMemoryCourses.find(c => c.id === id || c.courseId === id);
    }

    if (!course) {
      return res.status(404).json({
        success: false,
        error: { code: 'NOT_FOUND', message: 'Course not found' },
        timestamp: new Date().toISOString()
      });
    }

    res.json(createResponse({
      id: course.courseId || course.id || course._id,
      title: course.title,
      titleFr: course.titleFr || course.title,
      description: course.description,
      thumbnail: course.thumbnail,
      price: course.price,
      currency: course.currency || 'XAF',
      instructor: course.instructor,
      rating: course.rating,
      studentsCount: course.studentsCount,
      duration: course.duration,
      difficulty: course.difficulty,
      category: course.category,
      chapters: course.chapters || [
        {
          id: 'ch1',
          title: 'Getting Started',
          lessons: [{ id: 'l1', title: 'Introduction', duration: '15:30', isFree: true, order: 1 }]
        }
      ],
      requirements: course.requirements || ['No prior experience needed'],
      whatYouWillLearn: course.whatYouWillLearn || ['Set up a store', 'Find winning products']
    }));
  } catch (error) {
    next(error);
  }
};

const createCourse = async (req, res, next) => {
  try {
    const newCourseData = {
      courseId: `course_${Date.now()}`,
      id: `course_${Date.now()}`,
      ...req.body
    };

    let course = null;
    try {
      course = await Course.create(newCourseData);
    } catch (err) {
      inMemoryCourses.push(newCourseData);
      course = newCourseData;
    }

    res.status(201).json(createResponse(course, 'Course created successfully', 201));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getCourses,
  getCourseById,
  createCourse,
  inMemoryCourses
};
