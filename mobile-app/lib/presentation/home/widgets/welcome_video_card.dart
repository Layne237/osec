import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../shared/widgets/course_thumbnail.dart';

/// Hero card for the free welcome video shown at the top of the home screen.
///
/// Carte principale de la vidéo de bienvenue gratuite, en haut de l'accueil.
///
/// Plays without any purchase, so it carries the Gold "FREE" badge and a large
/// play affordance. Scales down slightly while pressed.
///
/// Lisible sans achat : badge « GRATUIT » doré et grand bouton de lecture.
class WelcomeVideoCard extends StatefulWidget {
  const WelcomeVideoCard({
    super.key,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.duration,
    required this.freeBadgeLabel,
    required this.onTap,
  });

  final String title;
  final String description;
  final String thumbnailUrl;

  /// Human-readable runtime, e.g. `4:32`. / Durée lisible.
  final String duration;

  /// Localized "FREE" badge copy. / Libellé « GRATUIT » localisé.
  final String freeBadgeLabel;

  /// Starts playback. / Démarre la lecture.
  final VoidCallback onTap;

  @override
  State<WelcomeVideoCard> createState() => _WelcomeVideoCardState();
}

class _WelcomeVideoCardState extends State<WelcomeVideoCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: AppConstants.animationFast,
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.containerSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: AppColors.glassShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 16:9 thumbnail with play overlay and badges.
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CourseThumbnail(
                      imageUrl: widget.thumbnailUrl,
                      fallbackIcon: Icons.ondemand_video_outlined,
                    ),
                    // Scrim improves contrast for the overlaid controls.
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Center(child: _PlayButton(pressed: _pressed)),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _FreeBadge(label: widget.freeBadgeLabel),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: _DurationChip(duration: widget.duration),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular play affordance that grows slightly on press.
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.pressed});

  final bool pressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.animationFast,
      width: pressed ? 68 : 64,
      height: pressed ? 68 : 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.royalBlue.withValues(alpha: 0.92),
        boxShadow: [
          BoxShadow(
            color: AppColors.royalBlue.withValues(alpha: 0.5),
            blurRadius: 24,
            spreadRadius: -2,
          ),
        ],
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 38,
      ),
    );
  }
}

/// Gold "FREE" badge. / Badge doré « GRATUIT ».
class _FreeBadge extends StatelessWidget {
  const _FreeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: AppColors.obsidian,
        ),
      ),
    );
  }
}

/// Translucent runtime chip. / Puce de durée translucide.
class _DurationChip extends StatelessWidget {
  const _DurationChip({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        duration,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
