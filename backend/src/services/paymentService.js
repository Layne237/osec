const mongoose = require('mongoose');
const Transaction = require('../models/Transaction');
const Course = require('../models/Course');
const User = require('../models/User');
const { inMemoryUsers } = require('./authService');
const logger = require('../utils/logger');

const inMemoryTransactions = [];
const isDbConnected = () => mongoose.connection.readyState === 1;

const initiatePayment = async ({ userId = 'user_demo', courseId, method, phone, currency = 'XAF' }) => {
  let coursePrice = 25000;
  if (isDbConnected()) {
    try {
      const course = await Course.findOne({ $or: [{ id: courseId }, { courseId }] });
      if (course) {
        coursePrice = course.price;
      }
    } catch (err) {
      // fallback default
    }
  }

  const transactionId = `txn_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
  const providerReference = method === 'mtn_momo'
    ? `MOMOPAY-REF-${Date.now()}`
    : `ORANGE-REF-${Date.now()}`;

  const transactionData = {
    transactionId,
    userId,
    courseId,
    amount: coursePrice,
    currency,
    method,
    phone,
    status: 'pending',
    providerReference,
    createdAt: new Date().toISOString()
  };

  if (isDbConnected()) {
    try {
      await Transaction.create(transactionData);
    } catch (err) {
      inMemoryTransactions.push(transactionData);
    }
  } else {
    inMemoryTransactions.push(transactionData);
  }

  logger.info(`[Payment Service] Initiated ${method} payment for course ${courseId} by user ${userId}`);

  return {
    transactionId,
    status: 'pending',
    amount: coursePrice,
    currency,
    method,
    providerReference,
    instructions: method === 'mtn_momo'
      ? 'Please approve the prompt on your mobile phone to complete MTN MoMo transfer.'
      : 'Dial #150# or approve the Orange Money request on your phone.'
  };
};

const confirmPayment = async ({ transactionId, status = 'successful', providerReference, amount }) => {
  let transaction = null;

  if (isDbConnected()) {
    try {
      transaction = await Transaction.findOne({ transactionId });
    } catch (err) {
      transaction = null;
    }
  }

  if (!transaction) {
    transaction = inMemoryTransactions.find(t => t.transactionId === transactionId);
  }

  if (!transaction) {
    const error = new Error('Transaction not found');
    error.statusCode = 404;
    error.code = 'NOT_FOUND';
    throw error;
  }

  const finalStatus = status === 'successful' ? 'completed' : 'failed';
  transaction.status = finalStatus;
  if (providerReference) transaction.providerReference = providerReference;
  if (amount) transaction.amount = amount;

  if (transaction.save) {
    await transaction.save();
  }

  let accessGranted = false;
  if (finalStatus === 'completed') {
    accessGranted = true;
    if (isDbConnected()) {
      try {
        await User.updateOne(
          { _id: transaction.userId },
          { $addToSet: { enrolledCourses: transaction.courseId } }
        );
      } catch (err) {
        // fallback
      }
    }
    const u = inMemoryUsers.find(user => user.id === transaction.userId || user._id === transaction.userId);
    if (u) {
      if (!u.enrolledCourses) u.enrolledCourses = [];
      if (!u.enrolledCourses.includes(transaction.courseId)) {
        u.enrolledCourses.push(transaction.courseId);
      }
    }
  }

  logger.info(`[Payment Service] Payment confirmed for transaction ${transactionId}, status: ${finalStatus}`);

  return {
    transactionId: transaction.transactionId || transactionId,
    status: finalStatus,
    courseId: transaction.courseId,
    amount: transaction.amount,
    accessGranted
  };
};

const getTransactionHistory = async (userId) => {
  if (isDbConnected()) {
    try {
      const txs = await Transaction.find(userId ? { userId } : {}).sort({ createdAt: -1 });
      if (txs.length) return txs;
    } catch (err) {
      // fallback
    }
  }
  return inMemoryTransactions;
};

module.exports = {
  initiatePayment,
  confirmPayment,
  getTransactionHistory,
  inMemoryTransactions
};
