import 'package:equatable/equatable.dart';

import 'module_model.dart';

/// A purchasable training course in the OSEC catalog.
///
/// Un cours de formation achetable dans le catalogue OSEC.
///
/// Also used to describe the free welcome video (a single-lesson, [isFree]
/// course) so the catalog and the hero card share one shape.
class CourseModel extends Equatable {
  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.isFree,
    required this.price,
    required this.currency,
    required this.duration,
    required this.lessonsCount,
    required this.rating,
    required this.reviewsCount,
    required this.language,
    this.modules = const [],
    this.progress = 0,
    this.isPurchased = false,
  });

  /// Server-assigned identifier. / Identifiant côté serveur.
  final String id;

  /// Course title. / Titre du cours.
  final String title;

  /// Marketing description. / Description commerciale.
  final String description;

  /// Cover image URL (16:9). / URL de l'image de couverture (16:9).
  final String thumbnailUrl;

  /// Preview / welcome video URL. / URL de la vidéo de présentation.
  final String videoUrl;

  /// Whether the course is free to watch. / Cours gratuit.
  final bool isFree;

  /// Price in [currency] minor-unit-free decimal. / Prix dans [currency].
  final double price;

  /// ISO-4217-ish currency code, e.g. `XAF`. / Code devise, ex. `XAF`.
  final String currency;

  /// Human-readable total runtime, e.g. `6h 20m`. / Durée totale lisible.
  final String duration;

  /// Total number of lessons. / Nombre total de leçons.
  final int lessonsCount;

  /// Ordered modules. / Modules ordonnés.
  final List<ModuleModel> modules;

  /// Average rating out of 5. / Note moyenne sur 5.
  final double rating;

  /// Number of published reviews. / Nombre d'avis publiés.
  final int reviewsCount;

  /// Learner progress in `0.0..1.0`. / Progression entre 0 et 1.
  final double progress;

  /// Whether the current user owns this course. / Cours acheté par l'utilisateur.
  final bool isPurchased;

  /// Content language code (`fr` / `en`). / Code de langue du contenu.
  final String language;

  /// Whether content is gated for the current user.
  /// A course is accessible when it is free or purchased.
  ///
  /// Contenu verrouillé : ni gratuit ni acheté.
  bool get isLocked => !isFree && !isPurchased;

  /// Progress as a whole percentage `0..100`. / Progression en pourcentage.
  int get progressPercent => (progress.clamp(0.0, 1.0) * 100).round();

  /// Whether the learner has started but not finished. / Cours commencé.
  bool get isInProgress => isPurchased && progress > 0 && progress < 1;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final rawModules = json['modules'];
    return CourseModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      thumbnailUrl:
          (json['thumbnailUrl'] ?? json['thumbnail_url'] ?? '').toString(),
      videoUrl: (json['videoUrl'] ?? json['video_url'] ?? '').toString(),
      isFree: json['isFree'] == true || json['is_free'] == true,
      price: _asDouble(json['price']),
      currency: (json['currency'] ?? 'XAF').toString(),
      duration: (json['duration'] ?? '').toString(),
      lessonsCount: _asInt(json['lessonsCount'] ?? json['lessons_count']),
      rating: _asDouble(json['rating']),
      reviewsCount: _asInt(json['reviewsCount'] ?? json['reviews_count']),
      progress: _asDouble(json['progress']),
      isPurchased: json['isPurchased'] == true || json['is_purchased'] == true,
      language: (json['language'] ?? 'fr').toString(),
      modules: rawModules is List
          ? rawModules
              .whereType<Map<String, dynamic>>()
              .map(ModuleModel.fromJson)
              .toList()
          : const <ModuleModel>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'thumbnailUrl': thumbnailUrl,
        'videoUrl': videoUrl,
        'isFree': isFree,
        'price': price,
        'currency': currency,
        'duration': duration,
        'lessonsCount': lessonsCount,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'progress': progress,
        'isPurchased': isPurchased,
        'language': language,
        'modules': modules.map((m) => m.toJson()).toList(),
      };

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? videoUrl,
    bool? isFree,
    double? price,
    String? currency,
    String? duration,
    int? lessonsCount,
    List<ModuleModel>? modules,
    double? rating,
    int? reviewsCount,
    double? progress,
    bool? isPurchased,
    String? language,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      isFree: isFree ?? this.isFree,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      duration: duration ?? this.duration,
      lessonsCount: lessonsCount ?? this.lessonsCount,
      modules: modules ?? this.modules,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      progress: progress ?? this.progress,
      isPurchased: isPurchased ?? this.isPurchased,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnailUrl,
        videoUrl,
        isFree,
        price,
        currency,
        duration,
        lessonsCount,
        modules,
        rating,
        reviewsCount,
        progress,
        isPurchased,
        language,
      ];
}

/// Parses an `int` from the loosely-typed values a JSON API may return.
int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

/// Parses a `double` from the loosely-typed values a JSON API may return.
double _asDouble(Object? value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
