import '../constants/app_strings.dart';

/// Reusable form-field validators for the OSEC mobile app.
///
/// Validateurs de champs de formulaire réutilisables pour l'app OSEC.
///
/// Each validator returns `null` when the value is valid, or a localized error
/// message otherwise — the exact signature expected by [FormField.validator].
/// Localized copy is injected through an [AppStrings] instance so the same
/// validator works in both French and English.
///
/// Chaque validateur retourne `null` si la valeur est valide, sinon un message
/// d'erreur localisé — la signature attendue par [FormField.validator].
class Validators {
  Validators._();

  /// Matches the vast majority of real-world email addresses without being
  /// overly strict (full RFC 5322 compliance is intentionally out of scope).
  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$",
  );

  static final RegExp _digitsRegExp = RegExp(r'\d');
  static final RegExp _letterRegExp = RegExp(r'[A-Za-z]');
  static final RegExp _specialCharRegExp = RegExp(r'''[!@#$%^&*(),.?":{}|<>_\-\[\]/\\;'`~+=]''');

  /// Minimum password length enforced across the app. / Longueur minimale.
  static const int passwordMinLength = 8;

  /// Validates a required, free-text field (e.g. full name).
  ///
  /// [minLength] optionally enforces a minimum trimmed length.
  static String? required(
    String? value,
    AppStrings strings, {
    int minLength = 1,
    String? message,
  }) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length < minLength) {
      return message ?? strings.validationRequired;
    }
    return null;
  }

  /// Validates a person's full name: required and at least two characters.
  static String? fullName(String? value, AppStrings strings) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.length < 2) {
      return strings.validationFullNameRequired;
    }
    return null;
  }

  /// Validates the national portion of a phone number (digits only, no country
  /// code). Accepts [minDigits]–[maxDigits] digits after stripping formatting
  /// characters such as spaces, dashes, dots and parentheses.
  ///
  /// Valide la partie nationale d'un numéro (chiffres uniquement, sans indicatif).
  static String? phone(
    String? value,
    AppStrings strings, {
    int minDigits = 6,
    int maxDigits = 15,
  }) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) {
      return strings.validationPhoneRequired;
    }
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length < minDigits || digits.length > maxDigits) {
      return strings.validationPhoneInvalid;
    }
    return null;
  }

  /// Validates an *optional* email field: `null`/empty passes, otherwise the
  /// value must be a well-formed address.
  ///
  /// Valide un champ e-mail *facultatif* : vide accepté, sinon format requis.
  static String? optionalEmail(String? value, AppStrings strings) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_emailRegExp.hasMatch(trimmed)) {
      return strings.validationEmailInvalid;
    }
    return null;
  }

  /// Validates a required email field.
  static String? email(String? value, AppStrings strings) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return strings.validationRequired;
    }
    if (!_emailRegExp.hasMatch(trimmed)) {
      return strings.validationEmailInvalid;
    }
    return null;
  }

  /// Validates a password: required, at least [passwordMinLength] characters,
  /// and containing a letter, a digit and a special character.
  ///
  /// Valide un mot de passe : requis, au moins [passwordMinLength] caractères,
  /// avec une lettre, un chiffre et un caractère spécial.
  static String? password(String? value, AppStrings strings) {
    final v = value ?? '';
    if (v.isEmpty) {
      return strings.validationPasswordRequired;
    }
    if (v.length < passwordMinLength) {
      return strings.validationPasswordTooShort;
    }
    final hasLetter = _letterRegExp.hasMatch(v);
    final hasDigit = _digitsRegExp.hasMatch(v);
    final hasSpecial = _specialCharRegExp.hasMatch(v);
    if (!hasLetter || !hasDigit || !hasSpecial) {
      return strings.validationPasswordWeak;
    }
    return null;
  }

  /// Lightweight sign-in password check: only requires a non-empty value.
  ///
  /// Sign-in should not reveal complexity rules; the backend is the source of
  /// truth for whether the credentials are correct.
  static String? signInPassword(String? value, AppStrings strings) {
    if ((value ?? '').isEmpty) {
      return strings.validationPasswordRequired;
    }
    return null;
  }
}
