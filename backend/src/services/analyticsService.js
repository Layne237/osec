const Course = require('../models/Course');
const Transaction = require('../models/Transaction');

const getTrainerAnalytics = async (trainerId = 'trainer_001') => {
  return {
    trainerId,
    period: 'last_30_days',
    overview: {
      totalRevenue: 2850000,
      currency: 'XAF',
      totalStudents: 2214,
      activeCourses: 4,
      averageRating: 4.8,
      totalReviews: 342,
      completionRate: 78.5
    },
    monthlyRevenue: [
      { month: 'Jan', revenue: 450000 },
      { month: 'Feb', revenue: 620000 },
      { month: 'Mar', revenue: 780000 },
      { month: 'Apr', revenue: 1000000 }
    ],
    topCourses: [
      { id: 'course_001', title: 'Dropshipping Masterclass', revenue: 1650000, students: 1234 },
      { id: 'course_002', title: 'Mobile Money Growth', revenue: 1200000, students: 980 }
    ]
  };
};

const getAdminAnalytics = async () => {
  return {
    platform: 'OSEC',
    metrics: {
      totalUsers: 14500,
      totalTrainers: 28,
      totalCourses: 65,
      totalTransactions: 9420,
      grossVolume: 124500000,
      currency: 'XAF'
    },
    paymentMethodsBreakdown: [
      { method: 'mtn_momo', percentage: 65.4, count: 6160 },
      { method: 'orange_money', percentage: 34.6, count: 3260 }
    ]
  };
};

module.exports = {
  getTrainerAnalytics,
  getAdminAnalytics
};
