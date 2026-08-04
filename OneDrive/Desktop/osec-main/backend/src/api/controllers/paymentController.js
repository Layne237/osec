const paymentService = require('../../services/paymentService');

const createResponse = (data, message = 'Operation successful', statusCode = 200) => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString()
});

const initiatePayment = async (req, res, next) => {
  try {
    const userId = req.user ? req.user.sub : 'user_demo';
    const data = await paymentService.initiatePayment({ ...req.body, userId });
    res.json(createResponse(data, 'Payment initiated successfully'));
  } catch (error) {
    next(error);
  }
};

const confirmPayment = async (req, res, next) => {
  try {
    const data = await paymentService.confirmPayment(req.body);
    res.json(createResponse(data, 'Payment confirmed'));
  } catch (error) {
    next(error);
  }
};

const getHistory = async (req, res, next) => {
  try {
    const userId = req.user ? req.user.sub : null;
    const transactions = await paymentService.getTransactionHistory(userId);
    res.json(createResponse({ transactions }));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  initiatePayment,
  confirmPayment,
  getHistory
};
