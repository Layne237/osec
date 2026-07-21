import 'package:flutter/foundation.dart';

import '../../../data/mock_data/mock_courses.dart';
import '../../../data/models/course_model.dart';

/// Catalog filters offered above the course grid.
///
/// Filtres du catalogue proposés au-dessus de la grille de cours.
enum CourseFilter { all, free, premium, inProgress }

/// Loading lifecycle for the home screen. / Cycle de chargement de l'accueil.
enum HomeStatus { initial, loading, ready, error }

/// Owns the home screen's data: the course catalog, the free welcome video,
/// the active search query and filter, and learner progress.
///
/// Détient les données de l'écran d'accueil : catalogue, vidéo de bienvenue,
/// recherche active, filtre et progression de l'apprenant.
///
/// Currently backed by [MockCourses]; swapping in a real repository only
/// requires changing [_fetchCourses].
///
/// Actuellement alimenté par [MockCourses] ; le passage à une vraie API ne
/// nécessite que de modifier [_fetchCourses].
class HomeProvider extends ChangeNotifier {
  HomeProvider({bool autoLoad = true}) {
    if (autoLoad) {
      // Deferred so listeners attached during the first build still receive the
      // ready notification. / Différé pour que les écouteurs reçoivent l'état.
      Future.microtask(load);
    }
  }

  /// Simulated network latency for the mock catalog. / Latence simulée.
  static const Duration _mockLatency = Duration(milliseconds: 1200);

  HomeStatus _status = HomeStatus.initial;
  List<CourseModel> _courses = const [];
  CourseModel? _welcomeVideo;
  String _searchQuery = '';
  CourseFilter _filter = CourseFilter.all;
  Object? _error;

  // --- Reads / Lectures ---------------------------------------------------

  HomeStatus get status => _status;

  /// `true` while the catalog is being fetched. / Chargement en cours.
  bool get isLoading =>
      _status == HomeStatus.loading || _status == HomeStatus.initial;

  /// `true` when loading failed. / Le chargement a échoué.
  bool get hasError => _status == HomeStatus.error;

  /// The underlying error, for logging. / L'erreur sous-jacente, pour les logs.
  Object? get error => _error;

  /// The free welcome video, once loaded. / La vidéo de bienvenue gratuite.
  CourseModel? get welcomeVideo => _welcomeVideo;

  /// The unfiltered catalog. / Le catalogue non filtré.
  List<CourseModel> get allCourses => List.unmodifiable(_courses);

  /// The active search query. / La recherche active.
  String get searchQuery => _searchQuery;

  /// The active filter. / Le filtre actif.
  CourseFilter get filter => _filter;

  /// `true` when a search or non-default filter is applied.
  /// `true` si une recherche ou un filtre non par défaut est appliqué.
  bool get isFiltering =>
      _searchQuery.trim().isNotEmpty || _filter != CourseFilter.all;

  /// Courses matching the active search query and filter.
  ///
  /// Cours correspondant à la recherche et au filtre actifs.
  List<CourseModel> get courses {
    final query = _searchQuery.trim().toLowerCase();
    return _courses.where((course) {
      final matchesQuery = query.isEmpty ||
          course.title.toLowerCase().contains(query) ||
          course.description.toLowerCase().contains(query);
      if (!matchesQuery) return false;

      switch (_filter) {
        case CourseFilter.all:
          return true;
        case CourseFilter.free:
          return course.isFree;
        case CourseFilter.premium:
          return !course.isFree;
        case CourseFilter.inProgress:
          return course.isInProgress;
      }
    }).toList();
  }

  /// Courses the learner owns. / Cours possédés par l'apprenant.
  List<CourseModel> get purchasedCourses =>
      _courses.where((c) => c.isPurchased).toList();

  /// `true` when the filtered result set is empty but the catalog is not.
  /// `true` lorsque le résultat filtré est vide alors que le catalogue ne l'est pas.
  bool get isEmptyResult =>
      _status == HomeStatus.ready && courses.isEmpty;

  // --- Mutations / Mutations ----------------------------------------------

  /// Loads the catalog and welcome video. / Charge le catalogue et la vidéo.
  Future<void> load() async {
    _status = HomeStatus.loading;
    _error = null;
    notifyListeners();
    try {
      final result = await _fetchCourses();
      _courses = result;
      _welcomeVideo = MockCourses.welcomeVideo;
      _status = HomeStatus.ready;
    } catch (e, stack) {
      debugPrint('Failed to load home catalog: $e\n$stack');
      _error = e;
      _status = HomeStatus.error;
    }
    notifyListeners();
  }

  /// Pull-to-refresh entry point. / Point d'entrée du « tirer pour rafraîchir ».
  Future<void> refresh() => load();

  /// Applies a search query (case-insensitive, title + description).
  ///
  /// Applique une recherche (insensible à la casse, titre + description).
  void search(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  /// Clears the active search. / Efface la recherche active.
  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    notifyListeners();
  }

  /// Applies a catalog filter. / Applique un filtre du catalogue.
  void setFilter(CourseFilter filter) {
    if (_filter == filter) return;
    _filter = filter;
    notifyListeners();
  }

  /// Updates local progress for [courseId] (called by the player later).
  ///
  /// Met à jour la progression locale d'un cours (appelé plus tard par le lecteur).
  void updateProgress(String courseId, double progress) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index == -1) return;
    final clamped = progress.clamp(0.0, 1.0);
    if (_courses[index].progress == clamped) return;
    final updated = List<CourseModel>.from(_courses);
    updated[index] = updated[index].copyWith(progress: clamped);
    _courses = updated;
    notifyListeners();
  }

  // --- Data source / Source de données ------------------------------------

  /// Fetches the catalog. Replace with a repository call once the courses API
  /// is available. / Remplacer par un appel au dépôt une fois l'API disponible.
  Future<List<CourseModel>> _fetchCourses() async {
    await Future<void>.delayed(_mockLatency);
    return MockCourses.catalog;
  }
}
