# OSEC Mobile App

The Flutter-based mobile client for the OSEC platform. Supports Android and iOS with a single codebase.

## Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.0.0
- [Dart SDK](https://dart.dev/get-dart) >= 3.0.0
- Android Studio / Xcode (for platform-specific builds)
- A physical device or emulator

## Setup

```bash
# Navigate to mobile-app directory
cd mobile-app

# Install dependencies
flutter pub get

# Generate localization files (if needed)
flutter gen-l10n

# Run the app
flutter run
```

## Environment Configuration

Create a `.env` file in the project root (see `.env.example` at the repo root):

```
API_BASE_URL=http://localhost:3000/api/v1
```

For Android, ensure `android/app/src/main/AndroidManifest.xml` has internet permission (it does by default).

## Build Instructions

### Debug Build

```bash
flutter run
```

### Release APK (Android)

```bash
flutter build apk --release
```

### App Bundle (Android)

```bash
flutter build appbundle --release
```

### iOS Archive

```bash
flutter build ios --release
```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Watch mode
flutter test --watch
```

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management with ChangeNotifier pattern |
| `dio` | HTTP client with interceptors, retry, and caching |
| `sqflite` | Local SQLite database for offline data |
| `flutter_secure_storage` | Encrypted storage for tokens and keys |
| `video_player` + `chewie` | Video playback with custom controls |
| `flutter_localizations` + `intl` | Bilingual (FR/EN) localization |
| `cached_network_image` | Image caching and placeholder support |
| `shimmer` | Loading skeleton effects |
| `connectivity_plus` | Network status monitoring |

## Project Structure

```
lib/
├── core/               # Constants, themes, utils, localization
│   ├── constants/      # API endpoints, app constants
│   ├── themes/         # AppTheme (light/dark with glassomorphism)
│   ├── utils/          # Validators, formatters, helpers
│   └── localization/   # ARB files for FR/EN
├── data/               # Data layer
│   ├── models/         # Data transfer objects (DTOs)
│   ├── repositories/   # Data source abstractions
│   └── providers/      # ChangeNotifier providers
├── domain/             # Business logic
│   ├── entities/       # Core business objects
│   └── usecases/       # Application-specific business rules
└── presentation/       # UI layer
    ├── onboarding/     # Welcome screens & phone verification
    ├── home/           # Course browsing & search
    ├── course_detail/  # Course page with chapters
    ├── secure_player/  # DRM-protected video player
    ├── checkout/       # Payment flow
    ├── reviews/        # Ratings & testimonials
    ├── tools_hub/      # Business calculators & templates
    ├── trainer_dashboard/ # Instructor analytics
    └── shared/         # Reusable widgets & navigation
```

## Architecture

This app follows **Clean Architecture** with three layers:
1. **Presentation** — UI widgets + Providers (state)
2. **Domain** — Entities + Use Cases (pure Dart, no Flutter dependency)
3. **Data** — Models + Repositories (API calls, local DB)

Data flows unidirectionally: UI → Provider → UseCase → Repository → API/DB
