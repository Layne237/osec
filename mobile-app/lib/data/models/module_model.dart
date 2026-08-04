import 'package:equatable/equatable.dart';

import 'lesson_model.dart';

/// A chapter of a course, grouping ordered [LessonModel]s.
///
/// Un chapitre de cours, regroupant des [LessonModel] ordonnées.
class ModuleModel extends Equatable {
  const ModuleModel({
    required this.id,
    required this.title,
    required this.order,
    required this.lessons,
    this.isLocked = true,
  });

  /// Server-assigned identifier. / Identifiant côté serveur.
  final String id;

  /// Module title. / Titre du module.
  final String title;

  /// 1-based position within the course. / Position (base 1) dans le cours.
  final int order;

  /// Ordered lessons. / Leçons ordonnées.
  final List<LessonModel> lessons;

  /// Whether the whole module requires purchase. / Module soumis à l'achat.
  final bool isLocked;

  /// Number of lessons in this module. / Nombre de leçons du module.
  int get lessonsCount => lessons.length;

  /// Number of completed lessons. / Nombre de leçons terminées.
  int get completedCount => lessons.where((l) => l.isCompleted).length;

  /// Completion ratio in `0.0..1.0`. / Taux d'achèvement entre 0 et 1.
  double get progress =>
      lessons.isEmpty ? 0 : completedCount / lessons.length;

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    final rawLessons = json['lessons'];
    return ModuleModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      order: _asInt(json['order']),
      isLocked: json['isLocked'] == true || json['is_locked'] == true,
      lessons: rawLessons is List
          ? rawLessons
              .whereType<Map<String, dynamic>>()
              .map(LessonModel.fromJson)
              .toList()
          : const <LessonModel>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'order': order,
        'isLocked': isLocked,
        'lessons': lessons.map((l) => l.toJson()).toList(),
      };

  ModuleModel copyWith({
    String? id,
    String? title,
    int? order,
    List<LessonModel>? lessons,
    bool? isLocked,
  }) {
    return ModuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      lessons: lessons ?? this.lessons,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  List<Object?> get props => [id, title, order, lessons, isLocked];
}

/// Parses an `int` from the loosely-typed values a JSON API may return.
int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
