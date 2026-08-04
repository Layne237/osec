import 'package:flutter/foundation.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

/// The two authentication modes surfaced by the UI tabs.
///
/// Les deux modes d'authentification exposés par les onglets.
enum AuthMode { signIn, signUp }

/// High-level authentication state machine.
///
/// Machine à états de l'authentification.
enum AuthStatus {
  /// No valid session. / Aucune session valide.
  unauthenticated,

  /// A sign-up succeeded and we are waiting for OTP entry.
  /// Une inscription a réussi ; en attente de la saisie de l'OTP.
  awaitingOtp,

  /// A session is established. / Une session est établie.
  authenticated,
}

/// [ChangeNotifier] that owns all authentication state and orchestrates the
/// [AuthRepository]. Exposed to the widget tree via `provider`.
///
/// [ChangeNotifier] qui détient l'état d'authentification et orchestre le
/// [AuthRepository]. Exposé à l'arbre de widgets via `provider`.
class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  // --- State / État -------------------------------------------------------

  AuthMode _mode = AuthMode.signIn;
  AuthStatus _status = AuthStatus.unauthenticated;
  bool _isLoading = false;
  AuthErrorType? _errorType;
  UserModel? _user;
  String? _pendingPhoneNumber;

  /// Whether the user is currently on the Sign In or Sign Up tab.
  AuthMode get mode => _mode;

  /// Current position in the authentication state machine.
  AuthStatus get status => _status;

  /// `true` while a network/auth operation is in flight. / Opération en cours.
  bool get isLoading => _isLoading;

  /// The last error category, or `null` if none. The UI maps this to copy.
  AuthErrorType? get errorType => _errorType;

  /// Whether an error is currently being surfaced. / Une erreur est affichée.
  bool get hasError => _errorType != null;

  /// The authenticated user, if any. / Utilisateur authentifié le cas échéant.
  UserModel? get user => _user;

  /// The number awaiting OTP verification (E.164). / Numéro en attente d'OTP.
  String? get pendingPhoneNumber => _pendingPhoneNumber;

  /// Convenience flag for guarded navigation. / Indicateur de connexion.
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // --- Mutations / Mutations ---------------------------------------------

  /// Switches between Sign In / Sign Up, clearing any stale error.
  void setMode(AuthMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    _errorType = null;
    notifyListeners();
  }

  /// Clears the current error banner. / Efface la bannière d'erreur.
  void clearError() {
    if (_errorType == null) return;
    _errorType = null;
    notifyListeners();
  }

  /// Attempts a silent session restore on app start. Returns `true` if a stored
  /// session was found. / Tente de restaurer une session au démarrage.
  Future<bool> tryRestoreSession() async {
    final user = await _repository.currentUser();
    final token = await _repository.accessToken();
    if (user != null && token != null && token.isNotEmpty) {
      _user = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Signs in with phone + password. / Connexion par numéro + mot de passe.
  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) {
    return _run(() async {
      final session = await _repository.login(
        phoneNumber: phoneNumber,
        password: password,
      );
      _user = session.user;
      _status = AuthStatus.authenticated;
    });
  }

  /// Registers a new account and, on success, transitions to [AuthStatus.awaitingOtp].
  ///
  /// Inscrit un compte puis passe à [AuthStatus.awaitingOtp] en cas de succès.
  Future<bool> signUp({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
    required String preferredLanguage,
  }) {
    return _run(() async {
      await _repository.signUp(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        preferredLanguage: preferredLanguage,
      );
      _pendingPhoneNumber = phoneNumber;
      _status = AuthStatus.awaitingOtp;
    });
  }

  /// Verifies the OTP [code] against [pendingPhoneNumber].
  ///
  /// Vérifie le code OTP par rapport à [pendingPhoneNumber].
  Future<bool> verifyOtp(String code) {
    final phone = _pendingPhoneNumber;
    if (phone == null) {
      _errorType = AuthErrorType.unknown;
      notifyListeners();
      return Future.value(false);
    }
    return _run(() async {
      final session = await _repository.verifyOtp(phoneNumber: phone, code: code);
      _user = session.user;
      _status = AuthStatus.authenticated;
    });
  }

  /// Requests a fresh OTP for the pending number. / Redemande un OTP.
  Future<bool> resendOtp() {
    final phone = _pendingPhoneNumber;
    if (phone == null) return Future.value(false);
    return _run(() => _repository.resendOtp(phoneNumber: phone));
  }

  /// Requests a password reset for [identifier] (phone or email).
  ///
  /// Demande une réinitialisation du mot de passe pour [identifier].
  Future<bool> forgotPassword(String identifier) {
    return _run(() => _repository.forgotPassword(identifier: identifier));
  }

  /// Returns from the OTP step back to the credentials form.
  ///
  /// Revient de l'étape OTP au formulaire d'identifiants.
  void cancelOtp() {
    _pendingPhoneNumber = null;
    _status = AuthStatus.unauthenticated;
    _errorType = null;
    notifyListeners();
  }

  /// Clears the session and returns to the unauthenticated state.
  ///
  /// Efface la session et revient à l'état non authentifié.
  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _pendingPhoneNumber = null;
    _status = AuthStatus.unauthenticated;
    _mode = AuthMode.signIn;
    _errorType = null;
    notifyListeners();
  }

  // --- Internals / Interne ------------------------------------------------

  /// Runs [action] with unified loading + error handling, notifying listeners
  /// around the operation. Returns `true` on success.
  ///
  /// Exécute [action] avec gestion unifiée du chargement et des erreurs.
  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorType = null;
    notifyListeners();
    try {
      await action();
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorType = e.type;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stack) {
      // Any non-AuthException is unexpected; log for developers, show generic.
      debugPrint('Unexpected auth error: $e\n$stack');
      _errorType = AuthErrorType.unknown;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
