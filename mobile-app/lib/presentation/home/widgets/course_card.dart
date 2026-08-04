import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../data/models/course_model.dart';
import '../../shared/widgets/course_thumbnail.dart';

/// Catalog tile for a single course.
///
/// Tuile du catalogue représentant un cours.
///
/// Shows a 16:9 cover, the title, duration and lesson count, a FREE/PREMIUM
/// badge, a gold padlock when the content is gated, and a Royal Blue progress
/// bar once the course has been purchased.
///
/// Affiche une couverture 16:9, le titre, la durée et le nombre de leçons, un
/// badge GRATUIT/PREMIUM, un cadenas doré si le contenu est verrouillé, et une
/// barre de progression Royal Blue pour les cours achetés.
class CourseCard extends StatefulWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    required this.freeBadgeLabel,
    required this.premiumBadgeLabel,
    required this.lessonsCountTemplate,
    required this.progressTemplate,
    this.thumbnailSeed = 0,
  });

  final CourseModel course;

  /// Navigates to the course detail screen. / Ouvre le détail du cours.
  final VoidCallback onTap;

  final String freeBadgeLabel;
  final String premiumBadgeLabel;

  /// Template containing `{n}`, e.g. `{n} lessons`. / Modèle avec `{n}`.
  final String lessonsCountTemplate;

  /// Template containing `{p}`, e.g. `{p}% complete`. / Modèle avec `{p}`.
  final String progressTemplate;

  /// Varies the fallback gradient between tiles. / Varie le dégradé de repli.
  final int thumbnailSeed;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final showProgress = course.isPurchased && course.progress > 0;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: AppConstants.animationFast,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          // Glassmorphic lift while pressed. / Effet de verre lors de l'appui.
          color: _pressed
              ? AppColors.containerSurfaceLight
              : AppColors.containerSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed ? AppColors.royalBlue : AppColors.glassBorder,
          ),
          boxShadow: _pressed ? AppColors.glassShadow : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CourseThumbnail(
                    imageUrl: course.thumbnailUrl,
                    seed: widget.thumbnailSeed,
                  ),
                  if (course.isLocked)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.obsidian.withValues(alpha: 0.45),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _Badge(
                      label: course.isFree
                          ? widget.freeBadgeLabel
                          : widget.premiumBadgeLabel,
                      isFree: course.isFree,
                    ),
                  ),
                  if (course.isLocked)
                    const Positioned(top: 8, right: 8, child: _LockIcon()),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _MetaRow(
                      duration: course.duration,
                      lessonsLabel: widget.lessonsCountTemplate
                          .replaceAll('{n}', course.lessonsCount.toString()),
                    ),
                    const Spacer(),
                    if (showProgress)
                      _ProgressIndicator(
                        progress: course.progress,
                        label: widget.progressTemplate
                            .replaceAll('{p}', course.progressPercent.toString()),
                      )
                    else
                      _RatingRow(
                        rating: course.rating,
                        reviewsCount: course.reviewsCount,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// FREE (gold) / PREMIUM (Royal Blue) pill. / Pastille GRATUIT / PREMIUM.
class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.isFree});

  final String label;
  final bool isFree;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFree ? AppColors.gold : AppColors.royalBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
          color: isFree ? AppColors.obsidian : Colors.white,
        ),
      ),
    );
  }
}

/// Gold padlock marking gated content. / Cadenas doré du contenu verrouillé.
class _LockIcon extends StatelessWidget {
  const _LockIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.obsidian.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.lock_outline,
        size: 14,
        color: AppColors.gold.withValues(alpha: 0.85),
      ),
    );
  }
}

/// Duration + lesson count line. / Ligne durée + nombre de leçons.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.duration, required this.lessonsLabel});

  final String duration;
  final String lessonsLabel;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontFamily: 'Inter',
      fontSize: 11,
      color: AppColors.secondaryText,
    );
    return Row(
      children: [
        const Icon(Icons.schedule, size: 12, color: AppColors.mutedText),
        const SizedBox(width: 4),
        Flexible(
          child: Text(duration,
              style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.menu_book_outlined, size: 12, color: AppColors.mutedText),
        const SizedBox(width: 4),
        Flexible(
          child: Text(lessonsLabel,
              style: style, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

/// Royal Blue progress bar for purchased courses.
///
/// Barre de progression Royal Blue pour les cours achetés.
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress, required this.label});

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: AppColors.obsidianLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.royalBlue),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.royalBlueLight,
          ),
        ),
      ],
    );
  }
}

/// Star rating shown when there is no progress to display.
///
/// Note affichée lorsqu'il n'y a pas de progression.
class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.reviewsCount});

  final double rating;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 14, color: AppColors.gold),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '($reviewsCount)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: AppColors.mutedText,
            ),
          ),
        ),
      ],
    );
  }
}
