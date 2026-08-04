# OSEC System Architecture

## Overview

OSEC follows a client-server architecture with a Flutter-based mobile frontend and a Node.js/Express backend. The system is designed for scalability, security, and offline-first capabilities.

## High-Level Architecture

```
┌──────────────────────┐      ┌──────────────────────────┐
│   Mobile App         │      │   Backend API            │
│   (Flutter)          │◄────►│   (Node.js/Express)      │
│                      │      │                          │
│  ┌────────────────┐  │      │  ┌────────────────────┐  │
│  │ Presentation   │  │      │  │ Routes/Controllers │  │
│  │ Layer          │  │      │  └────────┬───────────┘  │
│  └───────┬────────┘  │      │           │              │
│          │           │      │  ┌────────▼───────────┐  │
│  ┌───────▼────────┐  │      │  │ Services Layer     │  │
│  │ Domain Layer   │  │      │  │ ┌────┬────┬──────┐ │  │
│  │ (Use Cases)    │  │      │  │ │Auth│Pay │Video │ │  │
│  └───────┬────────┘  │      │  │ └────┴────┴──────┘ │  │
│          │           │      │  └────────┬───────────┘  │
│  ┌───────▼────────┐  │      │           │              │
│  │ Data Layer     │  │      │  ┌────────▼───────────┐  │
│  │ (Repositories) │  │      │  │ Models (Mongoose)  │  │
│  └───────┬────────┘  │      │  └────────┬───────────┘  │
│          │           │      │           │              │
└──────────┼───────────┘      └───────────┼──────────────┘
           │                              │
           │              ┌───────────────▼───────────────┐
           │              │         MongoDB               │
           │              └───────────────────────────────┘
           │
    ┌──────▼──────────────────────────────────────────────┐
    │            AWS Cloud                                │
    │  ┌──────────┐  ┌──────────┐  ┌───────────────────┐ │
    │  │ S3       │  │CloudFront│  │ Elastic Beanstalk │ │
    │  │ (Videos) │  │ (CDN)    │  │ (Backend Hosting) │ │
    │  └──────────┘  └──────────┘  └───────────────────┘ │
    └─────────────────────────────────────────────────────┘
```

## Technology Stack

### Mobile Application
- **Framework:** Flutter (Dart) — cross-platform UI toolkit
- **State Management:** Provider — lightweight, testable state management
- **Local Storage:** SQLite (via sqflite) + flutter_secure_storage for encrypted data
- **Video Playback:** video_player + chewie with custom DRM overlay
- **HTTP Client:** Dio — interceptors, retry, caching
- **Localization:** flutter_localizations + intl — bilingual (FR/EN)
- **Push Notifications:** Firebase Cloud Messaging
- **Encrypted Storage:** AES-256 for offline video content

### Backend
- **Runtime:** Node.js 18+
- **Framework:** Express.js
- **Database:** MongoDB via Mongoose ODM
- **Authentication:** JWT with OTP-based verification
- **Payments:** Custom adapters for MTN Mobile Money & Orange Money APIs
- **Video Processing:** FFmpeg-based encryption pipeline
- **Caching:** Redis for session management and rate limiting
- **Email:** Nodemailer (SMTP)

### Cloud Infrastructure (AWS)
- **Compute:** Elastic Beanstalk (backend API)
- **Storage:** S3 (encrypted video assets)
- **CDN:** CloudFront (video streaming with signed URLs)
- **Database:** MongoDB Atlas
- **Notifications:** Firebase Cloud Messaging

## Security Architecture

### Video Protection
1. **Encryption at rest:** All video files are encrypted with AES-256 before S3 upload.
2. **Signed URLs:** CloudFront URLs are time-limited and signed.
3. **Screenshot prevention:** Custom native overlay using FLAG_SECURE on Android and UIScreen.isCaptured on iOS.
4. **Offline decryption:** Keys are stored in platform-specific secure enclaves (Keychain/Keystore).

### Authentication Flow
1. User submits phone/email → OTP sent via SMS/email.
2. User enters OTP → server validates and issues JWT (access + refresh tokens).
3. Access token (15 min) used for API calls; refresh token (7 days) for renewal.
4. Tokens stored in flutter_secure_storage (encrypted at OS level).

### Data Encryption
- All API traffic over HTTPS/TLS 1.3.
- Sensitive data encrypted with AES-256-GCM in MongoDB.
- Payment tokens handled server-side; no raw card/Mobile Money data on device.

## Data Flow Diagram

### Course Purchase & Playback

```
User → App → POST /api/payments/initiate → Payment Gateway
                                                │
User ← App ← Webhook /api/payments/confirm ◄───┘
                                                │
User → App → GET /api/courses/:id/stream       │
         → Backend validates purchase            │
         → Generates signed CloudFront URL       │
         → Returns encrypted stream URL ─────────┘
                                               
User ← App ← Plays video with DRM overlay
         → Decrypts chunks in secure memory
         → Renders on screen (screenshot protected)
```

## Scalability Considerations

- **Horizontal scaling:** Backend API is stateless (sessions in Redis) — scale via load balancer.
- **CDN offloading:** CloudFront serves all video content, reducing API server load.
- **Database indexing:** Compound indexes on frequently queried fields (userId, courseId, status).
- **Caching layer:** Redis caches course metadata, user sessions, and rate limit counters.
- **Async processing:** Video transcoding and encryption run as background jobs.
