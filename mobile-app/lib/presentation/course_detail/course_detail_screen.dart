import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/course_model.dart';
import '../../data/models/lesson_model.dart';
import '../../data/repositories/course_repository.dart';
import '../checkout/checkout_screen.dart';
import '../shared/widgets/course_thumbnail.dart';
import '../shared/widgets/shimmer_box.dart';
import 'widgets/locked_content_dialog.dart';
import 'widgets/module_accordion.dart';

/// Full course detail: hero header, metadata, description, an accordion of
/// modules/lessons with locked-content handling, and a purchase CTA.
///
/// Détail complet du cours : en-tête, métadonnées, description, accordéon des
/// modules/leçons avec gestion du contenu verrouillé, et appel à l'achat.
///
/// Loads through [CourseRepository] so purchase and progress reflect the local
/// state; after a successful checkout it reloads to reveal unlocked content.
///
/// Charge via [CourseRepository] ; après un paiement réussi, il recharge pour
/// révéler le contenu débloqué.
class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    super.key,
    required this.courseId,
    this.repository,
  });

  final String courseId;

  /// Injectable for tests; defaults to a fresh [CourseRepository].
  /// Injectable pour les tests ; par défaut un [CourseRepository] neuf.
  final CourseRepository? repository;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late final CourseRepository _repository =
      widget.repository ?? CourseRepository();

  CourseModel? _course;
  bool _loading = true;
  bool _error = false;

  String get _localeCode => Localizations.localeOf(context).languageCode;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final course = await _repository.getCourse(widget.courseId);
      if (!mounted) return;
      setState(() {
        _course = course;
        _loading = false;
        _error = course == null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  void _showComingSoon() {
    final strings = AppStrings.of(_localeCode);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(strings.homeComingSoon),
          backgroundColor: AppColors.containerSurfaceLight,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  /// Opens checkout; on success reloads so the course shows as unlocked.
  ///
  /// Ouvre le paiement ; en cas de succès, recharge pour afficher le déblocage.
  Future<void> _startCheckout() async {
    final course = _course;
    if (course == null) return;
    final purchased = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CheckoutScreen(
          course: course,
          courseRepository: _repository,
        ),
      ),
    );
    if (!mounted) return;
    if (purchased == true) {
      await _load();
    }
  }

  Future<void> _onLockedLessonTap(LessonModel _) async {
    final course = _course;
    if (course == null) return;
    final strings = AppStrings.of(_localeCode);
    final unlock = await LockedContentDialog.show(
      context,
      course: course,
      strings: strings,
      localeCode: _localeCode,
    );
    if (!mounted) return;
    if (unlock) {
      await _startCheckout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(_localeCode);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: _buildBody(strings),
      bottomNavigationBar: _buildBottomBar(strings),
    );
  }

  Widget _buildBody(AppStrings strings) {
    if (_loading) {
      return const _DetailSkeleton();
    }
    if (_error || _course == null) {
      return _DetailError(strings: strings, onRetry: _load);
    }
    return _DetailContent(
      course: _course!,
      strings: strings,
      localeCode: _localeCode,
      onLockedLessonTap: _onLockedLessonTap,
      onPlayLesson: (_) => _showComingSoon(),
    );
  }

  Widget? _buildBottomBar(AppStrings strings) {
    final course = _course;
    if (_loading || _error || course == null || course.isPurchased) {
      return null;
    }
    final priceLabel =
        Formatters.price(course.price, course.currency, locale: _localeCode);
    return _BuyNowBar(
      label: strings.cdBuyNow.replaceAll('{price}', priceLabel),
      onPressed: _startCheckout,
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded content / Contenu chargé
// ---------------------------------------------------------------------------

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.course,
    required this.strings,
    required this.localeCode,
    required this.onLockedLessonTap,
    required this.onPlayLesson,
  });

  final CourseModel course;
  final AppStrings strings;
  final String localeCode;
  final ValueChanged<LessonModel> onLockedLessonTap;
  final ValueChanged<LessonModel> onPlayLesson;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          backgroundColor: AppColors.obsidianLight,
          leading: const _CircleBackButton(),
          flexibleSpace: FlexibleSpaceBar(
            background: _HeaderImage(course: course, strings: strings),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleAndRating(course: course, strings: strings),
                const SizedBox(height: 16),
                _MetaChips(course: course, strings: strings),
                const SizedBox(height: 24),
                _SectionTitle(title: strings.cdAboutTitle),
                const SizedBox(height: 8),
                Text(
                  course.description,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    height: 1.6,
                    color: AppColors.secondaryText,
                  ),
                ),
                if (course.isPurchased && course.progress > 0) ...[
                  const SizedBox(height: 20),
                  _ProgressCard(course: course, strings: strings),
                ],
                const SizedBox(height: 24),
                _SectionTitle(title: strings.cdContentTitle),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          sliver: SliverList.separated(
            itemCount: course.modules.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final module = course.modules[index];
              return ModuleAccordion(
                module: module,
                index: index,
                initiallyExpanded: index == 0,
                lessonsCountLabel: strings.courseLessonsCount
                    .replaceAll('{n}', module.lessonsCount.toString()),
                onLockedLessonTap: onLockedLessonTap,
                onPlayLesson: onPlayLesson,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeaderImage extends StatelessWidget {
  const _HeaderImage({required this.course, required this.strings});

  final CourseModel course;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CourseThumbnail(imageUrl: course.thumbnailUrl),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                AppColors.obsidian.withValues(alpha: 0.95),
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 16,
          child: course.isPurchased
              ? _Pill(
                  label: strings.cdEnrolledBadge,
                  color: AppColors.emeraldGreen,
                  icon: Icons.check_circle_rounded,
                )
              : _Pill(
                  label: course.isFree ? strings.badgeFree : strings.badgePremium,
                  color: course.isFree ? AppColors.gold : AppColors.royalBlue,
                ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final onColor = color == AppColors.gold ? AppColors.obsidian : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: onColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: onColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleAndRating extends StatelessWidget {
  const _TitleAndRating({required this.course, required this.strings});

  final CourseModel course;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.25,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 18, color: AppColors.gold),
            const SizedBox(width: 4),
            Text(
              course.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              strings.courseRatingReviews
                  .replaceAll('{n}', course.reviewsCount.toString()),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppColors.mutedText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChips extends StatelessWidget {
  const _MetaChips({required this.course, required this.strings});

  final CourseModel course;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _MetaChip(icon: Icons.schedule, label: course.duration),
        _MetaChip(
          icon: Icons.menu_book_outlined,
          label: strings.courseLessonsCount
              .replaceAll('{n}', course.lessonsCount.toString()),
        ),
        _MetaChip(icon: Icons.bar_chart_rounded, label: strings.cdAllLevels),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.containerSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.royalBlueLight),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.course, required this.strings});

  final CourseModel course;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.royalBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.royalBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.homeContinueLearning,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
              Text(
                strings.courseProgressComplete
                    .replaceAll('{p}', course.progressPercent.toString()),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.royalBlueLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: course.progress.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.obsidianLight,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.royalBlue),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Chrome: back button, buy bar, skeleton, error
// ---------------------------------------------------------------------------

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: AppColors.obsidian.withValues(alpha: 0.5),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => Navigator.of(context).maybePop(),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.arrow_back_rounded,
                size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Sticky, glossy "Buy now" bar for premium courses. / Barre d'achat fixe.
class _BuyNowBar extends StatelessWidget {
  const _BuyNowBar({required this.label, required this.onPressed});

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
      child: SafeArea(
        top: false,
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
            child: ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.lock_open_rounded, size: 18),
              label: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const ShimmerBox(height: 240, borderRadius: BorderRadius.zero),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(height: 24, borderRadius: BorderRadius.circular(6)),
              const SizedBox(height: 12),
              FractionallySizedBox(
                widthFactor: 0.5,
                child:
                    ShimmerBox(height: 14, borderRadius: BorderRadius.circular(6)),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < 3; i++) ...[
                ShimmerBox(height: 64, borderRadius: BorderRadius.circular(16)),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailError extends StatelessWidget {
  const _DetailError({required this.strings, required this.onRetry});

  final AppStrings strings;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const Positioned(top: 0, left: 0, child: _CircleBackButton()),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_rounded,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    strings.homeErrorTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(strings.homeRetry),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
