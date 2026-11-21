/// Minimal, clean UI strings
abstract final class AppStrings {
  static const String appName = 'Imposter';
  static const String splashTitle = 'IMPOSTER';
  static const String splashSubtitle = 'مين برّا السالفة؟';

  // Player Setup Screen
  static const String howManyPlayers = 'كم لاعب؟';
  static const String playerSetupSubtitle = 'حدد عدد اللاعبين';
  static const String continueButton = 'التالي';
  static const String playersLabel = 'لاعبين';
  static const String minPlayersWarning = 'الحد الأدنى 3 لاعبين';

  // Imposter Setup Screen
  static const String howManyImposters = 'كم محتال؟';
  static const String impostersLabel = 'محتالين';
  static const String imposterSetupSubtitle = 'الحد الأقصى {max} من {count} لاعبين';

  // Card Reveal Screen
  static const String cardRevealPlayerLabel = 'لاعب {n}';
  static const String cardRevealTapHint = 'المس الكرت';
  static const String cardRevealReTapHint = 'نسيت؟ المس لتتأكد';
  static const String cardRevealHidingIn = 'يختفي خلال {s} ثواني';
  static const String cardRevealHiddenNotice = 'مرر للاعب التالي';
  static const String cardRevealNextPlayer = 'اللاعب التالي ({n})';
  static const String cardRevealStartGame = 'ابدأ اللعبة';

  // Roles & Secret Word
  static const String roleImposter = 'محتال';
  static const String roleImposterSub = 'برّا السالفة';
  static const String roleImposterDescription =
      'أنت ما بتعرف الكلمة. اسمع منيح وحاول ما تنكشف.';
  static const String roleInnocent = 'بريء';
  static const String roleInnocentSub = 'جوا السالفة';
  static const String secretWordLabel = 'الكلمة:';
  static const String roleInnocentDescription =
      'أنت بتعرف الكلمة. اسأل بذكاء واعرف مين المحتال.';

  // Game Screen
  static const String gameTitle = 'بدأت الجولة';
  static const String gameSubtitle = 'اسألوا بعض بالدور بدون ما تفضحوا الكلمة.';
  static const String revealResults = 'كشف النتيجة';
  static const String hideResults = 'إخفاء النتيجة';
  static const String nextRound = 'جولة جديدة';
  static const String changeSettings = 'تعديل اللاعبين';
  static const String theSecretWordWas = 'الكلمة كانت:';
  static const String theImpostersWere = 'المحتال:';

  // Home / Legacy Counter Screen
  static const String homeTitle = 'Home';
  static const String counterDescription = 'You have pushed the button this many times:';
  static const String incrementTooltip = 'Increment';

  // Generic
  static const String genericError = 'حدث خطأ، حاول مجدداً.';
  static const String networkError = 'لا يوجد اتصال بالإنترنت.';
}
