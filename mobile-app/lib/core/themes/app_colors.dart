import 'package:flutter/material.dart';

/// OSEC brand color palette.
///
/// Rooted in deep obsidian tones ("Intellectual Luxury") with Royal Blue
/// as the primary signal color, Emerald Green for success/growth states,
/// and Gold reserved for premium/certified statuses.
/// See docs/brand_guidelines/design_system.md for the full spec.
class AppColors {
  AppColors._();

  // Primary Background
  static const Color obsidian = Color(0xFF11131B);
  static const Color obsidianLight = Color(0xFF1A1D2A);

  // Surfaces
  static const Color containerSurface = Color(0xFF1D1F27);
  static const Color containerSurfaceLight = Color(0xFF282C38);

  // Brand Colors
  static const Color royalBlue = Color(0xFF2563EB);
  static const Color royalBlueLight = Color(0xFF4B83F5);
  static const Color royalBlueDark = Color(0xFF1A4CB8);

  // Status Colors
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color emeraldGreenLight = Color(0xFF34D399);

  // Accent
  static const Color gold = Color(0xFFFBBF24);
  static const Color goldLight = Color(0xFFFCD34D);

  // Text
  static const Color primaryText = Color(0xFFE1E2ED);
  static const Color secondaryText = Color(0xFF8B8FA9);
  static const Color mutedText = Color(0xFF5A5F7A);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Glassmorphism
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Shadows
  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
    ),
  ];
}
