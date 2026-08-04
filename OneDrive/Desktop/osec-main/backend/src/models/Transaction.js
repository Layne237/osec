const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema({
  transactionId: {
    type: String,
    required: true,
    unique: true,
  },
  userId: {
    type: String,
    required: true,
  },
  courseId: {
    type: String,
    required: true,
  },
  amount: {
    type: Number,
    required: true,
  },
  currency: {
    type: String,
    default: 'XAF',
  },
  method: {
    type: String,
    enum: ['mtn_momo', 'orange_money', 'card'],
    required: true,
  },
  phone: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    enum: ['pending', 'completed', 'failed', 'refunded'],
    default: 'pending',
  },
  providerReference: {
    type: String,
    required: true,
  },
  externalId: {
    type: String,
  },
  metadata: {
    type: Map,
    of: String,
  },
}, {
  timestamps: true,
});

module.exports = mongoose.model('Transaction', transactionSchema);
