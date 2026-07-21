/// Centralized, bilingual (French/English) copy for the OSEC mobile app.
///
/// Copie bilingue (français/anglais) centralisée pour l'application OSEC.
///
/// This is a lightweight lookup table used ahead of a full ARB-based
/// `flutter gen-l10n` setup (see `lib/core/localization/`). Access a string
/// with `AppStrings.of(locale).onboardingSkip`.
class AppStrings {
  const AppStrings._({
    // Onboarding
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
    // Auth — shell / tabs
    required this.authWelcomeTitle,
    required this.authWelcomeSubtitle,
    required this.authSignInTab,
    required this.authSignUpTab,
    // Auth — fields
    required this.authFullNameLabel,
    required this.authFullNameHint,
    required this.authPhoneLabel,
    required this.authPhoneHint,
    required this.authEmailLabel,
    required this.authEmailHint,
    required this.authPasswordLabel,
    required this.authPasswordHint,
    required this.authForgotPassword,
    required this.authSignInButton,
    required this.authCreateAccountButton,
    required this.authTermsNotice,
    required this.authCountryPickerTitle,
    // OTP
    required this.otpTitle,
    required this.otpSentTo,
    required this.otpResendButton,
    required this.otpResendIn,
    required this.otpVerifyButton,
    required this.otpChangeNumber,
    required this.otpDidntReceive,
    // Forgot password
    required this.forgotTitle,
    required this.forgotSubtitle,
    required this.forgotSendButton,
    required this.forgotSentMessage,
    required this.forgotCancel,
    // Validation
    required this.validationRequired,
    required this.validationFullNameRequired,
    required this.validationPhoneRequired,
    required this.validationPhoneInvalid,
    required this.validationEmailInvalid,
    required this.validationPasswordRequired,
    required this.validationPasswordTooShort,
    required this.validationPasswordWeak,
    // Errors (mapped from AuthErrorType)
    required this.errorNetwork,
    required this.errorInvalidCredentials,
    required this.errorUserExists,
    required this.errorInvalidOtp,
    required this.errorOtpExpired,
    required this.errorWeakPassword,
    required this.errorServer,
    required this.errorUnknown,
    // Success
    required this.successSignedIn,
    required this.successAccountVerified,
  });

  // Onboarding
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

  // Auth — shell / tabs
  final String authWelcomeTitle;
  final String authWelcomeSubtitle;
  final String authSignInTab;
  final String authSignUpTab;

  // Auth — fields
  final String authFullNameLabel;
  final String authFullNameHint;
  final String authPhoneLabel;
  final String authPhoneHint;
  final String authEmailLabel;
  final String authEmailHint;
  final String authPasswordLabel;
  final String authPasswordHint;
  final String authForgotPassword;
  final String authSignInButton;
  final String authCreateAccountButton;
  final String authTermsNotice;
  final String authCountryPickerTitle;

  // OTP
  final String otpTitle;
  final String otpSentTo;
  final String otpResendButton;

  /// Resend countdown template. Contains a `{s}` placeholder replaced with the
  /// remaining seconds by the UI, e.g. `Resend code in 42s`.
  ///
  /// Modèle du compte à rebours de renvoi. Contient un espace réservé `{s}`
  /// remplacé par les secondes restantes.
  final String otpResendIn;
  final String otpVerifyButton;
  final String otpChangeNumber;
  final String otpDidntReceive;

  // Forgot password
  final String forgotTitle;
  final String forgotSubtitle;
  final String forgotSendButton;
  final String forgotSentMessage;
  final String forgotCancel;

  // Validation
  final String validationRequired;
  final String validationFullNameRequired;
  final String validationPhoneRequired;
  final String validationPhoneInvalid;
  final String validationEmailInvalid;
  final String validationPasswordRequired;
  final String validationPasswordTooShort;
  final String validationPasswordWeak;

  // Errors
  final String errorNetwork;
  final String errorInvalidCredentials;
  final String errorUserExists;
  final String errorInvalidOtp;
  final String errorOtpExpired;
  final String errorWeakPassword;
  final String errorServer;
  final String errorUnknown;

  // Success
  final String successSignedIn;
  final String successAccountVerified;

