# OSEC API Design

## Base URL

- **Development:** `http://localhost:3000/api/v1`
- **Staging:** `https://staging-api.osec.com/api/v1`
- **Production:** `https://api.osec.com/api/v1`

## Authentication

All endpoints except `/auth/*` require a Bearer JWT token in the `Authorization` header:

```
Authorization: Bearer <access_token>
```

Standard response envelope:

```json
{
  "success": true,
  "data": { ... },
  "message": "Operation successful",
  "timestamp": "2026-07-07T12:00:00Z"
}
```

Error response:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid phone number format"
  },
  "timestamp": "2026-07-07T12:00:00Z"
}
```

## Authentication Endpoints

### POST /auth/register
Register a new user.

**Request:**
```json
{
  "phone": "+237670000000",
  "email": "user@example.com",
  "password": "securePassword123",
  "fullName": "John Doe",
  "role": "student"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "userId": "60d5f484f1a2c8b1f8e4e1a1",
    "phone": "+237670000000",
    "fullName": "John Doe",
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "dGhpcyBpcyBhIHJlZnJl..."
  }
}
```

### POST /auth/otp/send
Send OTP verification code.

**Request:**
```json
{
  "phone": "+237670000000",
  "channel": "sms"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "expiresIn": 600
  }
}
```

### POST /auth/otp/verify
Verify OTP code.

**Request:**
```json
{
  "phone": "+237670000000",
  "otp": "123456"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "verified": true,
    "accessToken": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "dGhpcyBpcyBhIHJlZnJl..."
  }
}
```

### POST /auth/refresh
Refresh access token.

**Request:**
```json
{
  "refreshToken": "dGhpcyBpcyBhIHJlZnJl..."
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

## Course Management Endpoints

### GET /courses
List available courses.

**Query Parameters:**
- `page` (int, default: 1)
- `limit` (int, default: 20)
- `category` (string, optional)
- `difficulty` (string: beginner|intermediate|advanced)
- `language` (string: fr|en)
- `search` (string, optional)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "courses": [
      {
        "id": "60d5f484f1a2c8b1f8e4e1b2",
        "title": "Dropshipping Masterclass",
        "titleFr": "Masterclass Dropshipping",
        "description": "Learn complete dropshipping from A to Z",
        "thumbnail": "https://cdn.osec.com/thumbnails/abc123.jpg",
        "price": 25000,
        "currency": "XAF",
        "instructor": {
          "name": "Jane Trainer",
          "avatar": "https://cdn.osec.com/avatars/jane.jpg"
        },
        "rating": 4.7,
        "studentsCount": 1234,
        "duration": "12h 30m",
        "difficulty": "intermediate"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 45,
      "pages": 3
    }
  }
}
```

### GET /courses/:id
Get course details.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "60d5f484f1a2c8b1f8e4e1b2",
    "title": "Dropshipping Masterclass",
    "chapters": [
      {
        "id": "ch1",
        "title": "Getting Started",
        "lessons": [
          {
            "id": "l1",
            "title": "Introduction to Dropshipping",
            "duration": "15:30",
            "isFree": true,
            "order": 1
          }
        ]
      }
    ],
    "requirements": ["No prior experience needed"],
    "whatYouWillLearn": ["Set up a store", "Find winning products"]
  }
}
```

## Payment Endpoints

### POST /payments/initiate
Initiate a course purchase.

**Request:**
```json
{
  "courseId": "60d5f484f1a2c8b1f8e4e1b2",
  "method": "mtn_momo",
  "phone": "+237670000000",
  "currency": "XAF"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "transactionId": "txn_abc123",
    "status": "pending",
    "amount": 25000,
    "currency": "XAF",
    "providerReference": "MOMOPAY-REF-12345"
  }
}
```

### POST /payments/confirm
Webhook to confirm payment status.

**Request (provider callback):**
```json
{
  "transactionId": "txn_abc123",
  "status": "successful",
  "providerReference": "MOMOPAY-REF-12345",
  "amount": 25000
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "transactionId": "txn_abc123",
    "status": "completed",
    "courseId": "60d5f484f1a2c8b1f8e4e1b2",
    "accessGranted": true
  }
}
```

### GET /payments/history
Get user's payment history.

## Video Streaming Endpoints

### GET /courses/:courseId/lessons/:lessonId/stream
Get streaming URL for a lesson.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "streamUrl": "https://cdn.osec.com/encrypted/abc123/lesson1.m3u8?signature=xyz&expires=1710000000",
    "encryptionKey": "encrypted-with-user-public-key",
    "iv": "16-byte-hex-string",
    "duration": 930,
    "allowOffline": true
  }
}
```

### POST /courses/:courseId/lessons/:lessonId/offline
Request offline access for a lesson.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "downloadUrl": "https://cdn.osec.com/offline/encrypted/lesson1.bin?signature=xyz",
    "expiresAt": "2026-07-14T12:00:00Z"
  }
}
```

## Notification Endpoints

### POST /notifications/register
Register device for push notifications.

**Request:**
```json
{
  "deviceToken": "fcm-device-token-abc123",
  "platform": "android",
  "locale": "fr"
}
```

### GET /notifications
List user notifications.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": "notif_1",
        "type": "course_update",
        "title": "New lesson available",
        "body": "Chapter 3 of Dropshipping Masterclass is now available",
        "read": false,
        "createdAt": "2026-07-06T10:00:00Z"
      }
    ],
    "unreadCount": 3
  }
}
```

### PATCH /notifications/:id/read
Mark notification as read.

## Rate Limiting

- **Standard endpoints:** 100 requests/minute per IP
- **Auth endpoints:** 10 requests/minute per IP (OTP resend: 1 request/60s)
- **Video streaming:** 50 requests/minute per user

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid request parameters |
| `UNAUTHORIZED` | 401 | Missing or invalid token |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `PAYMENT_FAILED` | 402 | Payment processing error |
| `RATE_LIMITED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |
