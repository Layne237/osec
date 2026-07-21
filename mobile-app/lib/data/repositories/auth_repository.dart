import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Categories of authentication failure, decoupled from any UI copy.
///
/// Catégories d'échec d'authentification, indépendantes de tout texte d'IU.
///
/// The presentation layer maps each value to a localized message (see
/// `AppStrings`), so the repository never imports user-facing strings.
enum AuthErrorType {
  network,
  invalidCredentials,
  userExists,
  invalidOtp,
  otpExpired,
  weakPassword,
  server,
  unknown,
}

/// Typed exception carrying an [AuthErrorType] and an optional developer-facing
/// [debugMessage] (never shown to end users).
///
/// Exception typée portant un [AuthErrorType] et un [debugMessage] technique
/// (jamais affiché à l'utilisateur).
class AuthException implements Exception {
  const AuthException(this.type, [this.debugMessage]);

  final AuthErrorType type;
  final String? debugMessage;

  @override
  String toString() => 'AuthException($type)${debugMessage != null ? ': $debugMessage' : ''}';
}

/// The result of a successful authentication (user + token pair).
///
/// Résultat d'une authentification réussie (utilisateur + jetons).
class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserModel user;
  final String accessToken;
  final String refreshToken;
}

/// When `true`, authentication is served by an in-memory [_MockAuthApi] instead
/// of the network. This keeps the full sign-up → OTP → sign-in flow testable
/// before the OSEC backend is deployed.
///
/// Lorsque `true`, l'authentification est servie par une API en mémoire au lieu
/// du réseau — pour tester tout le flux avant le déploiement du backend.
///
/// TEST CREDENTIALS (mock mode) / IDENTIFIANTS DE TEST (mode simulation):
///   • Any sign-up succeeds; the OTP code to enter is **123456**.
///   • Demo sign-in: phone **+237600000000**, password **Password@1**.
///   • Using phone **+237699999999** on sign-up simulates "user already exists".
///
/// Set to `false` once `AppConstants.apiBaseUrl` points to a live backend.
const bool kUseMockAuth = true;

/// Handles all authentication concerns: remote API calls, secure local token
/// storage, error mapping and logout.
///
/// Gère toute l'authentification : appels API distants, stockage sécurisé des
/// jetons, mappage des erreurs et déconnexion.
class AuthRepository {
  AuthRepository({
    Dio? dio,
    FlutterSecureStorage? secureStorage,
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConstants.apiBaseUrl,
                connectTimeout: AppConstants.connectTimeout,
                receiveTimeout: AppConstants.receiveTimeout,
                contentType: Headers.jsonContentType,
              ),
            ),
        _storage = secureStorage ?? const FlutterSecureStorage(),
        _mock = _MockAuthApi();

  final Dio _dio;
  final FlutterSecureStorage _storage;
  final _MockAuthApi _mock;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Registers a new account. On success the backend sends an OTP to
  /// [phoneNumber]; call [verifyOtp] next. Does **not** persist tokens yet.
  ///
  /// Inscrit un nouveau compte ; le backend envoie un OTP, appelez ensuite
  /// [verifyOtp]. N'enregistre pas encore de jetons.
  Future<void> signUp({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
    required String preferredLanguage,
  }) async {
    if (kUseMockAuth) {
      return _mock.signUp(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        preferredLanguage: preferredLanguage,
      );
    }
    try {
      await _dio.post<Map<String, dynamic>>('/auth/register', data: {
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        if (email != null && email.isNotEmpty) 'email': email,
        'password': password,
        'preferredLanguage': preferredLanguage,
      });
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Signs in with [phoneNumber] + [password]. Persists the returned tokens and
  /// returns the [AuthSession].
  ///
  /// Connexion avec numéro + mot de passe ; enregistre les jetons.
  Future<AuthSession> login({
    required String phoneNumber,
    required String password,
  }) async {
    final AuthSession session;
    if (kUseMockAuth) {
      session = await _mock.login(phoneNumber: phoneNumber, password: password);
    } else {
      try {
        final response = await _dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: {'phoneNumber': phoneNumber, 'password': password},
        );
        session = _sessionFromResponse(response.data);
      } on DioException catch (e) {
        throw _mapDioError(e);
      }
    }
    await _persistSession(session);
    return session;
  }

  /// Verifies the 6-digit OTP [code] for [phoneNumber]. On success persists the
  /// tokens and returns the [AuthSession].
  ///
  /// Vérifie le code OTP à 6 chiffres ; enregistre les jetons en cas de succès.
  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final AuthSession session;
    if (kUseMockAuth) {
      session = await _mock.verifyOtp(phoneNumber: phoneNumber, code: code);
    } else {
      try {
        final response = await _dio.post<Map<String, dynamic>>(
          '/auth/verify-otp',
          data: {'phoneNumber': phoneNumber, 'code': code},
        );
        session = _sessionFromResponse(response.data);
      } on DioException catch (e) {
        throw _mapDioError(e);
      }
    }
    await _persistSession(session);
    return session;
  }

