import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock_data/mock_courses.dart';
import '../models/course_model.dart';
import '../models/module_model.dart';

/// Reads course content and owns the learner's purchase & progress state.
///
/// Lit le contenu des cours et détient l'état d'achat et de progression.
///
/// Content currently comes from [MockCourses]; purchase status and progress are
/// persisted with `shared_preferences` so unlocked courses survive restarts and
/// are available offline. Swapping in a real API only touches [_fetchCatalog].
///
/// Le contenu provient de [MockCourses] ; l'état d'achat et la progression sont
/// persistés via `shared_preferences` (disponibles hors ligne). Le passage à
/// une vraie API ne modifie que [_fetchCatalog].
class CourseRepository {
  CourseRepository({SharedPreferences? prefs}) : _injectedPrefs = prefs;

  final SharedPreferences? _injectedPrefs;

  static const String _kPurchasedKey = 'osec_purchased_course_ids';
  static const String _kProgressKey = 'osec_course_progress';

  /// Simulated network latency for the mock catalog. / Latence simulée.
  static const Duration _latency = Duration(milliseconds: 900);

  Future<SharedPreferences> get _prefs async =>
      _injectedPrefs ?? await SharedPreferences.getInstance();

  // --- Reads / Lectures ---------------------------------------------------

  /// The free welcome video, with any persisted progress applied.
  ///
  /// La vidéo de bienvenue gratuite, avec la progression persistée.
  Future<CourseModel> getWelcomeVideo() async {
    final progress = await _readProgress();
    return _applyState(MockCourses.welcomeVideo, await _readPurchased(), progress);
  }

  /// The full catalog, merged with local purchase & progress state.
  ///
  /// Le catalogue complet, fusionné avec l'état local d'achat et de progression.
  Future<List<CourseModel>> getCourses() async {
    await Future<void>.delayed(_latency);
    final purchased = await _readPurchased();
    final progress = await _readProgress();
    return _fetchCatalog()
        .map((course) => _applyState(course, purchased, progress))
        .toList();
  }

  /// A single course by [courseId], or `null` if unknown.
  ///
  /// Un cours par [courseId], ou `null` si inconnu.
  Future<CourseModel?> getCourse(String courseId) async {
    await Future<void>.delayed(_latency);
    final purchased = await _readPurchased();
    final progress = await _readProgress();
    for (final course in _fetchCatalog()) {
      if (course.id == courseId) {
        return _applyState(course, purchased, progress);
      }
    }
    if (MockCourses.welcomeVideo.id == courseId) {
      return _applyState(MockCourses.welcomeVideo, purchased, progress);
    }
    return null;
  }

  /// Whether [courseId] is owned (free courses always count as owned).
  ///
  /// Indique si [courseId] est possédé (les cours gratuits le sont toujours).
  Future<bool> isPurchased(String courseId) async {
    final base = _baseCourse(courseId);
    if (base != null && (base.isFree || base.isPurchased)) return true;
    return (await _readPurchased()).contains(courseId);
  }

  /// Learner progress for [courseId] in `0.0..1.0`. / Progression du cours.
  Future<double> getProgress(String courseId) async {
    final stored = (await _readProgress())[courseId];
    if (stored != null) return stored;
    return _baseCourse(courseId)?.progress ?? 0;
  }

  // --- Mutations / Mutations ----------------------------------------------

  /// Marks [courseId] as owned. Called after a successful payment.
  ///
  /// Marque [courseId] comme possédé. Appelé après un paiement réussi.
  Future<void> unlockCourse(String courseId) async {
    final prefs = await _prefs;
    final ids = (await _readPurchased())..add(courseId);
    await prefs.setStringList(_kPurchasedKey, ids.toList());
  }

  /// Persists learner [progress] (clamped) for [courseId].
  ///
  /// Persiste la progression (bornée) pour [courseId].
  Future<void> setProgress(String courseId, double progress) async {
    final prefs = await _prefs;
    final map = await _readProgress()
      ..[courseId] = progress.clamp(0.0, 1.0);
    await prefs.setString(_kProgressKey, jsonEncode(map));
  }

  // --- Internals / Interne ------------------------------------------------

  /// The raw content source. Replace with an API call when available.
  List<CourseModel> _fetchCatalog() => MockCourses.catalog;

  CourseModel? _baseCourse(String courseId) {
    for (final course in _fetchCatalog()) {
      if (course.id == courseId) return course;
    }
    if (MockCourses.welcomeVideo.id == courseId) return MockCourses.welcomeVideo;
    return null;
  }

  /// Applies purchase and progress state to [base], unlocking every module and
  /// lesson once the course is owned.
  ///
  /// Applique l'état d'achat et de progression à [base], déverrouillant tous les
  /// modules et leçons une fois le cours possédé.
  CourseModel _applyState(
    CourseModel base,
    Set<String> purchasedIds,
    Map<String, double> progressById,
  ) {
    final isPurchased =
        base.isFree || base.isPurchased || purchasedIds.contains(base.id);
    final progress = progressById[base.id] ?? base.progress;
    final modules = isPurchased
        ? base.modules.map(_unlockModule).toList()
        : base.modules;
    return base.copyWith(
      isPurchased: isPurchased,
      progress: progress,
      modules: modules,
    );
  }

  ModuleModel _unlockModule(ModuleModel module) {
    return module.copyWith(
      isLocked: false,
      lessons: module.lessons.map((l) => l.copyWith(isLocked: false)).toList(),
    );
  }

  Future<Set<String>> _readPurchased() async {
    final prefs = await _prefs;
    return (prefs.getStringList(_kPurchasedKey) ?? const []).toSet();
  }

  Future<Map<String, double>> _readProgress() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_kProgressKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      );
    } catch (e) {
      debugPrint('Failed to read course progress: $e');
      return {};
    }
  }
}
