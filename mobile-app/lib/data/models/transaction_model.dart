import 'package:equatable/equatable.dart';

/// Supported mobile-payment providers. / Fournisseurs de paiement mobile.
///
/// The wire code (`code`) is what the backend and stored history use; the enum
/// is what the UI switches on.
enum PaymentMethod {
  /// MTN Mobile Money. / MTN Mobile Money.
  mtnMomo('mobile_money'),

  /// Orange Money. / Orange Money.
  orangeMoney('orange_money');

  const PaymentMethod(this.code);

  /// Stable string persisted in transactions. / Code stable persisté.
  final String code;

  /// Resolves a [PaymentMethod] from its [code], defaulting to [mtnMomo].
  static PaymentMethod fromCode(String? code) {
    return PaymentMethod.values.firstWhere(
      (m) => m.code == code,
      orElse: () => PaymentMethod.mtnMomo,
    );
  }
}

/// Lifecycle of a payment. / Cycle de vie d'un paiement.
enum TransactionStatus {
  pending('pending'),
  completed('completed'),
  failed('failed');

  const TransactionStatus(this.code);

  final String code;

  static TransactionStatus fromCode(String? code) {
    return TransactionStatus.values.firstWhere(
      (s) => s.code == code,
      orElse: () => TransactionStatus.pending,
    );
  }
}

/// A single payment attempt for a course. / Une tentative de paiement d'un cours.
///
/// Persisted locally for offline receipt access and transaction history.
///
/// Persisté localement pour l'accès hors ligne aux reçus et à l'historique.
class TransactionModel extends Equatable {
  const TransactionModel({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.status,
    required this.phoneNumber,
    required this.transactionReference,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String courseId;
  final String courseTitle;
  final double amount;
  final String currency;
  final PaymentMethod paymentMethod;
  final TransactionStatus status;
  final String phoneNumber;
  final String transactionReference;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Whether the payment completed successfully. / Paiement abouti.
  bool get isCompleted => status == TransactionStatus.completed;

  /// Whether the payment failed. / Paiement échoué.
  bool get isFailed => status == TransactionStatus.failed;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(Object? value) {
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value)?.toUtc() ?? DateTime.now().toUtc();
      }
      return DateTime.now().toUtc();
    }

    return TransactionModel(
      id: (json['id'] ?? '').toString(),
      courseId: (json['courseId'] ?? json['course_id'] ?? '').toString(),
      courseTitle: (json['courseTitle'] ?? json['course_title'] ?? '').toString(),
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : double.tryParse('${json['amount']}') ?? 0,
      currency: (json['currency'] ?? 'XAF').toString(),
      paymentMethod: PaymentMethod.fromCode(
        (json['paymentMethod'] ?? json['payment_method'])?.toString(),
      ),
      status: TransactionStatus.fromCode(json['status']?.toString()),
      phoneNumber: (json['phoneNumber'] ?? json['phone_number'] ?? '').toString(),
      transactionReference:
          (json['transactionReference'] ?? json['transaction_reference'] ?? '')
              .toString(),
      createdAt: parseDate(json['createdAt'] ?? json['created_at']),
      updatedAt: parseDate(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'courseId': courseId,
        'courseTitle': courseTitle,
        'amount': amount,
        'currency': currency,
        'paymentMethod': paymentMethod.code,
        'status': status.code,
        'phoneNumber': phoneNumber,
        'transactionReference': transactionReference,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  TransactionModel copyWith({
    String? id,
    String? courseId,
    String? courseTitle,
    double? amount,
    String? currency,
    PaymentMethod? paymentMethod,
    TransactionStatus? status,
    String? phoneNumber,
    String? transactionReference,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      transactionReference: transactionReference ?? this.transactionReference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseId,
        courseTitle,
        amount,
        currency,
        paymentMethod,
        status,
        phoneNumber,
        transactionReference,
        createdAt,
        updatedAt,
      ];
}