  /// Requests a fresh OTP for [phoneNumber]. / Redemande un OTP.
  Future<void> resendOtp({required String phoneNumber}) async {
    if (kUseMockAuth) {
      return _mock.resendOtp(phoneNumber: phoneNumber);
    }
    try {
      await _dio.post<void>('/auth/resend-otp', data: {'phoneNumber': phoneNumber});
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Triggers a password reset for the given [identifier] (phone or email).
  ///
  /// Déclenche une réinitialisation de mot de passe.
  Future<void> forgotPassword({required String identifier}) async {
    if (kUseMockAuth) {
      return _mock.forgotPassword(identifier: identifier);
    }
    try {
      await _dio.post<void>('/auth/forgot-password', data: {'identifier': identifier});
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Clears the local session. Best-effort notifies the backend when online.
  ///
  /// Efface la session locale ; informe le backend au mieux.
  Future<void> logout() async {
    if (!kUseMockAuth) {
      try {
        await _dio.post<void>('/auth/logout');
      } on DioException {
        // Logout must always succeed locally even if the network call fails.
      }
    }
    await _clearSession();
  }

  /// Reads the stored user, or `null` if not signed in. / Utilisateur stocké.
  Future<UserModel?> currentUser() async {
    final raw = await _storage.read(key: _kUserKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  /// The persisted access token, if any. / Jeton d'accès stocké.
  Future<String?> accessToken() => _storage.read(key: AppConstants.keyAuthToken);

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  static const String _kUserKey = 'osec_user';

  AuthSession _sessionFromResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const AuthException(AuthErrorType.server, 'Empty auth response');
    }
    // Support both flat and `{ data: { ... } }` envelopes.
    final body = (data['data'] is Map<String, dynamic>)
        ? data['data'] as Map<String, dynamic>
        : data;
    final userJson = body['user'] is Map<String, dynamic>
        ? body['user'] as Map<String, dynamic>
        : body;
    final accessToken = (body['accessToken'] ?? body['access_token'] ?? body['token'])?.toString();
    final refreshToken =
        (body['refreshToken'] ?? body['refresh_token'])?.toString() ?? '';
    if (accessToken == null || accessToken.isEmpty) {
      throw const AuthException(AuthErrorType.server, 'Missing access token');
    }
    return AuthSession(
      user: UserModel.fromJson(userJson),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> _persistSession(AuthSession session) async {
    await Future.wait([
      _storage.write(key: AppConstants.keyAuthToken, value: session.accessToken),
      _storage.write(key: AppConstants.keyRefreshToken, value: session.refreshToken),
      _storage.write(key: _kUserKey, value: jsonEncode(session.user.toJson())),
    ]);
    _dio.options.headers['Authorization'] = 'Bearer ${session.accessToken}';
  }

  Future<void> _clearSession() async {
    await Future.wait([
      _storage.delete(key: AppConstants.keyAuthToken),
      _storage.delete(key: AppConstants.keyRefreshToken),
      _storage.delete(key: _kUserKey),
    ]);
    _dio.options.headers.remove('Authorization');
  }

  /// Maps a low-level [DioException] to a domain [AuthException].
  AuthException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return AuthException(AuthErrorType.network, e.message);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        // A null response usually means the request never reached the server.
        if (e.response == null) {
          return AuthException(AuthErrorType.network, e.message);
        }
        return _mapStatus(e);
      case DioExceptionType.badResponse:
        return _mapStatus(e);
    }
  }

  AuthException _mapStatus(DioException e) {
    final status = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    final serverCode = (data is Map && data['code'] != null) ? data['code'].toString() : '';

    switch (serverCode) {
      case 'INVALID_OTP':
        return const AuthException(AuthErrorType.invalidOtp);
      case 'OTP_EXPIRED':
        return const AuthException(AuthErrorType.otpExpired);
      case 'USER_EXISTS':
        return const AuthException(AuthErrorType.userExists);
      case 'WEAK_PASSWORD':
        return const AuthException(AuthErrorType.weakPassword);
      case 'INVALID_CREDENTIALS':
        return const AuthException(AuthErrorType.invalidCredentials);
    }

    if (status == 401 || status == 403) {
      return const AuthException(AuthErrorType.invalidCredentials);
    }
    if (status == 409) {
      return const AuthException(AuthErrorType.userExists);
    }
    if (status == 422) {
      return const AuthException(AuthErrorType.invalidOtp);
    }
    if (status >= 500) {
      return const AuthException(AuthErrorType.server);
    }
    return AuthException(AuthErrorType.unknown, 'HTTP $status');
  }
}

// ---------------------------------------------------------------------------
// In-memory mock backend (development only — see [kUseMockAuth]).
// Backend simulé en mémoire (développement uniquement).
// ---------------------------------------------------------------------------

class _MockAuthApi {
  final Set<String> _registeredPhones = {'+237600000000'};
  final Map<String, String> _passwords = {'+237600000000': 'Password@1'};
  final Map<String, Map<String, String>> _pendingSignUps = {};

  static const Duration _latency = Duration(milliseconds: 900);
  static const String _validOtp = '123456';

  Future<void> signUp({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
    required String preferredLanguage,
  }) async {
    await Future<void>.delayed(_latency);
    if (phoneNumber == '+237699999999' || _registeredPhones.contains(phoneNumber)) {
      throw const AuthException(AuthErrorType.userExists);
    }
    _pendingSignUps[phoneNumber] = {
      'fullName': fullName,
      'email': email ?? '',
      'password': password,
      'preferredLanguage': preferredLanguage,
    };
    debugPrint('[MockAuth] OTP for $phoneNumber is $_validOtp');
  }

  Future<AuthSession> login({
    required String phoneNumber,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);
    final known = _registeredPhones.contains(phoneNumber);
    if (!known || _passwords[phoneNumber] != password) {
      throw const AuthException(AuthErrorType.invalidCredentials);
    }
    return _buildSession(phoneNumber);
  }

  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    await Future<void>.delayed(_latency);
    if (code != _validOtp) {
      throw const AuthException(AuthErrorType.invalidOtp);
    }
    final pending = _pendingSignUps.remove(phoneNumber);
    if (pending != null) {
      _registeredPhones.add(phoneNumber);
      _passwords[phoneNumber] = pending['password'] ?? '';
    }
    return _buildSession(phoneNumber, pending: pending);
  }

  Future<void> resendOtp({required String phoneNumber}) async {
    await Future<void>.delayed(_latency);
    debugPrint('[MockAuth] Resent OTP for $phoneNumber is $_validOtp');
  }

  Future<void> forgotPassword({required String identifier}) async {
    await Future<void>.delayed(_latency);
    debugPrint('[MockAuth] Password reset requested for $identifier');
  }

  AuthSession _buildSession(String phoneNumber, {Map<String, String>? pending}) {
    final now = DateTime.now().toUtc();
    final user = UserModel(
      id: 'mock-${phoneNumber.hashCode.abs()}',
      phoneNumber: phoneNumber,
      email: (pending?['email'] ?? '').isEmpty ? null : pending!['email'],
      fullName: pending?['fullName'] ?? 'OSEC Member',
      preferredLanguage: pending?['preferredLanguage'] ?? 'fr',
      createdAt: now,
      updatedAt: now,
      isVerified: true,
    );
    return AuthSession(
      user: user,
      accessToken: 'mock-access-${now.millisecondsSinceEpoch}',
      refreshToken: 'mock-refresh-${now.millisecondsSinceEpoch}',
    );
  }
}
