import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';

/// A pulsing placeholder used while content loads.
///
/// Espace réservé animé affiché pendant le chargement du contenu.
///
/// Implemented with a sliding [LinearGradient] rather than a third-party
/// shimmer package, so it adds no dependency and inherits the OSEC palette.
///
/// Implémenté avec un dégradé glissant plutôt qu'un paquet externe : aucune
/// dépendance supplémentaire et respect de la palette OSEC.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.child,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  /// Optional child clipped by the shimmer surface (rarely needed).
  final Widget? child;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(12);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Sweeps the highlight from left to right across the box.
        final slide = (_controller.value * 3) - 1.5;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment(slide - 1, 0),
              end: Alignment(slide + 1, 0),
              colors: const [
                AppColors.containerSurface,
                AppColors.containerSurfaceLight,
                AppColors.containerSurface,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
