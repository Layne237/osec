import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/course_model.dart';
import '../models/transaction_model.dart';

/// Categories of payment failure, decoupled from UI copy.
///
/// Catégories d'échec de paiement, indépendantes du texte d'IU.
enum PaymentErrorType { network, declined, timeout, unknown }

/// Typed payment exception. / Exception de paiement typée.
class PaymentException implements Exception {
  const PaymentException(this.type, [this.debugMessage]);

  final PaymentErrorType type;
  final String? debugMessage;

  @override
  String toString() =>
      'PaymentException($type)${debugMessage != null ? ': $debugMessage' : ''}';
}

/// When `true`, payments are simulated in-app instead of hitting the MTN /
/// Orange collection APIs. Set to `false` once the gateways are wired.
///
/// Lorsque `true`, les paiements sont simulés au lieu d'appeler les API MTN /
/// Orange. Passez à `false` une fois les passerelles connectées.
///
/// SIMULATION RULES / RÈGLES DE SIMULATION:
///   • Payments succeed by default after a short delay.
///   • To exercise the failure path, use a payment number ending in `0000`
///     (e.g. `650 000 000`) — it returns a "declined" result.
const bool kUseMockPayments = true;

/// Handles payment initiation, verification and local transaction history.
///
/// Gère l'initiation des paiements, la vérification et l'historique local.
///
/// Mobile Money (MTN) and Orange Money share one flow here; in production each
/// [PaymentMethod] maps to its own collection endpoint.
///
/// Mobile Money (MTN) et Orange Money partagent ce flux ; en production, chaque
/// [PaymentMethod] correspond à son propre point de terminaison.
class PaymentRepository {
  PaymentRepository({SharedPreferences? prefs}) : _injectedPrefs = prefs;

  final SharedPreferences? _injectedPrefs;

  static const String _kHistoryKey = 'osec_transactions';
  static const Duration _initiateLatency = Duration(milliseconds: 900);
  static const Duration _verifyLatency = Duration(milliseconds: 1600);

  final Random _random = Random();

  Future<SharedPreferences> get _prefs async =>
      _injectedPrefs ?? await SharedPreferences.getInstance();

  // --- Public API ---------------------------------------------------------

  /// Initiates a payment for [course] using [method] and [phoneNumber] (E.164),
  /// returning a `pending` transaction. In production this prompts the user's
  /// phone to approve the debit.
  ///
  /// Initie un paiement pour [course] et retourne une transaction « en attente ».
  Future<TransactionModel> initiatePayment({
    required CourseModel course,
    required PaymentMethod method,
    required String phoneNumber,
  }) async {
    if (kUseMockPayments) {
      return _mockInitiate(course, method, phoneNumber);
    }
    // Real gateway integration goes here (MTN / Orange collection request).
    throw const PaymentException(
      PaymentErrorType.unknown,
      'Live payment gateway not configured',
    );
  }

  /// Verifies whether a [pending] transaction was approved, returning a
  /// `completed` or `failed` transaction. In production this polls the gateway.
  ///
  /// Vérifie si une transaction « en attente » a été approuvée.
  Future<TransactionModel> verifyPayment(TransactionModel pending) async {
    if (kUseMockPayments) {
      return _mockVerify(pending);
    }
    throw const PaymentException(
      PaymentErrorType.unknown,
      'Live payment gateway not configured',
    );
  }

  /// Locally stored transactions, newest first. / Transactions locales.
  Future<List<TransactionModel>> history() async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_kHistoryKey) ?? const [];
    final items = <TransactionModel>[];
    for (final entry in raw) {
      try {
        items.add(
          TransactionModel.fromJson(jsonDecode(entry) as Map<String, dynamic>),
        );
      } catch (e) {
        debugPrint('Skipping corrupt transaction record: $e');
      }
    }
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  /// Persists (inserts or updates) a [transaction] in local history.
  ///
  /// Persiste (insère ou met à jour) une transaction dans l'historique local.
  Future<void> saveTransaction(TransactionModel transaction) async {
    final prefs = await _prefs;
    final raw = List<String>.from(prefs.getStringList(_kHistoryKey) ?? const []);
    final existing = await history();
    final withoutCurrent =
        existing.where((t) => t.id != transaction.id).toList();
    final updated = [transaction, ...withoutCurrent];
    raw
      ..clear()
      ..addAll(updated.map((t) => jsonEncode(t.toJson())));
    await prefs.setStringList(_kHistoryKey, raw);
  }

  // --- Mock implementation ------------------------------------------------

  Future<TransactionModel> _mockInitiate(
    CourseModel course,
    PaymentMethod method,
    String phoneNumber,
  ) async {
    await Future<void>.delayed(_initiateLatency);
    final now = DateTime.now().toUtc();
    final pending = TransactionModel(
      id: 'txn_${now.millisecondsSinceEpoch}_${_random.nextInt(9999)}',
      courseId: course.id,
      courseTitle: course.title,
      amount: course.price,
      currency: course.currency,
      paymentMethod: method,
      status: TransactionStatus.pending,
      phoneNumber: phoneNumber,
      transactionReference: _generateReference(),
      createdAt: now,
      updatedAt: now,
    );
    await saveTransaction(pending);
    return pending;
  }

  Future<TransactionModel> _mockVerify(TransactionModel pending) async {
    await Future<void>.delayed(_verifyLatency);
    final digits = pending.phoneNumber.replaceAll(RegExp(r'\D'), '');
    final shouldFail = digits.endsWith('0000');
    final resolved = pending.copyWith(
      status: shouldFail ? TransactionStatus.failed : TransactionStatus.completed,
      updatedAt: DateTime.now().toUtc(),
    );
    await saveTransaction(resolved);
    if (shouldFail) {
      throw PaymentException(
        PaymentErrorType.declined,
        'Simulated decline for ${pending.phoneNumber}',
      );
    }
    return resolved;
  }

  /// Generates a human-readable transaction reference, e.g. `OSEC-8F3K2P`.
  String _generateReference() {
    const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final code = List.generate(
      6,
      (_) => alphabet[_random.nextInt(alphabet.length)],
    ).join();
    return 'OSEC-$code';
  }
}
