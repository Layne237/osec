import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import 'shimmer_box.dart';

/// A course cover image that always renders something.
///
/// Image de couverture de cours qui affiche toujours un visuel.
///
/// Network images can fail for many reasons in production — offline devices,
/// CORS on the web, an expired CDN link. Rather than showing a broken box, this
/// widget falls back to a branded gradient with an icon, and shows a [ShimmerBox]
/// while the bytes are in flight.
///
/// Les images distantes peuvent échouer (hors ligne, CORS sur le web, lien
/// expiré). Ce widget affiche alors un dégradé de marque avec une icône.
class CourseThumbnail extends StatelessWidget {
  const CourseThumbnail({
    super.key,
    required this.imageUrl,
    this.fallbackIcon = Icons.play_lesson_outlined,
    this.seed = 0,
  });

  /// Remote cover image URL. / URL distante de l'image.
  final String imageUrl;

  /// Icon shown on the gradient fallback. / Icône du dégradé de repli.
  final IconData fallbackIcon;

  /// Varies the fallback gradient so adjacent cards don't look identical.
  /// Fait varier le dégradé de repli entre les cartes voisines.
  final int seed;

  static const List<List<Color>> _fallbackGradients = [
    [AppColors.royalBlue, AppColors.obsidianLight],
    [AppColors.royalBlueDark, AppColors.containerSurfaceLight],
    [AppColors.emeraldGreen, AppColors.obsidianLight],
  ];

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _buildFallback();

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const ShimmerBox(borderRadius: BorderRadius.zero);
      },
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    final colors = _fallbackGradients[seed.abs() % _fallbackGradients.length];
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: 40,
          color: Colors.white.withValues(alpha: 0.85),
        ),
      ),
    );
  }
}
