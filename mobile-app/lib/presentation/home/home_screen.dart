import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/themes/app_colors.dart';
import '../auth/providers/auth_provider.dart';
import '../shared/widgets/shimmer_box.dart';
import 'providers/home_provider.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/course_card.dart';
import 'widgets/search_bar.dart';
import 'widgets/welcome_video_card.dart';

/// The OSEC home experience: free welcome video, searchable course catalog and
/// root navigation.
///
/// L'accueil d'OSEC : vidéo de bienvenue gratuite, catalogue de cours filtrable
/// et navigation racine.
///
/// Owns a screen-scoped [HomeProvider] so catalog state is created when the
/// screen opens and disposed with it.
///
/// Détient un [HomeProvider] limité à l'écran : l'état du catalogue est créé à
/// l'ouverture et libéré à la fermeture.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => HomeProvider(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  HomeTab _currentTab = HomeTab.home;

  String get _localeCode => Localizations.localeOf(context).languageCode;

  void _showComingSoon(AppStrings strings) {
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

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(_localeCode);

    return Scaffold(
      backgroundColor: AppColors.obsidian,
      extendBody: true,
      body: _currentTab == HomeTab.home
          ? _CatalogTab(
              strings: strings,
              onComingSoon: () => _showComingSoon(strings),
            )
          : _ComingSoonTab(strings: strings, tab: _currentTab),
      bottomNavigationBar: BottomNavBar(
        currentTab: _currentTab,
        onTabSelected: (tab) => setState(() => _currentTab = tab),
        homeLabel: strings.navHome,
        myCoursesLabel: strings.navMyCourses,
        toolsLabel: strings.navTools,
        profileLabel: strings.navProfile,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Home tab / Onglet Accueil
// ---------------------------------------------------------------------------

class _CatalogTab extends StatelessWidget {
  const _CatalogTab({required this.strings, required this.onComingSoon});

  final AppStrings strings;
  final VoidCallback onComingSoon;

  /// Columns scale with available width so the grid works on phones, tablets
  /// and the web. / Le nombre de colonnes s'adapte à la largeur disponible.
  int _columnsFor(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();
    final userName = context.select<AuthProvider, String?>(
      (auth) => auth.user?.fullName,
    );
    final columns = _columnsFor(MediaQuery.sizeOf(context).width);

    return RefreshIndicator(
      onRefresh: home.refresh,
      color: AppColors.royalBlue,
      backgroundColor: AppColors.containerSurface,
      child: CustomScrollView(
        // Always scrollable so pull-to-refresh works even on short content.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                _WelcomeHeader(strings: strings, userName: userName),
                const SizedBox(height: 20),
                CourseSearchBar(
                  hintText: strings.homeSearchHint,
                  clearTooltip: strings.homeSearchClear,
                  initialValue: home.searchQuery,
                  onChanged: home.search,
                ),
                const SizedBox(height: 16),
                _FilterChips(strings: strings),
                const SizedBox(height: 24),
              ]),
            ),
          ),
          // Welcome video — hidden while a search/filter is narrowing the view.
          if (!home.isFiltering)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  _SectionTitle(title: strings.homeWelcomeVideoSection),
                  const SizedBox(height: 12),
                  if (home.isLoading)
                    const _WelcomeVideoSkeleton()
                  else if (home.welcomeVideo != null)
                    WelcomeVideoCard(
                      title: home.welcomeVideo!.title,
                      description: home.welcomeVideo!.description,
                      thumbnailUrl: home.welcomeVideo!.thumbnailUrl,
                      duration: home.welcomeVideo!.duration,
                      freeBadgeLabel: strings.badgeFree,
                      onTap: onComingSoon,
                    ),
                ]),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            sliver: SliverToBoxAdapter(
              child: _SectionTitle(title: strings.homeCoursesSection),
            ),
          ),
          _buildCatalogSliver(home, columns),
          // Breathing room above the floating bottom navigation bar.
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildCatalogSliver(HomeProvider home, int columns) {
    const padding = EdgeInsets.symmetric(horizontal: 20);
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.70,
    );

    if (home.hasError) {
      return SliverPadding(
        padding: padding,
        sliver: SliverToBoxAdapter(
          child: _ErrorState(strings: strings, onRetry: home.refresh),
        ),
      );
    }

    if (home.isLoading) {
      return SliverPadding(
        padding: padding,
        sliver: SliverGrid.builder(
          gridDelegate: gridDelegate,
          itemCount: columns * 2,
          itemBuilder: (_, __) => const _CourseCardSkeleton(),
        ),
      );
    }

    if (home.isEmptyResult) {
      return SliverPadding(
        padding: padding,
        sliver: SliverToBoxAdapter(child: _EmptyState(strings: strings)),
      );
    }

    final courses = home.courses;
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid.builder(
        gridDelegate: gridDelegate,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            course: course,
            thumbnailSeed: index,
            freeBadgeLabel: strings.badgeFree,
            premiumBadgeLabel: strings.badgePremium,
            lessonsCountTemplate: strings.courseLessonsCount,
            progressTemplate: strings.courseProgressComplete,
            onTap: onComingSoon,
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header, filters & section titles
// ---------------------------------------------------------------------------

/// Greeting, learner name and avatar. / Salutation, nom et avatar.
class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.strings, required this.userName});

  final AppStrings strings;
  final String? userName;

  /// Builds up to two initials from the user's name. / Jusqu'à deux initiales.
  String get _initials {
    final name = userName?.trim() ?? '';
    if (name.isEmpty) return '';
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = userName?.trim() ?? '';
    final greeting = name.isEmpty
        ? strings.homeGreeting
        : '${strings.homeGreeting}, $name';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                strings.homeSubtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _Avatar(initials: _initials),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.royalBlue, AppColors.royalBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.glassBorder),
      ),
      alignment: Alignment.center,
      child: initials.isEmpty
          ? const Icon(Icons.person, color: Colors.white, size: 24)
          : Text(
              initials,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
    );
  }
}

