import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../providers/auth_provider.dart';

/// Segmented "Sign In / Sign Up" switcher with an animated Royal Blue underline.
///
/// Sélecteur segmenté « Connexion / Inscription » avec un soulignement Royal
/// Blue animé.
///
/// Purely presentational: it renders [selected] and reports taps through
/// [onChanged]. State ownership stays with [AuthProvider].
class AuthToggle extends StatelessWidget {
  const AuthToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.signInLabel,
    required this.signUpLabel,
    this.enabled = true,
  });

  /// The currently active mode. / Le mode actif.
  final AuthMode selected;

  /// Called when the user taps the inactive tab. / Appelé lors d'un changement.
  final ValueChanged<AuthMode> onChanged;

  final String signInLabel;
  final String signUpLabel;

  /// When `false`, taps are ignored (e.g. during a network call).
  /// Lorsque `false`, les touchers sont ignorés (ex. pendant un appel réseau).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.containerSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          final isSignIn = selected == AuthMode.signIn;
          return Stack(
            children: [
              // Animated highlight pill that slides under the active tab.
              AnimatedAlign(
                duration: AppConstants.animationMedium,
                curve: Curves.easeOutCubic,
                alignment:
                    isSignIn ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: tabWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.royalBlue.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.royalBlue.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _ToggleTab(
                    label: signInLabel,
                    isActive: isSignIn,
                    onTap: enabled ? () => onChanged(AuthMode.signIn) : null,
                  ),
                  _ToggleTab(
                    label: signUpLabel,
                    isActive: !isSignIn,
                    onTap: enabled ? () => onChanged(AuthMode.signUp) : null,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: AppConstants.animationFast,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              letterSpacing: 0.3,
              color: isActive ? AppColors.primaryText : AppColors.secondaryText,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
