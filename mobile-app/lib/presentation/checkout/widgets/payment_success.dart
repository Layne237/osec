import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/transaction_model.dart';
import 'payment_receipt.dart';

/// Celebratory success view shown once a payment completes: an animated emerald
/// checkmark, a confirmation message, the receipt, and next-step actions.
///
/// Vue de succès affichée après un paiement : coche émeraude animée, message de
/// confirmation, reçu et actions suivantes.
class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({
    super.key,
    required this.transaction,
    required this.strings,
    required this.localeCode,
    required this.methodLabel,
    required this.onStartLearning,
    required this.onViewMyCourses,
  });

  final TransactionModel transaction;
  final AppStrings strings;
  final String localeCode;
  final String methodLabel;

  /// Navigates into the unlocked course. / Ouvre le cours débloqué.
  final VoidCallback onStartLearning;

  /// Returns to the course list. / Retour à la liste des cours.
  final VoidCallback onViewMyCourses;

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final Animation<double> _scale = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        children: [
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emeraldGreen.withValues(alpha: 0.16),
                border: Border.all(
                  color: AppColors.emeraldGreen.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 52,
                color: AppColors.emeraldGreen,
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _fade,
            child: Column(
              children: [
                Text(
                  strings.paySuccessTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.paySuccessSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.transaction.courseTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.royalBlueLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          PaymentReceipt(
            transaction: widget.transaction,
            strings: strings,
            localeCode: widget.localeCode,
            methodLabel: widget.methodLabel,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: widget.onStartLearning,
              icon: const Icon(Icons.play_arrow_rounded, size: 20),
              label: Text(strings.payStartLearning),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: widget.onViewMyCourses,
              child: Text(strings.payViewMyCourses),
            ),
          ),
        ],
      ),
    );
  }
}
