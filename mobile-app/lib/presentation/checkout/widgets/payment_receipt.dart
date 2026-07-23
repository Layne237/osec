import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/transaction_model.dart';

/// A compact, itemized receipt for a [TransactionModel].
///
/// Un reçu détaillé et compact pour une [TransactionModel].
///
/// Rendered on the success screen and reusable in transaction history. All copy
/// is localized through [strings].
///
/// Affiché sur l'écran de succès et réutilisable dans l'historique.
class PaymentReceipt extends StatelessWidget {
  const PaymentReceipt({
    super.key,
    required this.transaction,
    required this.strings,
    required this.localeCode,
    required this.methodLabel,
  });

  final TransactionModel transaction;
  final AppStrings strings;
  final String localeCode;

  /// Localized payment-method name. / Nom localisé du moyen de paiement.
  final String methodLabel;

  String _statusLabel() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return strings.statusPending;
      case TransactionStatus.completed:
        return strings.statusCompleted;
      case TransactionStatus.failed:
        return strings.statusFailed;
    }
  }

  Color _statusColor() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.completed:
        return AppColors.emeraldGreen;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.obsidian.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined,
                  size: 18, color: AppColors.secondaryText),
              const SizedBox(width: 8),
              Text(
                strings.receiptTitle,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _Row(
            label: strings.receiptTransactionId,
            value: transaction.transactionReference,
          ),
          _Row(
            label: strings.receiptDateTime,
            value: Formatters.dateTime(transaction.createdAt),
          ),
          _Row(
            label: strings.receiptCourse,
            value: transaction.courseTitle,
          ),
          _Row(
            label: strings.receiptMethod,
            value: methodLabel,
          ),
          _Row(
            label: strings.receiptAmount,
            value: Formatters.price(
              transaction.amount,
              transaction.currency,
              locale: localeCode,
            ),
            emphasize: true,
          ),
          const SizedBox(height: 4),
          _Row(
            label: strings.receiptStatus,
            valueWidget: _StatusPill(
              label: _statusLabel(),
              color: _statusColor(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    this.value,
    this.valueWidget,
    this.emphasize = false,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: valueWidget != null
                ? Align(
                    alignment: Alignment.centerRight,
                    child: valueWidget,
                  )
                : Text(
                    value ?? '',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: emphasize ? 'Montserrat' : 'Inter',
                      fontSize: emphasize ? 15 : 13,
                      fontWeight:
                          emphasize ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.primaryText,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
