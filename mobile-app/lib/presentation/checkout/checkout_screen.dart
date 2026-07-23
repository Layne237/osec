import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../data/models/course_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/repositories/payment_repository.dart';
import '../auth/widgets/phone_input.dart';
import '../shared/widgets/course_thumbnail.dart';
import '../shared/widgets/shimmer_box.dart';
import 'providers/payment_provider.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/payment_success.dart';

/// Checkout / payment screen for a single [course].
///
/// Écran de paiement pour un [course].
///
/// Owns a [PaymentProvider] and renders one of four phases — form, processing,
/// success or failure. On success the course is unlocked via [CourseRepository];
/// tapping "Start learning" pops with `true` so the detail screen reloads.
///
/// Détient un [PaymentProvider] et affiche l'une des quatre phases — formulaire,
/// traitement, succès ou échec.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({
    super.key,
    required this.course,
    this.courseRepository,
  });

  final CourseModel course;

  /// Shared repository so the unlock is visible to other screens. / Dépôt partagé.
  final CourseRepository? courseRepository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentProvider>(
      create: (_) => PaymentProvider(
        course: course,
        courseRepository: courseRepository,
      ),
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView();

  String _methodLabel(PaymentMethod method, AppStrings strings) {
    switch (method) {
      case PaymentMethod.mtnMomo:
        return strings.checkoutMtnName;
      case PaymentMethod.orangeMoney:
        return strings.checkoutOrangeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final strings = AppStrings.of(localeCode);
    final payment = context.watch<PaymentProvider>();

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      appBar: AppBar(
        title: Text(strings.checkoutTitle),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: switch (payment.status) {
          PaymentStatus.success => PaymentSuccess(
              transaction: payment.transaction!,
              strings: strings,
              localeCode: localeCode,
              methodLabel: _methodLabel(payment.transaction!.paymentMethod, strings),
              onStartLearning: () => Navigator.of(context).pop(true),
              onViewMyCourses: () =>
                  Navigator.of(context).popUntil((r) => r.isFirst),
            ),
          PaymentStatus.processing => _ProcessingView(strings: strings),
          PaymentStatus.failure => _FailureView(
              strings: strings,
              errorText: _errorText(payment.errorType, strings),
              onRetry: payment.retry,
            ),
          PaymentStatus.idle => _CheckoutForm(
              strings: strings,
              localeCode: localeCode,
            ),
        },
      ),
    );
  }

  String _errorText(PaymentErrorType? type, AppStrings strings) {
    switch (type) {
      case PaymentErrorType.network:
        return strings.payErrorNetwork;
      case PaymentErrorType.declined:
        return strings.payErrorDeclined;
      case PaymentErrorType.timeout:
        return strings.payErrorTimeout;
      case PaymentErrorType.unknown:
      case null:
        return strings.payErrorUnknown;
    }
  }
}

// ---------------------------------------------------------------------------
// Form phase / Phase formulaire
// ---------------------------------------------------------------------------

class _CheckoutForm extends StatefulWidget {
  const _CheckoutForm({required this.strings, required this.localeCode});

  final AppStrings strings;
  final String localeCode;

  @override
  State<_CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<_CheckoutForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  Country _country = Country.cameroon;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final payment = context.read<PaymentProvider>();
    await payment.pay(_country.e164(_phoneController.text));
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final payment = context.watch<PaymentProvider>();
    final course = payment.course;
    final priceLabel =
        Formatters.price(course.price, course.currency, locale: widget.localeCode);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionLabel(text: strings.checkoutOrderSummary),
                        const SizedBox(height: 12),
                        _OrderSummary(course: course, priceLabel: priceLabel),
                        const SizedBox(height: 24),
                        _SectionLabel(text: strings.checkoutPaymentMethodTitle),
                        const SizedBox(height: 12),
                        PaymentMethodCard(
                          name: strings.checkoutMtnName,
                          subtitle: strings.checkoutMtnSubtitle,
                          logoText: 'MTN',
                          logoColor: const Color(0xFFFFCC00),
                          selected: payment.method == PaymentMethod.mtnMomo,
                          onTap: () =>
                              payment.selectMethod(PaymentMethod.mtnMomo),
                        ),
                        const SizedBox(height: 12),
                        PaymentMethodCard(
                          name: strings.checkoutOrangeName,
                          subtitle: strings.checkoutOrangeSubtitle,
                          logoText: 'OM',
                          logoColor: const Color(0xFFFF6600),
                          selected: payment.method == PaymentMethod.orangeMoney,
                          onTap: () =>
                              payment.selectMethod(PaymentMethod.orangeMoney),
                        ),
                        const SizedBox(height: 24),
                        PhoneInput(
                          controller: _phoneController,
                          country: _country,
                          onCountryChanged: (c) => setState(() => _country = c),
                          label: strings.checkoutPhoneLabel,
                          hint: strings.authPhoneHint,
                          pickerTitle: strings.authCountryPickerTitle,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _confirm(),
                          validator: (v) => Validators.phone(
                            v,
                            strings,
                            minDigits: _country.minLength,
                            maxDigits: _country.maxLength,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const _SslLabel(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _ConfirmBar(
            label: '${strings.checkoutConfirm} · $priceLabel',
            onPressed: _confirm,
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.course, required this.priceLabel});

  final CourseModel course;
  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.containerSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 88,
              height: 56,
              child: CourseThumbnail(imageUrl: course.thumbnailUrl),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              course.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.3,
                color: AppColors.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            priceLabel,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    );
  }
}

class _SslLabel extends StatelessWidget {
  const _SslLabel();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context).languageCode);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_rounded, size: 14, color: AppColors.emeraldGreen),
        const SizedBox(width: 6),
        Text(
          strings.checkoutSslSecure,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.emeraldGreen,
          ),
        ),
      ],
    );
  }
}

/// Sticky confirm button pinned above the safe area. / Bouton fixe de confirmation.
class _ConfirmBar extends StatelessWidget {
  const _ConfirmBar({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.obsidianLight,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: SizedBox(
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [AppColors.royalBlueLight, AppColors.royalBlue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.royalBlue.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: -6,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Processing phase (shimmer) / Phase de traitement (shimmer)
// ---------------------------------------------------------------------------

class _ProcessingView extends StatelessWidget {
  const _ProcessingView({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ShimmerBox(height: 64, borderRadius: BorderRadius.circular(16)),
          const SizedBox(height: 16),
          ShimmerBox(height: 64, borderRadius: BorderRadius.circular(16)),
          const Spacer(),
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 20),
          Text(
            strings.checkoutProcessing,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: AppColors.secondaryText,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Failure phase / Phase d'échec
// ---------------------------------------------------------------------------

class _FailureView extends StatelessWidget {
  const _FailureView({
    required this.strings,
    required this.errorText,
    required this.onRetry,
  });

  final AppStrings strings;
  final String errorText;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withValues(alpha: 0.14),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
              ),
              child: const Icon(Icons.close_rounded,
                  size: 46, color: AppColors.error),
            ),
            const SizedBox(height: 24),
            Text(
              strings.payFailedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1.5,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(strings.payRetry),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(strings.commonCancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
