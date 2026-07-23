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
    // Home — header & search
    required this.homeGreeting,
    required this.homeSubtitle,
    required this.homeSearchHint,
    required this.homeSearchClear,
    // Home — sections
    required this.homeWelcomeVideoSection,
    required this.homeCoursesSection,
    required this.homeContinueLearning,
    // Badges & course meta
    required this.badgeFree,
    required this.badgePremium,
    required this.badgeLocked,
    required this.courseLessonsCount,
    required this.courseProgressComplete,
    required this.courseRatingReviews,
    // Filters
    required this.filterAll,
    required this.filterFree,
    required this.filterPremium,
    required this.filterInProgress,
    // Bottom navigation
    required this.navHome,
    required this.navMyCourses,
    required this.navTools,
    required this.navProfile,
    // Empty / error / misc states
    required this.homeEmptyTitle,
    required this.homeEmptySubtitle,
    required this.homeErrorTitle,
    required this.homeRetry,
    required this.homeComingSoon,
    required this.homeComingSoonSubtitle,
    // Common
    required this.commonCancel,
    // Course detail
    required this.cdAboutTitle,
    required this.cdContentTitle,
    required this.cdAllLevels,
    required this.cdLevelLabel,
    required this.cdBuyNow,
    required this.cdStartLearning,
    required this.cdEnrolledBadge,
    // Locked content dialog
    required this.lockedTitle,
    required this.lockedMessage,
    required this.lockedUnlockNow,
    // Checkout
    required this.checkoutTitle,
    required this.checkoutOrderSummary,
    required this.checkoutPaymentMethodTitle,
    required this.checkoutMtnName,
    required this.checkoutMtnSubtitle,
    required this.checkoutOrangeName,
    required this.checkoutOrangeSubtitle,
    required this.checkoutPhoneLabel,
    required this.checkoutConfirm,
    required this.checkoutTotalLabel,
    required this.checkoutSslSecure,
    required this.checkoutProcessing,
    // Payment result
    required this.paySuccessTitle,
    required this.paySuccessSubtitle,
    required this.payStartLearning,
    required this.payViewMyCourses,
    required this.payFailedTitle,
    required this.payFailedSubtitle,
    required this.payRetry,
    // Receipt
    required this.receiptTitle,
    required this.receiptTransactionId,
    required this.receiptDateTime,
    required this.receiptCourse,
    required this.receiptAmount,
    required this.receiptMethod,
    required this.receiptStatus,
    // Transaction status
    required this.statusPending,
    required this.statusCompleted,
    required this.statusFailed,
    // Payment errors
    required this.payErrorNetwork,
    required this.payErrorDeclined,
    required this.payErrorTimeout,
    required this.payErrorUnknown,
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

  // Home — header & search
  final String homeGreeting;
  final String homeSubtitle;
  final String homeSearchHint;
  final String homeSearchClear;

  // Home — sections
  final String homeWelcomeVideoSection;
  final String homeCoursesSection;
  final String homeContinueLearning;

  // Badges & course meta
  final String badgeFree;
  final String badgePremium;
  final String badgeLocked;

  /// Lessons-count template containing an `{n}` placeholder, e.g. `12 lessons`.
  /// Modèle du nombre de leçons contenant un espace réservé `{n}`.
  final String courseLessonsCount;

  /// Progress template containing a `{p}` placeholder, e.g. `40% complete`.
  /// Modèle de progression contenant un espace réservé `{p}`.
  final String courseProgressComplete;

  /// Reviews-count template containing an `{n}` placeholder.
  /// Modèle du nombre d'avis contenant un espace réservé `{n}`.
  final String courseRatingReviews;

  // Filters
  final String filterAll;
  final String filterFree;
  final String filterPremium;
  final String filterInProgress;

  // Bottom navigation
  final String navHome;
  final String navMyCourses;
  final String navTools;
  final String navProfile;

  // Empty / error / misc states
  final String homeEmptyTitle;
  final String homeEmptySubtitle;
  final String homeErrorTitle;
  final String homeRetry;
  final String homeComingSoon;
  final String homeComingSoonSubtitle;

  // Common
  final String commonCancel;

  // Course detail
  final String cdAboutTitle;
  final String cdContentTitle;
  final String cdAllLevels;
  final String cdLevelLabel;

  /// "Buy now" CTA containing a `{price}` placeholder. / CTA d'achat avec `{price}`.
  final String cdBuyNow;
  final String cdStartLearning;
  final String cdEnrolledBadge;

  // Locked content dialog
  final String lockedTitle;
  final String lockedMessage;
  final String lockedUnlockNow;

  // Checkout
  final String checkoutTitle;
  final String checkoutOrderSummary;
  final String checkoutPaymentMethodTitle;
  final String checkoutMtnName;
  final String checkoutMtnSubtitle;
  final String checkoutOrangeName;
  final String checkoutOrangeSubtitle;
  final String checkoutPhoneLabel;
  final String checkoutConfirm;
  final String checkoutTotalLabel;
  final String checkoutSslSecure;
  final String checkoutProcessing;

  // Payment result
  final String paySuccessTitle;
  final String paySuccessSubtitle;
  final String payStartLearning;
  final String payViewMyCourses;
  final String payFailedTitle;
  final String payFailedSubtitle;
  final String payRetry;

  // Receipt
  final String receiptTitle;
  final String receiptTransactionId;
  final String receiptDateTime;
  final String receiptCourse;
  final String receiptAmount;
  final String receiptMethod;
  final String receiptStatus;

  // Transaction status
  final String statusPending;
  final String statusCompleted;
  final String statusFailed;

  // Payment errors
  final String payErrorNetwork;
  final String payErrorDeclined;
  final String payErrorTimeout;
  final String payErrorUnknown;

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
    // Home — header & search
    homeGreeting: 'Hello',
    homeSubtitle: 'Ready to grow your business today?',
    homeSearchHint: 'Search courses…',
    homeSearchClear: 'Clear search',
    // Home — sections
    homeWelcomeVideoSection: 'Start here',
    homeCoursesSection: 'Courses',
    homeContinueLearning: 'Continue learning',
    // Badges & course meta
    badgeFree: 'FREE',
    badgePremium: 'PREMIUM',
    badgeLocked: 'Locked',
    courseLessonsCount: '{n} lessons',
    courseProgressComplete: '{p}% complete',
    courseRatingReviews: '({n} reviews)',
    // Filters
    filterAll: 'All',
    filterFree: 'Free',
    filterPremium: 'Premium',
    filterInProgress: 'In progress',
    // Bottom navigation
    navHome: 'Home',
    navMyCourses: 'My Courses',
    navTools: 'Tools',
    navProfile: 'Profile',
    // Empty / error / misc states
    homeEmptyTitle: 'No courses found',
    homeEmptySubtitle: 'Try a different search term or filter.',
    homeErrorTitle: 'We could not load your courses.',
    homeRetry: 'Try again',
    homeComingSoon: 'Coming soon',
    homeComingSoonSubtitle: 'This section is being built and will unlock shortly.',
    // Common
    commonCancel: 'Cancel',
    // Course detail
    cdAboutTitle: 'About this course',
    cdContentTitle: 'Course content',
    cdAllLevels: 'All levels',
    cdLevelLabel: 'Level',
    cdBuyNow: 'Buy now — {price}',
    cdStartLearning: 'Start learning',
    cdEnrolledBadge: 'Enrolled',
    // Locked content dialog
    lockedTitle: '🔒 Purchase to unlock',
    lockedMessage:
        'Buy this course to unlock this lesson and every module inside it.',
    lockedUnlockNow: 'Unlock now',
    // Checkout
    checkoutTitle: 'Checkout',
    checkoutOrderSummary: 'Order summary',
    checkoutPaymentMethodTitle: 'Payment method',
    checkoutMtnName: 'MTN Mobile Money',
    checkoutMtnSubtitle: 'Pay with your MTN MoMo account',
    checkoutOrangeName: 'Orange Money',
    checkoutOrangeSubtitle: 'Pay with your Orange Money account',
    checkoutPhoneLabel: 'Payment phone number',
    checkoutConfirm: 'Confirm payment',
    checkoutTotalLabel: 'Total',
    checkoutSslSecure: 'SSL secure connection',
    checkoutProcessing: 'Processing your payment…',
    // Payment result
    paySuccessTitle: 'Payment successful!',
    paySuccessSubtitle: 'Your course is now unlocked. Enjoy your learning.',
    payStartLearning: 'Start learning',
    payViewMyCourses: 'View my courses',
    payFailedTitle: 'Payment failed',
    payFailedSubtitle: 'Your payment could not be completed. No money was taken.',
    payRetry: 'Try again',
    // Receipt
    receiptTitle: 'Receipt',
    receiptTransactionId: 'Transaction ID',
    receiptDateTime: 'Date & time',
    receiptCourse: 'Course',
    receiptAmount: 'Amount',
    receiptMethod: 'Method',
    receiptStatus: 'Status',
    // Transaction status
    statusPending: 'Pending',
    statusCompleted: 'Completed',
    statusFailed: 'Failed',
    // Payment errors
    payErrorNetwork: 'No connection. Check your network and try again.',
    payErrorDeclined: 'The payment was declined. Please try another number.',
    payErrorTimeout: 'The payment timed out. Please try again.',
    payErrorUnknown: 'The payment could not be completed. Please try again.',
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
    // Home — header & search
    homeGreeting: 'Bonjour',
    homeSubtitle: 'Prêt à développer votre activité aujourd\'hui ?',
    homeSearchHint: 'Rechercher des cours…',
    homeSearchClear: 'Effacer la recherche',
    // Home — sections
    homeWelcomeVideoSection: 'Commencez ici',
    homeCoursesSection: 'Cours',
    homeContinueLearning: 'Continuer l\'apprentissage',
    // Badges & course meta
    badgeFree: 'GRATUIT',
    badgePremium: 'PREMIUM',
    badgeLocked: 'Verrouillé',
    courseLessonsCount: '{n} leçons',
    courseProgressComplete: '{p}% terminé',
    courseRatingReviews: '({n} avis)',
    // Filters
    filterAll: 'Tous',
    filterFree: 'Gratuits',
    filterPremium: 'Premium',
    filterInProgress: 'En cours',
    // Bottom navigation
    navHome: 'Accueil',
    navMyCourses: 'Mes cours',
    navTools: 'Outils',
    navProfile: 'Profil',
    // Empty / error / misc states
    homeEmptyTitle: 'Aucun cours trouvé',
    homeEmptySubtitle: 'Essayez un autre terme de recherche ou un autre filtre.',
    homeErrorTitle: 'Impossible de charger vos cours.',
    homeRetry: 'Réessayer',
    homeComingSoon: 'Bientôt disponible',
    homeComingSoonSubtitle: 'Cette section est en cours de construction.',
    // Common
    commonCancel: 'Annuler',
    // Course detail
    cdAboutTitle: 'À propos de ce cours',
    cdContentTitle: 'Contenu du cours',
    cdAllLevels: 'Tous niveaux',
    cdLevelLabel: 'Niveau',
    cdBuyNow: 'Acheter — {price}',
    cdStartLearning: 'Commencer',
    cdEnrolledBadge: 'Inscrit',
    // Locked content dialog
    lockedTitle: '🔒 Achetez pour débloquer',
    lockedMessage:
        'Achetez ce cours pour débloquer cette leçon et tous ses modules.',
    lockedUnlockNow: 'Débloquer maintenant',
    // Checkout
    checkoutTitle: 'Paiement',
    checkoutOrderSummary: 'Récapitulatif',
    checkoutPaymentMethodTitle: 'Moyen de paiement',
    checkoutMtnName: 'MTN Mobile Money',
    checkoutMtnSubtitle: 'Payez avec votre compte MTN MoMo',
    checkoutOrangeName: 'Orange Money',
    checkoutOrangeSubtitle: 'Payez avec votre compte Orange Money',
    checkoutPhoneLabel: 'Numéro de téléphone de paiement',
    checkoutConfirm: 'Confirmer le paiement',
    checkoutTotalLabel: 'Total',
    checkoutSslSecure: 'Connexion sécurisée SSL',
    checkoutProcessing: 'Traitement de votre paiement…',
    // Payment result
    paySuccessTitle: 'Paiement réussi !',
    paySuccessSubtitle: 'Votre cours est débloqué. Bon apprentissage.',
    payStartLearning: 'Commencer',
    payViewMyCourses: 'Voir mes cours',
    payFailedTitle: 'Échec du paiement',
    payFailedSubtitle: "Votre paiement n'a pas pu aboutir. Aucun montant n'a été prélevé.",
    payRetry: 'Réessayer',
    // Receipt
    receiptTitle: 'Reçu',
    receiptTransactionId: 'ID de transaction',
    receiptDateTime: 'Date et heure',
    receiptCourse: 'Cours',
    receiptAmount: 'Montant',
    receiptMethod: 'Moyen',
    receiptStatus: 'Statut',
    // Transaction status
    statusPending: 'En attente',
    statusCompleted: 'Terminé',
    statusFailed: 'Échoué',
    // Payment errors
    payErrorNetwork: 'Pas de connexion. Vérifiez votre réseau et réessayez.',
    payErrorDeclined: 'Le paiement a été refusé. Essayez un autre numéro.',
    payErrorTimeout: 'Le délai de paiement a expiré. Veuillez réessayer.',
    payErrorUnknown: "Le paiement n'a pas pu aboutir. Veuillez réessayer.",
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
