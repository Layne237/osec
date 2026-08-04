# OSEC - Online School of E-Commerce

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Status](https://img.shields.io/badge/status-MVP-green)
![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue)
![License](https://img.shields.io/badge/license-MIT-green)

> **Empowering the next generation of e-commerce entrepreneurs across French-speaking Africa.**

## Vision

OSEC (Online School of E-Commerce) is a mobile-first platform that provides secure, high-quality video training courses for aspiring e-commerce professionals. Our mission is to bridge the digital skills gap in Francophone Africa by delivering accessible, professional-grade e-commerce education directly to mobile devices.

## Features

- **User Authentication** — Phone/email registration with OTP verification
- **Secure Video Streaming** — Screenshot-protected streaming with encrypted offline playback
- **Payment Integration** — Mobile Money (MTN) & Orange Money support
- **Trainer Dashboard** — Analytics, course management, and student engagement metrics
- **Reviews & Testimonials** — Course rating and feedback system
- **Business Tools Hub** — Calculators, templates, and planning resources
- **Bilingual Interface** — Full French and English support
- **Push Notifications** — Course updates, promotions, and reminders

## Repository Structure

```
osec/
├── .github/              # GitHub templates (issues, PRs)
├── docs/                 # Architecture, design, and contribution docs
│   ├── architecture/     # System architecture & API design
│   ├── brand_guidelines/ # Design system & branding
│   └── contributions/    # Coding standards & git workflow
├── mobile-app/           # Flutter mobile application
│   ├── lib/              # Dart source code
│   │   ├── core/         # Constants, themes, utils, localization
│   │   ├── data/         # Models, repositories, providers
│   │   ├── domain/       # Entities, use cases
│   │   └── presentation/ # UI screens & widgets
│   ├── assets/           # Fonts, images, videos
│   └── test/             # Unit & widget tests
├── backend/              # Node.js/Express API server
│   ├── src/              # Source code
│   │   ├── api/          # Routes & controllers
│   │   ├── config/       # Configuration files
│   │   ├── models/       # Database models
│   │   ├── services/     # Business logic
│   │   └── utils/        # Helper utilities
│   └── tests/            # Integration & unit tests
├── infrastructure/       # Docker, AWS, nginx configs
└── scripts/              # Setup & deployment scripts
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.0.0
- [Node.js](https://nodejs.org/) >= 18.x
- [Docker](https://docs.docker.com/get-docker/) (optional, for containerized deployment)
- [MongoDB](https://www.mongodb.com/) (local or Atlas instance)

### Quick Start

```bash
# Clone the repository
git clone https://github.com/Layne237/osec.git
cd osec

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Set up the backend
cd backend
npm install
npm run dev

# Set up the mobile app (in a new terminal)
cd mobile-app
flutter pub get
flutter run
```

Detailed setup instructions for each component can be found in their respective README files:
- [Mobile App Setup](mobile-app/README.md)
- [Backend Setup](backend/README.md)

## Brand & Design Summary

| Element | Value |
|---------|-------|
| Primary Color | Obsidian `#11131B` |
| Accent Blue | Royal Blue `#2563EB` |
| Success | Emerald Green `#10B981` |
| Highlight | Gold `#FBBF24` |
| Typography | Montserrat (headings), Inter (body) |
| Design Principle | Glassomorphism with depth and layering |

See the full [Design System](docs/brand_guidelines/design_system.md) for details.

## Acceptance Criteria (ToR)

- [x] User authentication with phone/email and OTP
- [x] Secure video streaming with screenshot protection
- [x] Offline video playback in encrypted sandboxed storage
- [x] Mobile Money (MTN) & Orange Money payment processing
- [x] Trainer dashboard with analytics
- [x] Reviews and testimonials system
- [x] Business tools hub
- [x] Bilingual interface (French/English)
- [x] Push notification system

## Team

| Role | Name |
|------|------|
| Product Manager | [Your Name] |
| Flutter Developer | [Your Name] |
| Backend Developer | [Your Name] |
| UI/UX Designer | [Your Name] |

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, branch naming conventions, commit message format, and pull request process.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
