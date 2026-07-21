import 'package:equatable/equatable.dart';

/// Immutable representation of an authenticated OSEC user.
///
/// Représentation immuable d'un utilisateur OSEC authentifié.
///
/// The model is deliberately transport-agnostic: [fromJson]/[toJson] map to the
/// OSEC backend contract, while [Equatable] gives value equality so widgets and
/// providers can diff instances cheaply.
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.preferredLanguage,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    this.email,
  });

  /// Unique server-assigned identifier. / Identifiant unique côté serveur.
  final String id;

  /// E.164 phone number, e.g. `+237612345678`. / Numéro au format E.164.
  final String phoneNumber;

  /// Optional email address. / Adresse e-mail facultative.
  final String? email;

  /// User's display name. / Nom d'affichage de l'utilisateur.
  final String fullName;

  /// Preferred locale code (`fr` or `en`). / Code de langue préféré.
  final String preferredLanguage;

  /// Account creation timestamp (UTC). / Date de création (UTC).
  final DateTime createdAt;

  /// Last update timestamp (UTC). / Date de dernière mise à jour (UTC).
  final DateTime updatedAt;

  /// Whether the phone number has been OTP-verified. / Numéro vérifié par OTP.
  final bool isVerified;

  /// Builds a [UserModel] from a decoded JSON map.
  ///
  /// Tolerant of the common field-name variants the backend may emit
  /// (`fullName`/`full_name`, `phoneNumber`/`phone_number`, …) and of missing
  /// timestamps, which fall back to "now" so the UI never crashes on partial
  /// payloads.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    String pick(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = json[key];
        if (value != null) return value.toString();
      }
      return fallback;
    }

    DateTime parseDate(List<String> keys) {
      for (final key in keys) {
        final value = json[key];
        if (value is String && value.isNotEmpty) {
          final parsed = DateTime.tryParse(value);
          if (parsed != null) return parsed.toUtc();
        }
      }
      return DateTime.now().toUtc();
    }

    final rawEmail = pick(['email']);

    return UserModel(
      id: pick(['id', '_id', 'userId']),
      phoneNumber: pick(['phoneNumber', 'phone_number', 'phone', 'msisdn']),
      email: rawEmail.isEmpty ? null : rawEmail,
      fullName: pick(['fullName', 'full_name', 'name']),
      preferredLanguage: pick(
        ['preferredLanguage', 'preferred_language', 'locale', 'language'],
        fallback: 'fr',
      ),
      createdAt: parseDate(['createdAt', 'created_at']),
      updatedAt: parseDate(['updatedAt', 'updated_at']),
      isVerified: json['isVerified'] == true ||
          json['is_verified'] == true ||
          json['verified'] == true,
    );
  }

  /// Serializes the user to a JSON map using camelCase keys.
  Map<String, dynamic> toJson() => {
        'id': id,
        'phoneNumber': phoneNumber,
        'email': email,
        'fullName': fullName,
        'preferredLanguage': preferredLanguage,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isVerified': isVerified,
      };

  /// Returns a copy with the provided fields overridden.
  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    String? fullName,
    String? preferredLanguage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        email,
        fullName,
        preferredLanguage,
        createdAt,
        updatedAt,
        isVerified,
      ];
}
