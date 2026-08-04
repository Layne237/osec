import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../core/themes/app_colors.dart';

/// Six-digit OTP entry with auto-advance, paste support, a 60-second resend
/// timer and — on Android only — automatic SMS code detection.
///
/// Saisie d'un code OTP à 6 chiffres avec avance automatique, collage, minuteur
/// de renvoi de 60 secondes et détection automatique du SMS (Android uniquement).
///
/// The widget is stateless with respect to the network: it renders [isLoading]
/// and [errorText], and reports intent through [onVerify], [onResend] and
/// [onChangeNumber]. Verification logic lives in the provider/repository.
class OtpVerification extends StatefulWidget {
  const OtpVerification({
    super.key,
    required this.phoneNumber,
    required this.isLoading,
    required this.onVerify,
    required this.onResend,
    required this.onChangeNumber,
    required this.title,
    required this.sentToLabel,
    required this.verifyLabel,
    required this.resendLabel,
    required this.resendInTemplate,
    required this.changeNumberLabel,
    required this.didntReceiveLabel,
    this.errorText,
    this.codeLength = 6,
    this.resendCooldownSeconds = 60,
  });

  /// E.164 number the code was sent to (for display). / Numéro d'envoi.
  final String phoneNumber;

  /// `true` while verification or resend is in flight. / Opération en cours.
  final bool isLoading;

  /// Localized error to display below the boxes, if any. / Erreur localisée.
  final String? errorText;

  /// Called with the full code once [codeLength] digits are entered (and via
  /// the Verify button). / Appelé avec le code complet.
  final ValueChanged<String> onVerify;

  /// Called when the user requests a new code. / Demande d'un nouveau code.
  final Future<void> Function() onResend;

  /// Called to return to the phone entry step. / Retour à la saisie du numéro.
  final VoidCallback onChangeNumber;

  final String title;
  final String sentToLabel;
  final String verifyLabel;
  final String resendLabel;
  final String resendInTemplate;
  final String changeNumberLabel;
  final String didntReceiveLabel;

  final int codeLength;
  final int resendCooldownSeconds;

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> with CodeAutoFill {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  Timer? _timer;
  int _secondsLeft = 0;

  /// SMS retrieval is Android-only; guard so web/iOS/desktop never touch the
  /// missing platform channel. / Détection SMS uniquement sur Android.
  bool get _smsAutofillSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.codeLength, (_) => TextEditingController());
    _focusNodes = List.generate(widget.codeLength, (_) => FocusNode());
    _startResendCountdown();
    _initSmsAutofill();
  }

  void _initSmsAutofill() {
    if (!_smsAutofillSupported) return;
    try {
      // From [CodeAutoFill]; starts listening for an incoming SMS code.
      listenForCode();
    } catch (e) {
      // Non-fatal: fall back to manual entry. / Repli sur la saisie manuelle.
      debugPrint('SMS autofill unavailable: $e');
    }
  }

  /// From the [CodeAutoFill] mixin: invoked when the OS surfaces an SMS code.
  @override
  void codeUpdated() {
    final received = code;
    if (received != null && received.isNotEmpty) {
      _applyCode(received);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    if (_smsAutofillSupported) {
      cancel();
      unregisterListener();
    }
    super.dispose();
  }

  // --- Countdown ----------------------------------------------------------

  void _startResendCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = widget.resendCooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _handleResend() async {
    if (_secondsLeft > 0 || widget.isLoading) return;
    await widget.onResend();
    _clear();
    _startResendCountdown();
    if (mounted) _focusNodes.first.requestFocus();
  }

  // --- Code helpers -------------------------------------------------------

  String get _currentCode => _controllers.map((c) => c.text).join();

  void _applyCode(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    for (var i = 0; i < widget.codeLength; i++) {
      _controllers[i].text = i < digits.length ? digits[i] : '';
    }
    final filledLength = digits.length.clamp(0, widget.codeLength);
    if (filledLength >= widget.codeLength) {
      FocusScope.of(context).unfocus();
      _submitIfComplete();
    } else {
      _focusNodes[filledLength].requestFocus();
    }
  }

  void _clear() {
    for (final c in _controllers) {
      c.clear();
    }
  }

  void _onBoxChanged(int index, String value) {
    // Paste of a multi-character string into a single box.
    if (value.length > 1) {
      _applyCode(value);
      return;
    }
    if (value.isNotEmpty) {
      if (index < widget.codeLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _submitIfComplete();
      }
    }
  }

  void _onBoxBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _submitIfComplete() {
    final codeValue = _currentCode;
    if (codeValue.length == widget.codeLength && !widget.isLoading) {
      widget.onVerify(codeValue);
    }
  }

  void _onVerifyPressed() {
    FocusScope.of(context).unfocus();
    final codeValue = _currentCode;
    if (codeValue.length == widget.codeLength) {
      widget.onVerify(codeValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: '${widget.sentToLabel} ',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.secondaryText,
            ),
            children: [
              TextSpan(
                text: widget.phoneNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.codeLength, (index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == widget.codeLength - 1 ? 0 : 10,
              ),
              child: _OtpBox(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                hasError: hasError,
                enabled: !widget.isLoading,
                autofocus: index == 0,
                onChanged: (value) => _onBoxChanged(index, value),
                onBackspace: () => _onBoxBackspace(index),
              ),
            );
          }),
        ),
        if (hasError) ...[
          const SizedBox(height: 12),
          Text(
            widget.errorText!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.error,
            ),
          ),
        ],
        const SizedBox(height: 28),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _onVerifyPressed,
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(widget.verifyLabel),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            Text(
              widget.didntReceiveLabel,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.secondaryText,
              ),
            ),
            TextButton(
              onPressed:
                  (_secondsLeft == 0 && !widget.isLoading) ? _handleResend : null,
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 40),
                foregroundColor: AppColors.gold,
                disabledForegroundColor: AppColors.mutedText,
              ),
              child: Text(
                _secondsLeft == 0
                    ? widget.resendLabel
                    : widget.resendInTemplate
                        .replaceAll('{s}', _secondsLeft.toString()),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: widget.isLoading ? null : widget.onChangeNumber,
          child: Text(
            widget.changeNumberLabel,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryText,
            ),
          ),
        ),
      ],
    );
  }
}

/// A single OTP digit box. / Une case unique de chiffre OTP.
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.enabled,
    required this.autofocus,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          autofocus: autofocus,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          // Allow >1 char transiently so paste/autofill can be distributed.
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: AppColors.containerSurface,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.mutedText,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.royalBlue,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
