import 'package:flutter/material.dart';

import 'app_colors.dart';

/// OSEC application theme.
///
/// Implements the "Intellectual Luxury" visual language described in
/// docs/brand_guidelines/design_system.md: an obsidian, dark-first canvas
/// with Royal Blue as the primary action color, Emerald Green for success
/// states, and Gold reserved for premium/certified accents.
class AppTheme {
  AppTheme._();

  static const double _buttonHeight = 48;
  static const double _buttonRadius = 12;
  static const double _inputRadius = 12;
  static const double _cardRadius = 16;

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);

    final textTheme = base.textTheme
        .apply(
          bodyColor: AppColors.primaryText,
          displayColor: AppColors.primaryText,
        )
        .copyWith(
          displayLarge: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 40 / 32,
            letterSpacing: -0.5,
            color: AppColors.primaryText,
          ),
          headlineMedium: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 32 / 24,
            letterSpacing: -0.25,
            color: AppColors.primaryText,
          ),
          headlineSmall: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 28 / 20,
            letterSpacing: -0.25,
            color: AppColors.primaryText,
          ),
          titleMedium: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 24 / 18,
            color: AppColors.primaryText,
          ),
          bodyLarge: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 24 / 16,
            color: AppColors.primaryText,
          ),
          bodyMedium: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            color: AppColors.secondaryText,
          ),
          bodySmall: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
            letterSpacing: 0.25,
            color: AppColors.mutedText,
          ),
          labelLarge: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 20 / 16,
            letterSpacing: 0.5,
            color: AppColors.primaryText,
          ),
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.obsidian,
      canvasColor: AppColors.obsidian,
      primaryColor: AppColors.royalBlue,
      splashColor: AppColors.royalBlue.withValues(alpha: 0.12),
      highlightColor: Colors.transparent,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.obsidian,
        primary: AppColors.royalBlue,
        onPrimary: Colors.white,
        secondary: AppColors.emeraldGreen,
        onSecondary: Colors.white,
        tertiary: AppColors.gold,
        onTertiary: AppColors.obsidian,
        error: AppColors.error,
        onError: Colors.white,
        onSurface: AppColors.primaryText,
        surfaceContainerHighest: AppColors.containerSurfaceLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.primaryText),
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.containerSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_cardRadius),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.royalBlue.withValues(alpha: 0.4),
          minimumSize: const Size.fromHeight(_buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.royalBlue,
          minimumSize: const Size.fromHeight(_buttonHeight),
          side: const BorderSide(color: AppColors.royalBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryText,
          minimumSize: const Size.fromHeight(_buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.containerSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppColors.mutedText,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.secondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.mutedText, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.mutedText, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.royalBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.obsidianLight,
        selectedItemColor: AppColors.royalBlue,
        unselectedItemColor: AppColors.secondaryText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.glassBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.primaryText),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.royalBlue,
        linearTrackColor: AppColors.containerSurfaceLight,
      ),
    );
  }
}
