import 'package:equatable/equatable.dart';

/// A single video lesson inside a [ModuleModel].
///
/// Une leçon vidéo unique au sein d'un [ModuleModel].
class LessonModel extends Equatable {
  const LessonModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.duration,
    required this.order,
    this.isLocked = true,
    this.isCompleted = false,
  });

  /// Server-assigned identifier. / Identifiant côté serveur.
  final String id;

  /// Lesson title. / Titre de la leçon.
  final String title;

  /// Playable (usually signed) video URL. / URL vidéo lisible.
  final String videoUrl;

  /// Human-readable runtime, e.g. `12:30`. / Durée lisible, ex. `12:30`.
  final String duration;

  /// 1-based position within its module. / Position (base 1) dans le module.
  final int order;

  /// Whether playback requires purchase. / Lecture soumise à l'achat.
  final bool isLocked;

  /// Whether the learner finished this lesson. / Leçon terminée.
  final bool isCompleted;

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      videoUrl: (json['videoUrl'] ?? json['video_url'] ?? '').toString(),
      duration: (json['duration'] ?? '').toString(),
      order: _asInt(json['order']),
      isLocked: json['isLocked'] == true || json['is_locked'] == true,
      isCompleted: json['isCompleted'] == true || json['is_completed'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'videoUrl': videoUrl,
        'duration': duration,
        'order': order,
        'isLocked': isLocked,
        'isCompleted': isCompleted,
      };

  LessonModel copyWith({
    String? id,
    String? title,
    String? videoUrl,
    String? duration,
    int? order,
    bool? isLocked,
    bool? isCompleted,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      isLocked: isLocked ?? this.isLocked,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, videoUrl, duration, order, isLocked, isCompleted];
}

/// Parses an `int` from the loosely-typed values a JSON API may return.
int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