/// Horizontal catalog filters. / Filtres horizontaux du catalogue.
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();
    final entries = <(CourseFilter, String)>[
      (CourseFilter.all, strings.filterAll),
      (CourseFilter.free, strings.filterFree),
      (CourseFilter.premium, strings.filterPremium),
      (CourseFilter.inProgress, strings.filterInProgress),
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (filter, label) = entries[index];
          final isActive = home.filter == filter;
          return GestureDetector(
            onTap: () => home.setFilter(filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.royalBlue.withValues(alpha: 0.18)
                    : AppColors.containerSurface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive ? AppColors.royalBlue : AppColors.glassBorder,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? AppColors.royalBlueLight
                      : AppColors.secondaryText,
                ),
              ),
            ),
          );
        },
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
// Loading / empty / error states
// ---------------------------------------------------------------------------

class _WelcomeVideoSkeleton extends StatelessWidget {
  const _WelcomeVideoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ShimmerBox(borderRadius: BorderRadius.circular(20)),
        ),
        const SizedBox(height: 12),
        ShimmerBox(height: 16, borderRadius: BorderRadius.circular(6)),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: ShimmerBox(height: 12, borderRadius: BorderRadius.circular(6)),
        ),
      ],
    );
  }
}

class _CourseCardSkeleton extends StatelessWidget {
  const _CourseCardSkeleton();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(
            aspectRatio: 16 / 9,
            child: ShimmerBox(borderRadius: BorderRadius.zero),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 12, borderRadius: BorderRadius.circular(6)),
                  const SizedBox(height: 8),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: ShimmerBox(
                      height: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const Spacer(),
                  ShimmerBox(height: 8, borderRadius: BorderRadius.circular(4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return _StateMessage(
      icon: Icons.search_off_rounded,
      iconColor: AppColors.secondaryText,
      title: strings.homeEmptyTitle,
      subtitle: strings.homeEmptySubtitle,
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.strings, required this.onRetry});

  final AppStrings strings;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return _StateMessage(
      icon: Icons.cloud_off_rounded,
      iconColor: AppColors.error,
      title: strings.homeErrorTitle,
      action: OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh, size: 18),
        label: Text(strings.homeRetry),
      ),
    );
  }
}

/// Shared layout for empty / error / coming-soon panels.
///
/// Mise en page partagée des panneaux vide / erreur / à venir.
class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                height: 1.5,
                color: AppColors.secondaryText,
              ),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 24),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Placeholder for the not-yet-built root tabs.
///
/// Espace réservé pour les onglets racines pas encore construits.
class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab({required this.strings, required this.tab});

  final AppStrings strings;
  final HomeTab tab;

  String _titleFor(HomeTab tab) {
    switch (tab) {
      case HomeTab.myCourses:
        return strings.navMyCourses;
      case HomeTab.tools:
        return strings.navTools;
      case HomeTab.profile:
        return strings.navProfile;
      case HomeTab.home:
        return strings.navHome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: _StateMessage(
          icon: Icons.construction_outlined,
          iconColor: AppColors.gold,
          title: _titleFor(tab),
          subtitle: strings.homeComingSoonSubtitle,
        ),
      ),
    );
  }
}
