const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
  notificationId: {
    type: String,
    required: true,
    unique: true,
  },
  userId: {
    type: String,
    index: true,
  },
  deviceToken: {
    type: String,
  },
  platform: {
    type: String,
    enum: ['android', 'ios', 'web'],
    default: 'android',
  },
  locale: {
    type: String,
    default: 'fr',
  },
  type: {
    type: String,
    enum: ['course_update', 'payment_success', 'promotional', 'system'],
    default: 'system',
  },
  title: {
    type: String,
    required: true,
  },
  body: {
    type: String,
    required: true,
  },
  read: {
    type: Boolean,
    default: false,
  },
  metadata: {
    type: Map,
    of: String,
  },
}, {
  timestamps: true,
});

module.exports = mongoose.model('Notification', notificationSchema);
