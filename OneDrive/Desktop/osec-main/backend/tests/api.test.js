process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'dev-secret';

const request = require('supertest');
const app = require('../server');

describe('OSEC Backend API Complete Test Suite', () => {
  let accessToken = '';
  let refreshToken = '';
  let transactionId = '';

  it('GET /api/v1/health returns 200 OK and health payload', async () => {
    const res = await request(app).get('/api/v1/health');
    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.message).toContain('OSEC API is running');
  });

  describe('Authentication Endpoints', () => {
    it('POST /api/v1/auth/register registers user and returns tokens', async () => {
      const res = await request(app).post('/api/v1/auth/register').send({
        phone: '+237670000000',
        email: 'student@example.com',
        password: 'SecurePassword123!',
        fullName: 'Test Student',
        role: 'student'
      });

      expect(res.status).toBe(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data.accessToken).toBeTruthy();
      expect(res.body.data.refreshToken).toBeTruthy();

      accessToken = res.body.data.accessToken;
      refreshToken = res.body.data.refreshToken;
    });

    it('POST /api/v1/auth/login authenticates registered user', async () => {
      const res = await request(app).post('/api/v1/auth/login').send({
        emailOrPhone: 'student@example.com',
        password: 'SecurePassword123!'
      });

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.accessToken).toBeTruthy();
    });

    it('POST /api/v1/auth/otp/send generates OTP verification code', async () => {
      const res = await request(app).post('/api/v1/auth/otp/send').send({
        phone: '+237670000000'
      });

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.expiresIn).toBe(600);
    });

    it('POST /api/v1/auth/otp/verify verifies code and issues tokens', async () => {
      const res = await request(app).post('/api/v1/auth/otp/verify').send({
        phone: '+237670000000',
        otp: '123456'
      });

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.verified).toBe(true);
    });

    it('POST /api/v1/auth/refresh refreshes access token', async () => {
      const res = await request(app).post('/api/v1/auth/refresh').send({
        refreshToken
      });

      expect(res.status).toBe(200);
      expect(res.body.data.accessToken).toBeTruthy();
    });

    it('GET /api/v1/auth/profile requires bearer token', async () => {
      const res = await request(app)
        .get('/api/v1/auth/profile')
        .set('Authorization', `Bearer ${accessToken}`);

      expect(res.status).toBe(200);
      expect(res.body.data.userId).toBeTruthy();
    });
  });

  describe('Course Endpoints', () => {
    it('GET /api/v1/courses returns courses list with pagination', async () => {
      const res = await request(app).get('/api/v1/courses');
      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data.courses)).toBe(true);
      expect(res.body.data.courses.length).toBeGreaterThan(0);
    });

    it('GET /api/v1/courses/:id returns single course details', async () => {
      const res = await request(app).get('/api/v1/courses/course_001');
      expect(res.status).toBe(200);
      expect(res.body.data.id).toBe('course_001');
      expect(res.body.data.chapters).toBeTruthy();
    });
  });

  describe('Payment Endpoints', () => {
    it('POST /api/v1/payments/initiate starts Mobile Money payment', async () => {
      const res = await request(app).post('/api/v1/payments/initiate').send({
        courseId: 'course_001',
        method: 'mtn_momo',
        phone: '+237670000000',
        currency: 'XAF'
      });

      expect(res.status).toBe(200);
      expect(res.body.data.status).toBe('pending');
      expect(res.body.data.providerReference).toBeTruthy();

      transactionId = res.body.data.transactionId;
    });

    it('POST /api/v1/payments/confirm confirms transaction webhook', async () => {
      const res = await request(app).post('/api/v1/payments/confirm').send({
        transactionId,
        status: 'successful'
      });

      expect(res.status).toBe(200);
      expect(res.body.data.status).toBe('completed');
      expect(res.body.data.accessGranted).toBe(true);
    });

    it('GET /api/v1/payments/history returns user transaction history', async () => {
      const res = await request(app).get('/api/v1/payments/history');
      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data.transactions)).toBe(true);
    });
  });

  describe('Video DRM Streaming Endpoints', () => {
    it('GET /api/v1/courses/:courseId/lessons/:lessonId/stream returns DRM signed stream URL', async () => {
      const res = await request(app).get('/api/v1/courses/course_001/lessons/l1/stream');
      expect(res.status).toBe(200);
      expect(res.body.data.streamUrl).toContain('m3u8');
      expect(res.body.data.encryptionKey).toBeTruthy();
      expect(res.body.data.iv).toBeTruthy();
    });

    it('POST /api/v1/courses/:courseId/lessons/:lessonId/offline returns encrypted download package URL', async () => {
      const res = await request(app).post('/api/v1/courses/course_001/lessons/l1/offline');
      expect(res.status).toBe(200);
      expect(res.body.data.downloadUrl).toBeTruthy();
      expect(res.body.data.checksum).toBeTruthy();
    });
  });

  describe('Notification Endpoints', () => {
    it('POST /api/v1/notifications/register registers device token', async () => {
      const res = await request(app).post('/api/v1/notifications/register').send({
        deviceToken: 'fcm-device-token-12345',
        platform: 'android',
        locale: 'fr'
      });

      expect(res.status).toBe(200);
      expect(res.body.data.registered).toBe(true);
    });

    it('GET /api/v1/notifications retrieves user notifications', async () => {
      const res = await request(app).get('/api/v1/notifications');
      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data.notifications)).toBe(true);
    });
  });

  describe('Reviews Endpoints', () => {
    it('GET /api/v1/reviews/:courseId retrieves course reviews', async () => {
      const res = await request(app).get('/api/v1/reviews/course_001');
      expect(res.status).toBe(200);
      expect(Array.isArray(res.body.data.reviews)).toBe(true);
    });

    it('POST /api/v1/reviews/:courseId creates a review', async () => {
      const res = await request(app).post('/api/v1/reviews/course_001').send({
        rating: 5,
        comment: 'Un cours vraiment complet!'
      });

      expect(res.status).toBe(201);
      expect(res.body.data.reviewId).toBeTruthy();
    });
  });
});
