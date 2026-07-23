import 'package:flutter/foundation.dart';

import '../../../data/models/course_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/course_repository.dart';
import '../../../data/repositories/payment_repository.dart';

/// Where the checkout flow currently is. / Étape actuelle du paiement.
enum PaymentStatus {
  /// Collecting method + phone number. / Saisie du moyen et du numéro.
  idle,

  /// Contacting the gateway / awaiting approval. / Traitement en cours.
  processing,

  /// Payment completed and course unlocked. / Paiement réussi, cours débloqué.
  success,

  /// Payment failed; the user may retry. / Paiement échoué, réessai possible.
  failure,
}

/// Drives the checkout screen: method selection, payment processing, unlocking
/// the course on success and exposing failures for retry.
///
/// Pilote l'écran de paiement : choix du moyen, traitement, déverrouillage du
/// cours en cas de succès, et exposition des échecs pour réessayer.
class PaymentProvider extends ChangeNotifier {
  PaymentProvider({
    required CourseModel course,
    PaymentRepository? paymentRepository,
    CourseRepository? courseRepository,
  })  : _course = course,
        _paymentRepository = paymentRepository ?? PaymentRepository(),
        _courseRepository = courseRepository ?? CourseRepository();

  final CourseModel _course;
  final PaymentRepository _paymentRepository;
  final CourseRepository _courseRepository;

  PaymentStatus _status = PaymentStatus.idle;
  PaymentMethod _method = PaymentMethod.mtnMomo;
  PaymentErrorType? _errorType;
  TransactionModel? _transaction;

  // --- Reads / Lectures ---------------------------------------------------

  /// The course being purchased. / Le cours en cours d'achat.
  CourseModel get course => _course;

  PaymentStatus get status => _status;

  /// The selected payment method. / Le moyen de paiement sélectionné.
  PaymentMethod get method => _method;

  /// `true` while a payment is being processed. / Traitement en cours.
  bool get isProcessing => _status == PaymentStatus.processing;

  /// The last error category, or `null`. The UI maps this to copy.
  PaymentErrorType? get errorType => _errorType;

  /// The resolved transaction (pending/completed/failed), if any.
  TransactionModel? get transaction => _transaction;

  // --- Mutations / Mutations ----------------------------------------------

  /// Selects a payment method. / Sélectionne un moyen de paiement.
  void selectMethod(PaymentMethod method) {
    if (_method == method || isProcessing) return;
    _method = method;
    notifyListeners();
  }

  /// Runs the full initiate → verify → unlock flow for [phoneNumber] (E.164).
  /// Returns `true` on success.
  ///
  /// Exécute tout le flux initiation → vérification → déverrouillage.
  Future<bool> pay(String phoneNumber) async {
    _status = PaymentStatus.processing;
    _errorType = null;
    notifyListeners();
    try {
      final pending = await _paymentRepository.initiatePayment(
        course: _course,
        method: _method,
        phoneNumber: phoneNumber,
      );
      final completed = await _paymentRepository.verifyPayment(pending);
      await _courseRepository.unlockCourse(_course.id);
      _transaction = completed;
      _status = PaymentStatus.success;
      notifyListeners();
      return true;
    } on PaymentException catch (e) {
      _errorType = e.type;
      _status = PaymentStatus.failure;
      notifyListeners();
      return false;
    } catch (e, stack) {
      debugPrint('Unexpected payment error: $e\n$stack');
      _errorType = PaymentErrorType.unknown;
      _status = PaymentStatus.failure;
      notifyListeners();
      return false;
    }
  }

  /// Returns to the form after a failure so the user can retry.
  ///
  /// Revient au formulaire après un échec pour réessayer.
  void retry() {
    if (_status != PaymentStatus.failure) return;
    _status = PaymentStatus.idle;
    _errorType = null;
    notifyListeners();
  }
}
