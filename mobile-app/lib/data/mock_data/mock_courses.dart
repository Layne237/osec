import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../models/module_model.dart';

/// Static catalog used until the OSEC courses API is live.
///
/// Catalogue statique utilisé en attendant l'API des cours d'OSEC.
///
/// Mirrors the launch scope from the Terms of Reference: one English flagship
/// course, one French flagship course, plus a free welcome video that anyone
/// can watch without purchasing.
///
/// Reflète le périmètre de lancement du cahier des charges : un cours phare en
/// anglais, un en français, et une vidéo de bienvenue gratuite.
class MockCourses {
  MockCourses._();

  /// Thumbnails are remote placeholders; every card falls back to a branded
  /// gradient when the image cannot load (offline, CORS, etc.).
  ///
  /// Les vignettes sont distantes ; un dégradé de marque prend le relais si
  /// l'image ne peut pas être chargée.
  static const String _thumbEcommercePro =
      'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=800&q=70';
  static const String _thumbMaitrise =
      'https://images.unsplash.com/photo-1522204523234-8729aa6e3d5f?auto=format&fit=crop&w=800&q=70';
  static const String _thumbWelcome =
      'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=800&q=70';

  // Sample media used for playback smoke-tests. / Médias d'exemple pour tests.
  static const String _v1 =
      'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';
  static const String _v2 =
      'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4';
  static const String _v3 =
      'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4';
  static const String _v4 =
      'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4';
  static const String _v5 =
      'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4';

  /// A short, always-free introduction shown at the top of the home screen.
  ///
  /// Courte introduction toujours gratuite, en haut de l'écran d'accueil.
  static const CourseModel welcomeVideo = CourseModel(
    id: 'welcome-video',
    title: 'Welcome to OSEC — Start Your E-Commerce Journey',
    description:
        'Meet your instructors and discover how OSEC turns you from beginner '
        'to profitable online seller in 8 weeks. Watch free, no account needed.',
    thumbnailUrl: _thumbWelcome,
    videoUrl: _v1,
    isFree: true,
    price: 0,
    currency: 'XAF',
    duration: '4:32',
    lessonsCount: 1,
    rating: 5.0,
    reviewsCount: 128,
    isPurchased: true,
    language: 'en',
  );

  /// The English flagship course. / Le cours phare en anglais.
  ///
  /// Marked as purchased with partial progress so the home grid demonstrates
  /// the Royal Blue progress indicator.
  static const CourseModel ecommercePro = CourseModel(
    id: 'course-ecommerce-pro',
    title: 'E-Commerce Pro',
    description:
        'A complete, practical path to launching and scaling a profitable '
        'online store — from product research and supplier negotiation to paid '
        'ads, conversion optimization and customer retention.',
    thumbnailUrl: _thumbEcommercePro,
    videoUrl: _v2,
    isFree: false,
    price: 45000,
    currency: 'XAF',
    duration: '6h 20m',
    lessonsCount: 9,
    rating: 4.8,
    reviewsCount: 216,
    isPurchased: true,
    progress: 0.35,
    language: 'en',
    modules: [
      ModuleModel(
        id: 'ep-m1',
        title: 'Foundations of Online Selling',
        order: 1,
        isLocked: false,
        lessons: [
          LessonModel(
            id: 'ep-m1-l1',
            title: 'The E-Commerce Landscape in Africa',
            videoUrl: _v3,
            duration: '14:05',
            order: 1,
            isLocked: false,
            isCompleted: true,
          ),
          LessonModel(
            id: 'ep-m1-l2',
            title: 'Choosing a Profitable Niche',
            videoUrl: _v4,
            duration: '18:42',
            order: 2,
            isLocked: false,
            isCompleted: true,
          ),
          LessonModel(
            id: 'ep-m1-l3',
            title: 'Validating Demand Before You Invest',
            videoUrl: _v5,
            duration: '21:16',
            order: 3,
            isLocked: false,
            isCompleted: true,
          ),
        ],
      ),
      ModuleModel(
        id: 'ep-m2',
        title: 'Sourcing & Supplier Negotiation',
        order: 2,
        isLocked: false,
        lessons: [
          LessonModel(
            id: 'ep-m2-l1',
            title: 'Finding Reliable Suppliers',
            videoUrl: _v1,
            duration: '16:30',
            order: 1,
            isLocked: false,
          ),
          LessonModel(
            id: 'ep-m2-l2',
            title: 'Negotiating Margins That Survive Ads',
            videoUrl: _v2,
            duration: '23:11',
            order: 2,
            isLocked: false,
          ),
          LessonModel(
            id: 'ep-m2-l3',
            title: 'Logistics, Customs & Last-Mile Delivery',
            videoUrl: _v3,
            duration: '19:48',
            order: 3,
            isLocked: false,
          ),
        ],
      ),
      ModuleModel(
        id: 'ep-m3',
        title: 'Traffic, Conversion & Retention',
        order: 3,
        lessons: [
          LessonModel(
            id: 'ep-m3-l1',
            title: 'Meta & TikTok Ads That Actually Convert',
            videoUrl: _v4,
            duration: '28:54',
            order: 1,
          ),
          LessonModel(
            id: 'ep-m3-l2',
            title: 'Landing Pages & Checkout Optimization',
            videoUrl: _v5,
            duration: '25:02',
            order: 2,
          ),
          LessonModel(
            id: 'ep-m3-l3',
            title: 'Retention, Upsells & Lifetime Value',
            videoUrl: _v1,
            duration: '22:37',
            order: 3,
          ),
        ],
      ),
    ],
  );

