/// Centralized, bilingual (French/English) copy for the OSEC mobile app.
///
/// This is a lightweight lookup table used ahead of a full ARB-based
/// `flutter gen-l10n` setup (see `lib/core/localization/`). Access a string
/// with `AppStrings.of(locale).onboardingSkip`.
class AppStrings {
  const AppStrings._({
    required this.onboardingSkip,
    required this.onboardingNext,
    required this.onboardingGetStarted,
    required this.onboardingSlide1Title,
    required this.onboardingSlide1Subtitle,
    required this.onboardingSlide2Title,
    required this.onboardingSlide2Subtitle,
    required this.onboardingSlide3Title,
    required this.onboardingSlide3Subtitle,
    required this.secureAndVerified,
    required this.authScreenComingSoon,
  });

  final String onboardingSkip;
  final String onboardingNext;
  final String onboardingGetStarted;
  final String onboardingSlide1Title;
  final String onboardingSlide1Subtitle;
  final String onboardingSlide2Title;
  final String onboardingSlide2Subtitle;
  final String onboardingSlide3Title;
  final String onboardingSlide3Subtitle;
  final String secureAndVerified;
  final String authScreenComingSoon;

  static const AppStrings en = AppStrings._(
    onboardingSkip: 'Skip',
    onboardingNext: 'Next',
    onboardingGetStarted: 'Get Started',
    onboardingSlide1Title: 'Learn.',
    onboardingSlide1Subtitle:
        'Learn e-commerce from professionals. Master the strategies that build global brands.',
    onboardingSlide2Title: 'Build.',
    onboardingSlide2Subtitle:
        'Turn lessons into action with practical tools, templates, and hands-on business calculators.',
    onboardingSlide3Title: 'Earn.',
    onboardingSlide3Subtitle:
        'Launch, grow, and monetize your own e-commerce business with confidence.',
    secureAndVerified: 'Secure & Verified',
    authScreenComingSoon: 'Authentication is coming soon.',
  );

  static const AppStrings fr = AppStrings._(
    onboardingSkip: 'Passer',
    onboardingNext: 'Suivant',
    onboardingGetStarted: 'Commencer',
    onboardingSlide1Title: 'Apprenez.',
    onboardingSlide1Subtitle:
        "Apprenez l'e-commerce auprès de professionnels. Maîtrisez les stratégies qui bâtissent des marques mondiales.",
    onboardingSlide2Title: 'Construisez.',
    onboardingSlide2Subtitle:
        'Transformez les leçons en actions grâce à des outils pratiques, modèles et calculateurs métier.',
    onboardingSlide3Title: 'Gagnez.',
    onboardingSlide3Subtitle:
        'Lancez, développez et monétisez votre propre activité e-commerce en toute confiance.',
    secureAndVerified: 'Sécurisé & Vérifié',
    authScreenComingSoon: "L'authentification arrive bientôt.",
  );

  /// Returns the [AppStrings] set matching [languageCode], defaulting to
  /// French per [AppConstants.defaultLocaleCode].
  static AppStrings of(String languageCode) {
    switch (languageCode) {
      case 'en':
        return en;
      case 'fr':
      default:
        return fr;
    }
  }
}
