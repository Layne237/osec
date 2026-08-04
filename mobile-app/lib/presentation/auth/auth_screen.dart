import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../data/repositories/auth_repository.dart';
import '../home/home_screen.dart';
import 'providers/auth_provider.dart';
import 'widgets/auth_toggle.dart';
import 'widgets/otp_verification.dart';
import 'widgets/phone_input.dart';

/// The OSEC authentication screen: tabbed Sign In / Sign Up, phone-first login
/// with an OTP step, glassmorphic and brand-aligned.
///
/// Écran d'authentification OSEC : onglets Connexion / Inscription, connexion
/// par téléphone avec étape OTP, design glassmorphique aux couleurs de la marque.
///
/// State lives in [AuthProvider] (provided above this widget); the screen is a
/// thin, reactive shell that renders one of three phases — credentials, OTP, or
/// an authenticated placeholder.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Country _country = Country.cameroon;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _localeCode => Localizations.localeOf(context).languageCode;

  /// Maps a repository [AuthErrorType] to localized, user-facing copy.
  ///
  /// Mappe un [AuthErrorType] du dépôt vers un texte localisé pour l'utilisateur.
  String _errorMessage(AuthErrorType type, AppStrings strings) {
    switch (type) {
      case AuthErrorType.network:
        return strings.errorNetwork;
      case AuthErrorType.invalidCredentials:
        return strings.errorInvalidCredentials;
      case AuthErrorType.userExists:
        return strings.errorUserExists;
      case AuthErrorType.invalidOtp:
        return strings.errorInvalidOtp;
      case AuthErrorType.otpExpired:
        return strings.errorOtpExpired;
      case AuthErrorType.weakPassword:
        return strings.errorWeakPassword;
      case AuthErrorType.server:
        return strings.errorServer;
      case AuthErrorType.unknown:
        return strings.errorUnknown;
    }
  }

  /// Replaces the auth screen with the home experience once a session exists.
  ///
  /// Remplace l'écran d'authentification par l'accueil une fois la session
  /// établie — `pushReplacement` empêche tout retour arrière vers le login.
  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  void _showSnack(String message, {bool success = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              success ? AppColors.emeraldGreen : AppColors.containerSurfaceLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // --- Actions ------------------------------------------------------------

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();
    final strings = AppStrings.of(_localeCode);
    final phone = _country.e164(_phoneController.text);

    if (provider.mode == AuthMode.signIn) {
      final ok = await provider.login(
        phoneNumber: phone,
        password: _passwordController.text,
      );
      if (ok && mounted) {
        _showSnack(strings.successSignedIn, success: true);
        _goToHome();
      }
    } else {
      // On success the provider transitions to awaitingOtp and the UI swaps to
      // the OTP view — no snackbar needed here.
      await provider.signUp(
        fullName: _fullNameController.text.trim(),
        phoneNumber: phone,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        preferredLanguage: _localeCode,
      );
    }
  }

  Future<void> _verifyOtp(String code) async {
    final provider = context.read<AuthProvider>();
    final strings = AppStrings.of(_localeCode);
    final ok = await provider.verifyOtp(code);
    if (ok && mounted) {
      _showSnack(strings.successAccountVerified, success: true);
      _goToHome();
    }
  }

  Future<void> _resendOtp() async {
    final provider = context.read<AuthProvider>();
    await provider.resendOtp();
  }

  Future<void> _openForgotPassword() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<AuthProvider>();
    final strings = AppStrings.of(_localeCode);
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.obsidianLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ForgotPasswordSheet(
        strings: strings,
        initialCountry: _country,
        onSubmit: (identifier) => provider.forgotPassword(identifier),
      ),
    );
    if (sent == true && mounted) {
      _showSnack(strings.forgotSentMessage, success: true);
    }
  }

  // --- Build --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(_localeCode);
    final provider = context.watch<AuthProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.obsidian,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const _BackgroundGlow(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: _buildPhase(provider, strings),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhase(AuthProvider provider, AppStrings strings) {
    switch (provider.status) {
      case AuthStatus.awaitingOtp:
        return _GlassCard(
          key: const ValueKey('otp'),
          child: OtpVerification(
            phoneNumber: provider.pendingPhoneNumber ?? '',
            isLoading: provider.isLoading,
            errorText: provider.errorType != null
                ? _errorMessage(provider.errorType!, strings)
                : null,
            onVerify: _verifyOtp,
            onResend: _resendOtp,
            onChangeNumber: provider.cancelOtp,
            title: strings.otpTitle,
            sentToLabel: strings.otpSentTo,
            verifyLabel: strings.otpVerifyButton,
            resendLabel: strings.otpResendButton,
            resendInTemplate: strings.otpResendIn,
            changeNumberLabel: strings.otpChangeNumber,
            didntReceiveLabel: strings.otpDidntReceive,
          ),
        );
      case AuthStatus.authenticated:
        // Transient: the success handler pushes [HomeScreen] on the same frame.
        // Transitoire : le gestionnaire de succès ouvre [HomeScreen].
        return const Padding(
          key: ValueKey('authenticated'),
          padding: EdgeInsets.symmetric(vertical: 64),
          child: Center(child: CircularProgressIndicator()),
        );
      case AuthStatus.unauthenticated:
        return _buildCredentialsCard(provider, strings);
    }
  }

  Widget _buildCredentialsCard(AuthProvider provider, AppStrings strings) {
    final isSignUp = provider.mode == AuthMode.signUp;
    final isLoading = provider.isLoading;

    return Column(
      key: const ValueKey('credentials'),
      children: [
        _Header(strings: strings),
        const SizedBox(height: 32),
        _GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthToggle(
                selected: provider.mode,
                enabled: !isLoading,
                signInLabel: strings.authSignInTab,
                signUpLabel: strings.authSignUpTab,
                onChanged: (mode) => context.read<AuthProvider>().setMode(mode),
              ),
              const SizedBox(height: 24),
              if (provider.errorType != null)
                _ErrorBanner(
                  message: _errorMessage(provider.errorType!, strings),
                  onDismiss: context.read<AuthProvider>().clearError,
                ),
              Form(
                key: _formKey,
                child: AnimatedSize(
                  duration: AppConstants.animationMedium,
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (isSignUp) ...[
                        _LabeledField(
                          label: strings.authFullNameLabel,
                          child: TextFormField(
                            controller: _fullNameController,
                            enabled: !isLoading,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            autofillHints: const [AutofillHints.name],
                            decoration: InputDecoration(
                              hintText: strings.authFullNameHint,
                              prefixIcon: const Icon(Icons.person_outline, size: 20),
                            ),
                            validator: (v) => Validators.fullName(v, strings),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      PhoneInput(
                        controller: _phoneController,
                        country: _country,
                        enabled: !isLoading,
                        onCountryChanged: (c) => setState(() => _country = c),
                        label: strings.authPhoneLabel,
                        hint: strings.authPhoneHint,
                        pickerTitle: strings.authCountryPickerTitle,
                        validator: (v) => Validators.phone(
                          v,
                          strings,
                          minDigits: _country.minLength,
                          maxDigits: _country.maxLength,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (isSignUp) ...[
                        _LabeledField(
                          label: strings.authEmailLabel,
                          child: TextFormField(
                            controller: _emailController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            decoration: InputDecoration(
                              hintText: strings.authEmailHint,
                              prefixIcon: const Icon(Icons.mail_outline, size: 20),
                            ),
                            validator: (v) => Validators.optionalEmail(v, strings),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      _LabeledField(
                        label: strings.authPasswordLabel,
                        child: TextFormField(
                          controller: _passwordController,
                          enabled: !isLoading,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            hintText: strings.authPasswordHint,
                            prefixIcon: const Icon(Icons.lock_outline, size: 20),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                          validator: (v) => isSignUp
                              ? Validators.password(v, strings)
                              : Validators.signInPassword(v, strings),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isSignUp)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : _openForgotPassword,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 40),
                      foregroundColor: AppColors.royalBlueLight,
                    ),
                    child: Text(strings.authForgotPassword),
                  ),
                ),
              SizedBox(height: isSignUp ? 24 : 8),
              _PrimaryButton(
                label: isSignUp
                    ? strings.authCreateAccountButton
                    : strings.authSignInButton,
                isLoading: isLoading,
                onPressed: _submit,
              ),
              if (isSignUp) ...[
                const SizedBox(height: 16),
                Text(
                  strings.authTermsNotice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    height: 1.5,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Presentational sub-widgets / Sous-widgets de présentation
// ---------------------------------------------------------------------------

/// Ambient radial glow behind the auth card. / Halo radial d'arrière-plan.
class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.7, -0.8),
          radius: 1.3,
          colors: [
            AppColors.royalBlue.withValues(alpha: 0.16),
            AppColors.obsidian.withValues(alpha: 0),
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          AppConstants.appName,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.royalBlueLight,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          strings.authWelcomeTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.25,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          strings.authWelcomeSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            height: 1.5,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

/// Frosted-glass container matching the OSEC design system.
///
/// Conteneur en verre dépoli conforme au design system OSEC.
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.containerSurface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: AppColors.glassShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// A field label rendered above its input. / Un libellé de champ au-dessus.
class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondaryText,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// Royal-Blue gradient primary button with an inline loading spinner.
///
/// Bouton principal dégradé Royal Blue avec indicateur de chargement intégré.
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [AppColors.royalBlue, AppColors.royalBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.royalBlue.withValues(alpha: 0.35),
              blurRadius: 24,
              spreadRadius: -6,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(label),
        ),
      ),
    );
  }
}

/// Inline red alert used for authentication errors.
///
/// Alerte rouge en ligne pour les erreurs d'authentification.
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                height: 1.4,
                color: AppColors.error,
              ),
            ),
          ),
          GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(Icons.close, color: AppColors.error, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet collecting a phone number for password reset.
///
/// Feuille modale collectant un numéro pour la réinitialisation du mot de passe.
class _ForgotPasswordSheet extends StatefulWidget {
  const _ForgotPasswordSheet({
    required this.strings,
    required this.initialCountry,
    required this.onSubmit,
  });

  final AppStrings strings;
  final Country initialCountry;
  final Future<bool> Function(String identifier) onSubmit;

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  late Country _country = widget.initialCountry;
  bool _submitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final ok = await widget.onSubmit(_country.e164(_phoneController.text));
    if (!mounted) return;
    setState(() => _submitting = false);
    // Always close on completion; the caller surfaces the (privacy-preserving)
    // confirmation message regardless of whether the account exists.
    Navigator.of(context).pop(ok);
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.mutedText,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              strings.forgotTitle,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.forgotSubtitle,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                height: 1.5,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 24),
            PhoneInput(
              controller: _phoneController,
              country: _country,
              enabled: !_submitting,
              onCountryChanged: (c) => setState(() => _country = c),
              label: strings.authPhoneLabel,
              hint: strings.authPhoneHint,
              pickerTitle: strings.authCountryPickerTitle,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (v) => Validators.phone(
                v,
                strings,
                minDigits: _country.minLength,
                maxDigits: _country.maxLength,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(strings.forgotSendButton),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
              child: Text(strings.forgotCancel),
            ),
          ],
        ),
      ),
    );
  }
}
