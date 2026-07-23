import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/module_model.dart';

/// Expandable, glassmorphic module card listing its lessons.
///
/// Carte de module glassmorphique et repliable listant ses leçons.
///
/// Each lesson shows one of three states: locked (gold padlock, dimmed),
/// unlocked (play button), or completed (emerald checkmark). Tapping a locked
/// lesson calls [onLockedLessonTap]; tapping an unlocked one calls [onPlayLesson].
///
/// Chaque leçon affiche l'un des trois états : verrouillée (cadenas doré,
/// atténuée), déverrouillée (bouton lecture) ou terminée (coche émeraude).
class ModuleAccordion extends StatefulWidget {
  const ModuleAccordion({
    super.key,
    required this.module,
    required this.index,
    required this.lessonsCountLabel,
    required this.onLockedLessonTap,
    required this.onPlayLesson,
    this.initiallyExpanded = false,
  });

  final ModuleModel module;

  /// 0-based position, shown as `1`, `2`, … / Position (base 0), affichée dès 1.
  final int index;

  /// Pre-formatted lesson-count label, e.g. `3 lessons`. / Libellé du nombre.
  final String lessonsCountLabel;

  /// Invoked when a locked lesson is tapped. / Appelé sur une leçon verrouillée.
  final ValueChanged<LessonModel> onLockedLessonTap;

  /// Invoked when an unlocked lesson is tapped. / Appelé sur une leçon ouverte.
  final ValueChanged<LessonModel> onPlayLesson;

  final bool initiallyExpanded;

  @override
  State<ModuleAccordion> createState() => _ModuleAccordionState();
}

class _ModuleAccordionState extends State<ModuleAccordion> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.containerSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _Header(
            index: widget.index,
            title: widget.module.title,
            subtitle: widget.lessonsCountLabel,
            expanded: _expanded,
            locked: widget.module.isLocked,
            onTap: _toggle,
          ),
          AnimatedSize(
            duration: AppConstants.animationMedium,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Column(
                    children: [
                      const Divider(height: 1),
                      for (final lesson in widget.module.lessons)
                        _LessonTile(
                          lesson: lesson,
                          onTap: () => lesson.isLocked
                              ? widget.onLockedLessonTap(lesson)
                              : widget.onPlayLesson(lesson),
                        ),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.locked,
    required this.onTap,
  });

  final int index;
  final String title;
  final String subtitle;
  final bool expanded;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Module number badge.
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.royalBlue.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.royalBlue.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.royalBlueLight,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: AppColors.gold.withValues(alpha: 0.5),
                ),
              ),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: AppConstants.animationFast,
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single lesson row within an expanded module.
///
/// Une ligne de leçon au sein d'un module déplié.
class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson, required this.onTap});

  final LessonModel lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Locked lessons render at reduced opacity per the design system.
    final opacity = lesson.isLocked ? 0.5 : 1.0;
    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _LeadingIcon(lesson: lesson),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  lesson.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    height: 1.3,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                lesson.duration,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.lesson});

  final LessonModel lesson;

  @override
  Widget build(BuildContext context) {
    if (lesson.isLocked) {
      return const Icon(Icons.lock_outline, size: 20, color: AppColors.gold);
    }
    if (lesson.isCompleted) {
      return const Icon(Icons.check_circle_rounded,
          size: 20, color: AppColors.emeraldGreen);
    }
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.royalBlue.withValues(alpha: 0.18),
        border: Border.all(color: AppColors.royalBlue),
      ),
      child: const Icon(Icons.play_arrow_rounded,
          size: 14, color: AppColors.royalBlueLight),
    );
  }
}
