const Course = require('../models/Course');
const User = require('../models/User');
const logger = require('./logger');

const seedData = async () => {
  try {
    const userCount = await User.countDocuments();
    if (userCount === 0) {
      await User.create([
        {
          phone: '+237670000000',
          email: 'student@osec.com',
          password: 'SecurePassword123!',
          fullName: 'Democratized Student',
          role: 'student',
          isVerified: true
        },
        {
          phone: '+237690000000',
          email: 'trainer@osec.com',
          password: 'SecurePassword123!',
          fullName: 'Jane Trainer',
          role: 'trainer',
          isVerified: true
        }
      ]);
      logger.info('Default seed users created.');
    }

    const courseCount = await Course.countDocuments();
    if (courseCount === 0) {
      await Course.create([
        {
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
          courseId: 'course_002',
          title: 'Mobile Money Growth',
          titleFr: 'Croissance par Mobile Money',
          description: 'Explore customer acquisition and payment conversion journeys using MTN & Orange Money.',
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
      ]);
      logger.info('Default seed courses created.');
    }
  } catch (err) {
    logger.warn(`Seed step skipped (database offline or read-only): ${err.message}`);
  }
};

module.exports = { seedData };