  /// The French flagship course. / Le cours phare en français.
  ///
  /// Left unpurchased to demonstrate the Premium badge and gold padlock.
  static const CourseModel maitriseECommerce = CourseModel(
    id: 'course-maitrise-ecommerce',
    title: 'La Maîtrise du E-Commerce',
    description:
        'Un parcours complet et pratique pour lancer et développer une '
        'boutique en ligne rentable : recherche de produits, négociation '
        'fournisseurs, publicité payante, conversion et fidélisation client.',
    thumbnailUrl: _thumbMaitrise,
    videoUrl: _v4,
    isFree: false,
    price: 45000,
    currency: 'XAF',
    duration: '7h 05m',
    lessonsCount: 9,
    rating: 4.9,
    reviewsCount: 341,
    language: 'fr',
    modules: [
      ModuleModel(
        id: 'me-m1',
        title: 'Les fondations de la vente en ligne',
        order: 1,
        lessons: [
          LessonModel(
            id: 'me-m1-l1',
            title: "Le marché de l'e-commerce en Afrique",
            videoUrl: _v3,
            duration: '15:22',
            order: 1,
          ),
          LessonModel(
            id: 'me-m1-l2',
            title: 'Choisir une niche rentable',
            videoUrl: _v2,
            duration: '19:04',
            order: 2,
          ),
          LessonModel(
            id: 'me-m1-l3',
            title: "Valider la demande avant d'investir",
            videoUrl: _v1,
            duration: '20:47',
            order: 3,
          ),
        ],
      ),
      ModuleModel(
        id: 'me-m2',
        title: 'Approvisionnement et négociation',
        order: 2,
        lessons: [
          LessonModel(
            id: 'me-m2-l1',
            title: 'Trouver des fournisseurs fiables',
            videoUrl: _v5,
            duration: '17:12',
            order: 1,
          ),
          LessonModel(
            id: 'me-m2-l2',
            title: 'Négocier des marges qui résistent à la publicité',
            videoUrl: _v4,
            duration: '24:35',
            order: 2,
          ),
          LessonModel(
            id: 'me-m2-l3',
            title: 'Logistique, douane et livraison du dernier kilomètre',
            videoUrl: _v3,
            duration: '18:59',
            order: 3,
          ),
        ],
      ),
      ModuleModel(
        id: 'me-m3',
        title: 'Trafic, conversion et fidélisation',
        order: 3,
        lessons: [
          LessonModel(
            id: 'me-m3-l1',
            title: 'Publicités Meta et TikTok qui convertissent',
            videoUrl: _v2,
            duration: '29:18',
            order: 1,
          ),
          LessonModel(
            id: 'me-m3-l2',
            title: 'Pages de vente et optimisation du panier',
            videoUrl: _v1,
            duration: '26:41',
            order: 2,
          ),
          LessonModel(
            id: 'me-m3-l3',
            title: 'Fidélisation, ventes additionnelles et valeur client',
            videoUrl: _v5,
            duration: '23:26',
            order: 3,
          ),
        ],
      ),
    ],
  );

  /// The full launch catalog. / Le catalogue complet de lancement.
  static const List<CourseModel> catalog = [ecommercePro, maitriseECommerce];
}
