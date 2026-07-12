import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';

/// Placeholder landing point for the authentication flow.
///
/// The onboarding flow navigates here once a user finishes or skips the
/// intro slides. The real sign-up / phone-verification UI is built out in
/// a follow-up task; this screen only exists so navigation compiles and is
/// testable end-to-end today.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(Localizations.localeOf(context).languageCode);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48, color: AppColors.gold),
              const SizedBox(height: 16),
              Text(
                strings.authScreenComingSoon,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
