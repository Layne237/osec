const authService = require('../../services/authService');

const createResponse = (data, message = 'Operation successful', statusCode = 200) => ({
  success: true,
  data,
  message,
  timestamp: new Date().toISOString()
});

const register = async (req, res, next) => {
  try {
    const data = await authService.registerUser(req.body);
    res.status(201).json(createResponse(data, 'User registered successfully', 201));
  } catch (error) {
    next(error);
  }
};

const login = async (req, res, next) => {
  try {
    const data = await authService.loginUser(req.body);
    res.json(createResponse(data, 'Login successful'));
  } catch (error) {
    next(error);
  }
};

const sendOtp = async (req, res, next) => {
  try {
    const data = await authService.sendOtp(req.body);
    res.json(createResponse(data, 'OTP sent successfully'));
  } catch (error) {
    next(error);
  }
};

const verifyOtp = async (req, res, next) => {
  try {
    const data = await authService.verifyOtp(req.body);
    res.json(createResponse(data, 'OTP verified successfully'));
  } catch (error) {
    next(error);
  }
};

const refresh = async (req, res, next) => {
  try {
    const data = await authService.refreshAccessToken(req.body.refreshToken);
    res.json(createResponse(data, 'Access token refreshed'));
  } catch (error) {
    next(error);
  }
};

const getProfile = async (req, res, next) => {
  try {
    res.json(createResponse({
      userId: req.user.sub,
      phone: req.user.phone || '+237670000000',
      email: req.user.email || 'user@example.com',
      role: req.user.role || 'student'
    }));
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  sendOtp,
  verifyOtp,
  refresh,
  getProfile
};
