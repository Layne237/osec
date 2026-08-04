import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';
import '../auth/auth_screen.dart';

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
}

/// The three-slide welcome flow shown on first launch.
///
/// Presents the OSEC value proposition ("Learn. Build. Earn.") through a
/// glassmorphic, obsidian-and-Royal-Blue design in line with
/// docs/brand_guidelines/design_system.md, then hands off to [AuthScreen].
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<_OnboardingSlide> _slides(AppStrings strings) => [
        _OnboardingSlide(
          icon: Icons.school_outlined,
          title: strings.onboardingSlide1Title,
          subtitle: strings.onboardingSlide1Subtitle,
          accentColor: AppColors.royalBlueLight,
        ),
        _OnboardingSlide(
          icon: Icons.construction_outlined,
          title: strings.onboardingSlide2Title,
          subtitle: strings.onboardingSlide2Subtitle,
          accentColor: AppColors.emeraldGreenLight,
        ),
        _OnboardingSlide(
          icon: Icons.trending_up_rounded,
          title: strings.onboardingSlide3Title,
          subtitle: strings.onboardingSlide3Subtitle,
          accentColor: AppColors.goldLight,
        ),
      ];

  bool get _isLastPage => _currentPage == AppConstants.onboardingSlideCount - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_isLastPage) {
      _completeOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: AppConstants.animationMedium,
      curve: Curves.easeOutCubic,
    );
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final strings = AppStrings.of(languageCode);
    final slides = _slides(strings);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      body: Stack(
        children: [
          _BackgroundGlow(accentColor: slides[_currentPage].accentColor),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  onSkip: _isLastPage ? null : _completeOnboarding,
                  skipLabel: strings.onboardingSkip,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: slides.length,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, index) {
                      return _OnboardingSlideView(slide: slides[index]);
                    },
                  ),
                ),
                _BottomControls(
                  pageCount: slides.length,
                  currentPage: _currentPage,
                  isLastPage: _isLastPage,
                  ctaLabel:
                      _isLastPage ? strings.onboardingGetStarted : strings.onboardingNext,
                  secureLabel: strings.secureAndVerified,
                  accentColor: slides[_currentPage].accentColor,
                  onPressed: _onNextPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConstants.animationSlow,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-0.6, -0.6),
          radius: 1.2,
          colors: [
            accentColor.withValues(alpha: 0.18),
            AppColors.obsidian.withValues(alpha: 0),
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onSkip, required this.skipLabel});

  final VoidCallback? onSkip;
  final String skipLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            AppConstants.appName,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: AppColors.royalBlueLight,
            ),
          ),
          Opacity(
            opacity: onSkip == null ? 0 : 1,
            child: _GlassPill(
              onTap: onSkip,
              child: Text(
                skipLabel.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: AppColors.glassBackground,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GlassIconBadge(icon: slide.icon, accentColor: slide.accentColor),
          const SizedBox(height: 32),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.2,
              color: slide.accentColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            slide.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconBadge extends StatelessWidget {
  const _GlassIconBadge({required this.icon, required this.accentColor});

  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor.withValues(alpha: 0.16),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.glassBorder),
                boxShadow: AppColors.glassShadow,
              ),
              child: Icon(icon, size: 52, color: accentColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.pageCount,
    required this.currentPage,
    required this.isLastPage,
    required this.ctaLabel,
    required this.secureLabel,
    required this.accentColor,
    required this.onPressed,
  });

  final int pageCount;
  final int currentPage;
  final bool isLastPage;
  final String ctaLabel;
  final String secureLabel;
  final Color accentColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          _DotIndicator(pageCount: pageCount, currentPage: currentPage, accentColor: accentColor),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.royalBlue.withValues(alpha: 0.35),
                    blurRadius: 24,
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.royalBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ctaLabel,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 24, height: 1, color: AppColors.mutedText),
              const SizedBox(width: 12),
              Text(
                secureLabel.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 24, height: 1, color: AppColors.mutedText),
            ],
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.pageCount,
    required this.currentPage,
    required this.accentColor,
  });

  final int pageCount;
  final int currentPage;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: AppConstants.animationFast,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? accentColor : AppColors.mutedText,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
