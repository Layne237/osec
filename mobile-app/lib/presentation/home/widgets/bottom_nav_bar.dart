import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';

/// The four root destinations of the OSEC app.
///
/// Les quatre destinations racines de l'application OSEC.
enum HomeTab { home, myCourses, tools, profile }

/// Glassmorphic bottom navigation with a Royal Blue active indicator.
///
/// Navigation inférieure glassmorphique avec indicateur actif Royal Blue.
///
/// Icons scale and re-colour smoothly on selection; labels sit below each icon.
///
/// Les icônes changent de taille et de couleur en douceur ; les libellés sont
/// placés sous chaque icône.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.homeLabel,
    required this.myCoursesLabel,
    required this.toolsLabel,
    required this.profileLabel,
  });

  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  final String homeLabel;
  final String myCoursesLabel;
  final String toolsLabel;
  final String profileLabel;

  @override
  Widget build(BuildContext context) {
    final items = <_NavItemData>[
      _NavItemData(
        tab: HomeTab.home,
        label: homeLabel,
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
      ),
      _NavItemData(
        tab: HomeTab.myCourses,
        label: myCoursesLabel,
        icon: Icons.play_lesson_outlined,
        activeIcon: Icons.play_lesson_rounded,
      ),
      _NavItemData(
        tab: HomeTab.tools,
        label: toolsLabel,
        icon: Icons.calculate_outlined,
        activeIcon: Icons.calculate_rounded,
      ),
      _NavItemData(
        tab: HomeTab.profile,
        label: profileLabel,
        icon: Icons.person_outline,
        activeIcon: Icons.person_rounded,
      ),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.obsidianLight.withValues(alpha: 0.88),
            border: const Border(
              top: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68,
              child: Row(
                children: [
                  for (final item in items)
                    Expanded(
                      child: _NavItem(
                        data: item,
                        isActive: item.tab == currentTab,
                        onTap: () => onTabSelected(item.tab),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Immutable description of one navigation destination.
class _NavItemData {
  const _NavItemData({
    required this.tab,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final HomeTab tab;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  final _NavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.royalBlueLight : AppColors.secondaryText;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Active indicator pill above the icon.
          AnimatedContainer(
            duration: AppConstants.animationMedium,
            curve: Curves.easeOutCubic,
            height: 3,
            width: isActive ? 22 : 0,
            decoration: BoxDecoration(
              color: AppColors.royalBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedScale(
            scale: isActive ? 1.12 : 1.0,
            duration: AppConstants.animationFast,
            curve: Curves.easeOut,
            child: Icon(
              isActive ? data.activeIcon : data.icon,
              size: 23,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: AppConstants.animationFast,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
            child: Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