  static const AppStrings en = AppStrings._(
    // Onboarding
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
    // Auth — shell / tabs
    authWelcomeTitle: 'Welcome to OSEC',
    authWelcomeSubtitle: 'Sign in to continue your journey, or create an account to start.',
    authSignInTab: 'Sign In',
    authSignUpTab: 'Sign Up',
    // Auth — fields
    authFullNameLabel: 'Full name',
    authFullNameHint: 'e.g. Amina Nkeng',
    authPhoneLabel: 'Phone number',
    authPhoneHint: '6 12 34 56 78',
    authEmailLabel: 'Email (optional)',
    authEmailHint: 'you@example.com',
    authPasswordLabel: 'Password',
    authPasswordHint: 'At least 8 characters',
    authForgotPassword: 'Forgot password?',
    authSignInButton: 'Sign In',
    authCreateAccountButton: 'Create Account',
    authTermsNotice:
        'By creating an account you agree to the OSEC Terms of Service and Privacy Policy.',
    authCountryPickerTitle: 'Select a country',
    // OTP
    otpTitle: 'Verify your number',
    otpSentTo: 'We sent a 6-digit code to',
    otpResendButton: 'Resend code',
    otpResendIn: 'Resend code in {s}s',
    otpVerifyButton: 'Verify',
    otpChangeNumber: 'Change number',
    otpDidntReceive: "Didn't receive the code?",
    // Forgot password
    forgotTitle: 'Reset password',
    forgotSubtitle:
        'Enter your phone number and we will send you a code to reset your password.',
    forgotSendButton: 'Send reset code',
    forgotSentMessage: 'If an account exists, a reset code has been sent.',
    forgotCancel: 'Cancel',
    // Validation
    validationRequired: 'This field is required.',
    validationFullNameRequired: 'Please enter your full name.',
    validationPhoneRequired: 'Please enter your phone number.',
    validationPhoneInvalid: 'Please enter a valid phone number.',
    validationEmailInvalid: 'Please enter a valid email address.',
    validationPasswordRequired: 'Please enter a password.',
    validationPasswordTooShort: 'Password must be at least 8 characters.',
    validationPasswordWeak:
        'Include a letter, a number, and a special character.',
    // Errors
    errorNetwork: 'No connection. Check your network and try again.',
    errorInvalidCredentials: 'Incorrect phone number or password.',
    errorUserExists: 'An account with this number already exists.',
    errorInvalidOtp: 'Invalid code. Please check and try again.',
    errorOtpExpired: 'This code has expired. Request a new one.',
    errorWeakPassword: 'Your password is too weak. Choose a stronger one.',
    errorServer: 'Something went wrong on our side. Please try again.',
    errorUnknown: 'An unexpected error occurred. Please try again.',
    // Success
    successSignedIn: 'Signed in successfully.',
    successAccountVerified: 'Your account has been verified.',
  );

  static const AppStrings fr = AppStrings._(
    // Onboarding
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
    // Auth — shell / tabs
    authWelcomeTitle: 'Bienvenue sur OSEC',
    authWelcomeSubtitle:
        'Connectez-vous pour continuer, ou créez un compte pour commencer.',
    authSignInTab: 'Connexion',
    authSignUpTab: 'Inscription',
    // Auth — fields
    authFullNameLabel: 'Nom complet',
    authFullNameHint: 'ex. Amina Nkeng',
    authPhoneLabel: 'Numéro de téléphone',
    authPhoneHint: '6 12 34 56 78',
    authEmailLabel: 'E-mail (facultatif)',
    authEmailHint: 'vous@exemple.com',
    authPasswordLabel: 'Mot de passe',
    authPasswordHint: 'Au moins 8 caractères',
    authForgotPassword: 'Mot de passe oublié ?',
    authSignInButton: 'Se connecter',
    authCreateAccountButton: 'Créer un compte',
    authTermsNotice:
        "En créant un compte, vous acceptez les Conditions d'utilisation et la Politique de confidentialité d'OSEC.",
    authCountryPickerTitle: 'Choisir un pays',
    // OTP
    otpTitle: 'Vérifiez votre numéro',
    otpSentTo: 'Nous avons envoyé un code à 6 chiffres au',
    otpResendButton: 'Renvoyer le code',
    otpResendIn: 'Renvoyer le code dans {s}s',
    otpVerifyButton: 'Vérifier',
    otpChangeNumber: 'Changer de numéro',
    otpDidntReceive: "Vous n'avez pas reçu le code ?",
    // Forgot password
    forgotTitle: 'Réinitialiser le mot de passe',
    forgotSubtitle:
        'Entrez votre numéro de téléphone et nous vous enverrons un code de réinitialisation.',
    forgotSendButton: 'Envoyer le code',
    forgotSentMessage: 'Si un compte existe, un code de réinitialisation a été envoyé.',
    forgotCancel: 'Annuler',
    // Validation
    validationRequired: 'Ce champ est obligatoire.',
    validationFullNameRequired: 'Veuillez saisir votre nom complet.',
    validationPhoneRequired: 'Veuillez saisir votre numéro de téléphone.',
    validationPhoneInvalid: 'Veuillez saisir un numéro de téléphone valide.',
    validationEmailInvalid: 'Veuillez saisir une adresse e-mail valide.',
    validationPasswordRequired: 'Veuillez saisir un mot de passe.',
    validationPasswordTooShort:
        'Le mot de passe doit comporter au moins 8 caractères.',
    validationPasswordWeak:
        'Incluez une lettre, un chiffre et un caractère spécial.',
    // Errors
    errorNetwork: 'Pas de connexion. Vérifiez votre réseau et réessayez.',
    errorInvalidCredentials: 'Numéro de téléphone ou mot de passe incorrect.',
    errorUserExists: 'Un compte avec ce numéro existe déjà.',
    errorInvalidOtp: 'Code invalide. Veuillez vérifier et réessayer.',
    errorOtpExpired: 'Ce code a expiré. Demandez-en un nouveau.',
    errorWeakPassword: 'Votre mot de passe est trop faible. Choisissez-en un plus fort.',
    errorServer: 'Une erreur est survenue de notre côté. Veuillez réessayer.',
    errorUnknown: "Une erreur inattendue s'est produite. Veuillez réessayer.",
    // Success
    successSignedIn: 'Connexion réussie.',
    successAccountVerified: 'Votre compte a été vérifié.',
  );

  /// Returns the [AppStrings] set matching [languageCode], defaulting to
  /// French per [AppConstants.defaultLocaleCode].
  ///
  /// Retourne le jeu [AppStrings] correspondant à [languageCode], français
  /// par défaut conformément à [AppConstants.defaultLocaleCode].
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
