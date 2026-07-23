import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/course_model.dart';

/// Glassmorphic alert shown when a locked lesson is tapped, inviting the learner
/// to purchase the course.
///
/// Alerte glassmorphique affichée au clic sur une leçon verrouillée, invitant à
/// acheter le cours.
///
/// Returns `true` via [Navigator.pop] when the user chooses to unlock, so the
/// caller can route to checkout.
///
/// Retourne `true` via [Navigator.pop] lorsque l'utilisateur choisit de
/// débloquer, afin que l'appelant ouvre le paiement.
class LockedContentDialog extends StatelessWidget {
  const LockedContentDialog({
    super.key,
    required this.course,
    required this.strings,
    required this.localeCode,
  });

  final CourseModel course;
  final AppStrings strings;
  final String localeCode;

  /// Shows the dialog and resolves to `true` when the user taps "Unlock now".
  ///
  /// Affiche la boîte de dialogue et retourne `true` sur « Débloquer ».
  static Future<bool> show(
    BuildContext context, {
    required CourseModel course,
    required AppStrings strings,
    required String localeCode,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => LockedContentDialog(
        course: course,
        strings: strings,
        localeCode: localeCode,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final priceLabel = Formatters.price(
      course.price,
      course.currency,
      locale: localeCode,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.containerSurface.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: AppColors.glassShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withValues(alpha: 0.14),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: 30,
                    color: AppColors.gold.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  strings.lockedTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  strings.lockedMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 20),
                // Course name + price summary.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.obsidian.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        priceLabel,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.obsidian,
                    ),
                    icon: const Icon(Icons.lock_open_rounded, size: 18),
                    label: Text(strings.lockedUnlockNow),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    strings.commonCancel,
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
