/// Global, non-localized constants for the OSEC mobile app.
class AppConstants {
  AppConstants._();

  // App Identity
  static const String appName = 'OSEC';
  static const String appFullName = 'OSEC - Online School of E-Commerce';
  static const String appVersion = '1.0.0';

  // Networking
  static const String apiBaseUrl = 'http://localhost:3000/api/v1';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String keyAuthToken = 'osec_auth_token';
  static const String keyRefreshToken = 'osec_refresh_token';
  static const String keyOnboardingComplete = 'osec_onboarding_complete';
  static const String keyUserLocale = 'osec_user_locale';

  // Onboarding
  static const int onboardingSlideCount = 3;

  // Localization
  static const String defaultLocaleCode = 'fr';
  static const List<String> supportedLocaleCodes = ['fr', 'en'];

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
