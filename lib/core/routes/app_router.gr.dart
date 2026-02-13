// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i48;
import 'package:flutter/material.dart' as _i49;
import 'package:resummy_app/features/auth/presentation/screens/auth_screen.dart'
    as _i1;
import 'package:resummy_app/features/auth/presentation/screens/language_selection_screen.dart'
    as _i39;
import 'package:resummy_app/features/auth/presentation/screens/onboarding/onboarding_confirmation.dart'
    as _i41;
import 'package:resummy_app/features/auth/presentation/screens/onboarding/onboarding_step1_name.dart'
    as _i42;
import 'package:resummy_app/features/auth/presentation/screens/onboarding/onboarding_step2_status.dart'
    as _i43;
import 'package:resummy_app/features/auth/presentation/screens/onboarding/onboarding_step3_role.dart'
    as _i44;
import 'package:resummy_app/features/auth/presentation/screens/onboarding/onboarding_step4_goal.dart'
    as _i45;
import 'package:resummy_app/features/auth/presentation/screens/splash_screen.dart'
    as _i47;
import 'package:resummy_app/features/cv_tools/presentation/screens/analyzer/cv_analyzer_input_screen.dart'
    as _i2;
import 'package:resummy_app/features/cv_tools/presentation/screens/analyzer/cv_analyzer_result_screen.dart'
    as _i3;
import 'package:resummy_app/features/cv_tools/presentation/screens/analyzer/cv_analyzer_upload_screen.dart'
    as _i4;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_preview_screen.dart'
    as _i5;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_step1_personal.dart'
    as _i6;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_step2_education.dart'
    as _i7;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_step3_experience.dart'
    as _i8;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_step4_certification.dart'
    as _i9;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_step5_skills.dart'
    as _i10;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_step6_summary.dart'
    as _i11;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_step7_additional.dart'
    as _i12;
import 'package:resummy_app/features/cv_tools/presentation/screens/builder/cv_builder_welcome_screen.dart'
    as _i13;
import 'package:resummy_app/features/cv_tools/presentation/screens/cv_tools_hub_screen.dart'
    as _i15;
import 'package:resummy_app/features/cv_tools/presentation/screens/history/cv_history_screen.dart'
    as _i14;
import 'package:resummy_app/features/cv_tools/presentation/screens/translator/cv_translator_download_screen.dart'
    as _i16;
import 'package:resummy_app/features/cv_tools/presentation/screens/translator/cv_translator_language_screen.dart'
    as _i17;
import 'package:resummy_app/features/cv_tools/presentation/screens/translator/cv_translator_loading_screen.dart'
    as _i18;
import 'package:resummy_app/features/cv_tools/presentation/screens/translator/cv_translator_review_screen.dart'
    as _i19;
import 'package:resummy_app/features/cv_tools/presentation/screens/translator/cv_translator_upload_screen.dart'
    as _i20;
import 'package:resummy_app/features/history/presentation/screens/history_screen.dart'
    as _i21;
import 'package:resummy_app/features/home/presentation/screens/home_screen.dart'
    as _i22;
import 'package:resummy_app/features/interview/presentation/screens/feedback/interview_feedback_detail.dart'
    as _i23;
import 'package:resummy_app/features/interview/presentation/screens/feedback/interview_feedback_overview.dart'
    as _i24;
import 'package:resummy_app/features/interview/presentation/screens/feedback/interview_feedback_progress.dart'
    as _i25;
import 'package:resummy_app/features/interview/presentation/screens/feedback/interview_feedback_questions.dart'
    as _i26;
import 'package:resummy_app/features/interview/presentation/screens/feedback/interview_feedback_recommendations.dart'
    as _i27;
import 'package:resummy_app/features/interview/presentation/screens/interview_prep_screen.dart'
    as _i28;
import 'package:resummy_app/features/interview/presentation/screens/session/interview_session_closing.dart'
    as _i29;
import 'package:resummy_app/features/interview/presentation/screens/session/interview_session_followup.dart'
    as _i30;
import 'package:resummy_app/features/interview/presentation/screens/session/interview_session_opening.dart'
    as _i31;
import 'package:resummy_app/features/interview/presentation/screens/session/interview_session_question.dart'
    as _i32;
import 'package:resummy_app/features/interview/presentation/screens/session/interview_session_user_questions.dart'
    as _i33;
import 'package:resummy_app/features/interview/presentation/screens/setup/interview_setup_confirmation.dart'
    as _i34;
import 'package:resummy_app/features/interview/presentation/screens/setup/interview_setup_step1_cv.dart'
    as _i35;
import 'package:resummy_app/features/interview/presentation/screens/setup/interview_setup_step2_position.dart'
    as _i36;
import 'package:resummy_app/features/interview/presentation/screens/setup/interview_setup_step3_jd.dart'
    as _i37;
import 'package:resummy_app/features/interview/presentation/screens/setup/interview_setup_step4_preferences.dart'
    as _i38;
import 'package:resummy_app/features/main/presentation/screens/main_screen.dart'
    as _i40;
import 'package:resummy_app/features/profile/presentation/screens/profile_screen.dart'
    as _i46;

/// generated route for
/// [_i1.AuthScreen]
class AuthRoute extends _i48.PageRouteInfo<void> {
  const AuthRoute({List<_i48.PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthScreen();
    },
  );
}

/// generated route for
/// [_i2.CvAnalyzerInputScreen]
class CvAnalyzerInputRoute extends _i48.PageRouteInfo<void> {
  const CvAnalyzerInputRoute({List<_i48.PageRouteInfo>? children})
    : super(CvAnalyzerInputRoute.name, initialChildren: children);

  static const String name = 'CvAnalyzerInputRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i2.CvAnalyzerInputScreen();
    },
  );
}

/// generated route for
/// [_i3.CvAnalyzerResultScreen]
class CvAnalyzerResultRoute extends _i48.PageRouteInfo<void> {
  const CvAnalyzerResultRoute({List<_i48.PageRouteInfo>? children})
    : super(CvAnalyzerResultRoute.name, initialChildren: children);

  static const String name = 'CvAnalyzerResultRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i3.CvAnalyzerResultScreen();
    },
  );
}

/// generated route for
/// [_i4.CvAnalyzerUploadScreen]
class CvAnalyzerUploadRoute extends _i48.PageRouteInfo<void> {
  const CvAnalyzerUploadRoute({List<_i48.PageRouteInfo>? children})
    : super(CvAnalyzerUploadRoute.name, initialChildren: children);

  static const String name = 'CvAnalyzerUploadRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i4.CvAnalyzerUploadScreen();
    },
  );
}

/// generated route for
/// [_i5.CvBuilderPreviewScreen]
class CvBuilderPreviewRoute extends _i48.PageRouteInfo<void> {
  const CvBuilderPreviewRoute({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderPreviewRoute.name, initialChildren: children);

  static const String name = 'CvBuilderPreviewRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i5.CvBuilderPreviewScreen();
    },
  );
}

/// generated route for
/// [_i6.CvBuilderStep1Screen]
class CvBuilderStep1Route extends _i48.PageRouteInfo<void> {
  const CvBuilderStep1Route({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderStep1Route.name, initialChildren: children);

  static const String name = 'CvBuilderStep1Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i6.CvBuilderStep1Screen();
    },
  );
}

/// generated route for
/// [_i7.CvBuilderStep2Screen]
class CvBuilderStep2Route extends _i48.PageRouteInfo<void> {
  const CvBuilderStep2Route({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderStep2Route.name, initialChildren: children);

  static const String name = 'CvBuilderStep2Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i7.CvBuilderStep2Screen();
    },
  );
}

/// generated route for
/// [_i8.CvBuilderStep3Screen]
class CvBuilderStep3Route extends _i48.PageRouteInfo<void> {
  const CvBuilderStep3Route({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderStep3Route.name, initialChildren: children);

  static const String name = 'CvBuilderStep3Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i8.CvBuilderStep3Screen();
    },
  );
}

/// generated route for
/// [_i9.CvBuilderStep4Screen]
class CvBuilderStep4Route extends _i48.PageRouteInfo<void> {
  const CvBuilderStep4Route({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderStep4Route.name, initialChildren: children);

  static const String name = 'CvBuilderStep4Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i9.CvBuilderStep4Screen();
    },
  );
}

/// generated route for
/// [_i10.CvBuilderStep5Screen]
class CvBuilderStep5Route extends _i48.PageRouteInfo<void> {
  const CvBuilderStep5Route({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderStep5Route.name, initialChildren: children);

  static const String name = 'CvBuilderStep5Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i10.CvBuilderStep5Screen();
    },
  );
}

/// generated route for
/// [_i11.CvBuilderStep6Screen]
class CvBuilderStep6Route extends _i48.PageRouteInfo<void> {
  const CvBuilderStep6Route({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderStep6Route.name, initialChildren: children);

  static const String name = 'CvBuilderStep6Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i11.CvBuilderStep6Screen();
    },
  );
}

/// generated route for
/// [_i12.CvBuilderStep7Screen]
class CvBuilderStep7Route extends _i48.PageRouteInfo<void> {
  const CvBuilderStep7Route({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderStep7Route.name, initialChildren: children);

  static const String name = 'CvBuilderStep7Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i12.CvBuilderStep7Screen();
    },
  );
}

/// generated route for
/// [_i13.CvBuilderWelcomeScreen]
class CvBuilderWelcomeRoute extends _i48.PageRouteInfo<void> {
  const CvBuilderWelcomeRoute({List<_i48.PageRouteInfo>? children})
    : super(CvBuilderWelcomeRoute.name, initialChildren: children);

  static const String name = 'CvBuilderWelcomeRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i13.CvBuilderWelcomeScreen();
    },
  );
}

/// generated route for
/// [_i14.CvHistoryScreen]
class CvHistoryRoute extends _i48.PageRouteInfo<void> {
  const CvHistoryRoute({List<_i48.PageRouteInfo>? children})
    : super(CvHistoryRoute.name, initialChildren: children);

  static const String name = 'CvHistoryRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i14.CvHistoryScreen();
    },
  );
}

/// generated route for
/// [_i15.CvToolsHubScreen]
class CvToolsHubRoute extends _i48.PageRouteInfo<void> {
  const CvToolsHubRoute({List<_i48.PageRouteInfo>? children})
    : super(CvToolsHubRoute.name, initialChildren: children);

  static const String name = 'CvToolsHubRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i15.CvToolsHubScreen();
    },
  );
}

/// generated route for
/// [_i16.CvTranslatorDownloadScreen]
class CvTranslatorDownloadRoute extends _i48.PageRouteInfo<void> {
  const CvTranslatorDownloadRoute({List<_i48.PageRouteInfo>? children})
    : super(CvTranslatorDownloadRoute.name, initialChildren: children);

  static const String name = 'CvTranslatorDownloadRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i16.CvTranslatorDownloadScreen();
    },
  );
}

/// generated route for
/// [_i17.CvTranslatorLanguageScreen]
class CvTranslatorLanguageRoute extends _i48.PageRouteInfo<void> {
  const CvTranslatorLanguageRoute({List<_i48.PageRouteInfo>? children})
    : super(CvTranslatorLanguageRoute.name, initialChildren: children);

  static const String name = 'CvTranslatorLanguageRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i17.CvTranslatorLanguageScreen();
    },
  );
}

/// generated route for
/// [_i18.CvTranslatorLoadingScreen]
class CvTranslatorLoadingRoute extends _i48.PageRouteInfo<void> {
  const CvTranslatorLoadingRoute({List<_i48.PageRouteInfo>? children})
    : super(CvTranslatorLoadingRoute.name, initialChildren: children);

  static const String name = 'CvTranslatorLoadingRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i18.CvTranslatorLoadingScreen();
    },
  );
}

/// generated route for
/// [_i19.CvTranslatorReviewScreen]
class CvTranslatorReviewRoute extends _i48.PageRouteInfo<void> {
  const CvTranslatorReviewRoute({List<_i48.PageRouteInfo>? children})
    : super(CvTranslatorReviewRoute.name, initialChildren: children);

  static const String name = 'CvTranslatorReviewRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i19.CvTranslatorReviewScreen();
    },
  );
}

/// generated route for
/// [_i20.CvTranslatorUploadScreen]
class CvTranslatorUploadRoute extends _i48.PageRouteInfo<void> {
  const CvTranslatorUploadRoute({List<_i48.PageRouteInfo>? children})
    : super(CvTranslatorUploadRoute.name, initialChildren: children);

  static const String name = 'CvTranslatorUploadRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i20.CvTranslatorUploadScreen();
    },
  );
}

/// generated route for
/// [_i21.HistoryScreen]
class HistoryRoute extends _i48.PageRouteInfo<void> {
  const HistoryRoute({List<_i48.PageRouteInfo>? children})
    : super(HistoryRoute.name, initialChildren: children);

  static const String name = 'HistoryRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i21.HistoryScreen();
    },
  );
}

/// generated route for
/// [_i22.HomeScreen]
class HomeRoute extends _i48.PageRouteInfo<void> {
  const HomeRoute({List<_i48.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i22.HomeScreen();
    },
  );
}

/// generated route for
/// [_i23.InterviewFeedbackDetailScreen]
class InterviewFeedbackDetailRoute
    extends _i48.PageRouteInfo<InterviewFeedbackDetailRouteArgs> {
  InterviewFeedbackDetailRoute({
    _i49.Key? key,
    int feedbackIndex = 0,
    List<_i48.PageRouteInfo>? children,
  }) : super(
         InterviewFeedbackDetailRoute.name,
         args: InterviewFeedbackDetailRouteArgs(
           key: key,
           feedbackIndex: feedbackIndex,
         ),
         initialChildren: children,
       );

  static const String name = 'InterviewFeedbackDetailRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InterviewFeedbackDetailRouteArgs>(
        orElse: () => const InterviewFeedbackDetailRouteArgs(),
      );
      return _i23.InterviewFeedbackDetailScreen(
        key: args.key,
        feedbackIndex: args.feedbackIndex,
      );
    },
  );
}

class InterviewFeedbackDetailRouteArgs {
  const InterviewFeedbackDetailRouteArgs({this.key, this.feedbackIndex = 0});

  final _i49.Key? key;

  final int feedbackIndex;

  @override
  String toString() {
    return 'InterviewFeedbackDetailRouteArgs{key: $key, feedbackIndex: $feedbackIndex}';
  }
}

/// generated route for
/// [_i24.InterviewFeedbackOverviewScreen]
class InterviewFeedbackOverviewRoute extends _i48.PageRouteInfo<void> {
  const InterviewFeedbackOverviewRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewFeedbackOverviewRoute.name, initialChildren: children);

  static const String name = 'InterviewFeedbackOverviewRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i24.InterviewFeedbackOverviewScreen();
    },
  );
}

/// generated route for
/// [_i25.InterviewFeedbackProgressScreen]
class InterviewFeedbackProgressRoute extends _i48.PageRouteInfo<void> {
  const InterviewFeedbackProgressRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewFeedbackProgressRoute.name, initialChildren: children);

  static const String name = 'InterviewFeedbackProgressRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i25.InterviewFeedbackProgressScreen();
    },
  );
}

/// generated route for
/// [_i26.InterviewFeedbackQuestionsScreen]
class InterviewFeedbackQuestionsRoute extends _i48.PageRouteInfo<void> {
  const InterviewFeedbackQuestionsRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewFeedbackQuestionsRoute.name, initialChildren: children);

  static const String name = 'InterviewFeedbackQuestionsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i26.InterviewFeedbackQuestionsScreen();
    },
  );
}

/// generated route for
/// [_i27.InterviewFeedbackRecommendationsScreen]
class InterviewFeedbackRecommendationsRoute extends _i48.PageRouteInfo<void> {
  const InterviewFeedbackRecommendationsRoute({
    List<_i48.PageRouteInfo>? children,
  }) : super(
         InterviewFeedbackRecommendationsRoute.name,
         initialChildren: children,
       );

  static const String name = 'InterviewFeedbackRecommendationsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i27.InterviewFeedbackRecommendationsScreen();
    },
  );
}

/// generated route for
/// [_i28.InterviewPrepScreen]
class InterviewPrepRoute extends _i48.PageRouteInfo<void> {
  const InterviewPrepRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewPrepRoute.name, initialChildren: children);

  static const String name = 'InterviewPrepRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i28.InterviewPrepScreen();
    },
  );
}

/// generated route for
/// [_i29.InterviewSessionClosingScreen]
class InterviewSessionClosingRoute extends _i48.PageRouteInfo<void> {
  const InterviewSessionClosingRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewSessionClosingRoute.name, initialChildren: children);

  static const String name = 'InterviewSessionClosingRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i29.InterviewSessionClosingScreen();
    },
  );
}

/// generated route for
/// [_i30.InterviewSessionFollowupScreen]
class InterviewSessionFollowupRoute extends _i48.PageRouteInfo<void> {
  const InterviewSessionFollowupRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewSessionFollowupRoute.name, initialChildren: children);

  static const String name = 'InterviewSessionFollowupRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i30.InterviewSessionFollowupScreen();
    },
  );
}

/// generated route for
/// [_i31.InterviewSessionOpeningScreen]
class InterviewSessionOpeningRoute extends _i48.PageRouteInfo<void> {
  const InterviewSessionOpeningRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewSessionOpeningRoute.name, initialChildren: children);

  static const String name = 'InterviewSessionOpeningRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i31.InterviewSessionOpeningScreen();
    },
  );
}

/// generated route for
/// [_i32.InterviewSessionQuestionScreen]
class InterviewSessionQuestionRoute extends _i48.PageRouteInfo<void> {
  const InterviewSessionQuestionRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewSessionQuestionRoute.name, initialChildren: children);

  static const String name = 'InterviewSessionQuestionRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i32.InterviewSessionQuestionScreen();
    },
  );
}

/// generated route for
/// [_i33.InterviewSessionUserQuestionsScreen]
class InterviewSessionUserQuestionsRoute extends _i48.PageRouteInfo<void> {
  const InterviewSessionUserQuestionsRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewSessionUserQuestionsRoute.name, initialChildren: children);

  static const String name = 'InterviewSessionUserQuestionsRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i33.InterviewSessionUserQuestionsScreen();
    },
  );
}

/// generated route for
/// [_i34.InterviewSetupConfirmationScreen]
class InterviewSetupConfirmationRoute extends _i48.PageRouteInfo<void> {
  const InterviewSetupConfirmationRoute({List<_i48.PageRouteInfo>? children})
    : super(InterviewSetupConfirmationRoute.name, initialChildren: children);

  static const String name = 'InterviewSetupConfirmationRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i34.InterviewSetupConfirmationScreen();
    },
  );
}

/// generated route for
/// [_i35.InterviewSetupStep1Screen]
class InterviewSetupStep1Route extends _i48.PageRouteInfo<void> {
  const InterviewSetupStep1Route({List<_i48.PageRouteInfo>? children})
    : super(InterviewSetupStep1Route.name, initialChildren: children);

  static const String name = 'InterviewSetupStep1Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i35.InterviewSetupStep1Screen();
    },
  );
}

/// generated route for
/// [_i36.InterviewSetupStep2Screen]
class InterviewSetupStep2Route extends _i48.PageRouteInfo<void> {
  const InterviewSetupStep2Route({List<_i48.PageRouteInfo>? children})
    : super(InterviewSetupStep2Route.name, initialChildren: children);

  static const String name = 'InterviewSetupStep2Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i36.InterviewSetupStep2Screen();
    },
  );
}

/// generated route for
/// [_i37.InterviewSetupStep3Screen]
class InterviewSetupStep3Route extends _i48.PageRouteInfo<void> {
  const InterviewSetupStep3Route({List<_i48.PageRouteInfo>? children})
    : super(InterviewSetupStep3Route.name, initialChildren: children);

  static const String name = 'InterviewSetupStep3Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i37.InterviewSetupStep3Screen();
    },
  );
}

/// generated route for
/// [_i38.InterviewSetupStep4Screen]
class InterviewSetupStep4Route extends _i48.PageRouteInfo<void> {
  const InterviewSetupStep4Route({List<_i48.PageRouteInfo>? children})
    : super(InterviewSetupStep4Route.name, initialChildren: children);

  static const String name = 'InterviewSetupStep4Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i38.InterviewSetupStep4Screen();
    },
  );
}

/// generated route for
/// [_i39.LanguageSelectionScreen]
class LanguageSelectionRoute extends _i48.PageRouteInfo<void> {
  const LanguageSelectionRoute({List<_i48.PageRouteInfo>? children})
    : super(LanguageSelectionRoute.name, initialChildren: children);

  static const String name = 'LanguageSelectionRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i39.LanguageSelectionScreen();
    },
  );
}

/// generated route for
/// [_i40.MainScreen]
class MainRoute extends _i48.PageRouteInfo<void> {
  const MainRoute({List<_i48.PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i40.MainScreen();
    },
  );
}

/// generated route for
/// [_i41.OnboardingConfirmationScreen]
class OnboardingConfirmationRoute
    extends _i48.PageRouteInfo<OnboardingConfirmationRouteArgs> {
  OnboardingConfirmationRoute({
    _i49.Key? key,
    required String fullName,
    String? workStatus,
    String? targetRole,
    String? careerGoal,
    List<_i48.PageRouteInfo>? children,
  }) : super(
         OnboardingConfirmationRoute.name,
         args: OnboardingConfirmationRouteArgs(
           key: key,
           fullName: fullName,
           workStatus: workStatus,
           targetRole: targetRole,
           careerGoal: careerGoal,
         ),
         initialChildren: children,
       );

  static const String name = 'OnboardingConfirmationRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingConfirmationRouteArgs>();
      return _i41.OnboardingConfirmationScreen(
        key: args.key,
        fullName: args.fullName,
        workStatus: args.workStatus,
        targetRole: args.targetRole,
        careerGoal: args.careerGoal,
      );
    },
  );
}

class OnboardingConfirmationRouteArgs {
  const OnboardingConfirmationRouteArgs({
    this.key,
    required this.fullName,
    this.workStatus,
    this.targetRole,
    this.careerGoal,
  });

  final _i49.Key? key;

  final String fullName;

  final String? workStatus;

  final String? targetRole;

  final String? careerGoal;

  @override
  String toString() {
    return 'OnboardingConfirmationRouteArgs{key: $key, fullName: $fullName, workStatus: $workStatus, targetRole: $targetRole, careerGoal: $careerGoal}';
  }
}

/// generated route for
/// [_i42.OnboardingStep1Screen]
class OnboardingStep1Route extends _i48.PageRouteInfo<void> {
  const OnboardingStep1Route({List<_i48.PageRouteInfo>? children})
    : super(OnboardingStep1Route.name, initialChildren: children);

  static const String name = 'OnboardingStep1Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i42.OnboardingStep1Screen();
    },
  );
}

/// generated route for
/// [_i43.OnboardingStep2Screen]
class OnboardingStep2Route
    extends _i48.PageRouteInfo<OnboardingStep2RouteArgs> {
  OnboardingStep2Route({
    _i49.Key? key,
    required String fullName,
    List<_i48.PageRouteInfo>? children,
  }) : super(
         OnboardingStep2Route.name,
         args: OnboardingStep2RouteArgs(key: key, fullName: fullName),
         initialChildren: children,
       );

  static const String name = 'OnboardingStep2Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingStep2RouteArgs>();
      return _i43.OnboardingStep2Screen(key: args.key, fullName: args.fullName);
    },
  );
}

class OnboardingStep2RouteArgs {
  const OnboardingStep2RouteArgs({this.key, required this.fullName});

  final _i49.Key? key;

  final String fullName;

  @override
  String toString() {
    return 'OnboardingStep2RouteArgs{key: $key, fullName: $fullName}';
  }
}

/// generated route for
/// [_i44.OnboardingStep3Screen]
class OnboardingStep3Route
    extends _i48.PageRouteInfo<OnboardingStep3RouteArgs> {
  OnboardingStep3Route({
    _i49.Key? key,
    required String fullName,
    String? workStatus,
    List<_i48.PageRouteInfo>? children,
  }) : super(
         OnboardingStep3Route.name,
         args: OnboardingStep3RouteArgs(
           key: key,
           fullName: fullName,
           workStatus: workStatus,
         ),
         initialChildren: children,
       );

  static const String name = 'OnboardingStep3Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingStep3RouteArgs>();
      return _i44.OnboardingStep3Screen(
        key: args.key,
        fullName: args.fullName,
        workStatus: args.workStatus,
      );
    },
  );
}

class OnboardingStep3RouteArgs {
  const OnboardingStep3RouteArgs({
    this.key,
    required this.fullName,
    this.workStatus,
  });

  final _i49.Key? key;

  final String fullName;

  final String? workStatus;

  @override
  String toString() {
    return 'OnboardingStep3RouteArgs{key: $key, fullName: $fullName, workStatus: $workStatus}';
  }
}

/// generated route for
/// [_i45.OnboardingStep4Screen]
class OnboardingStep4Route
    extends _i48.PageRouteInfo<OnboardingStep4RouteArgs> {
  OnboardingStep4Route({
    _i49.Key? key,
    required String fullName,
    String? workStatus,
    String? targetRole,
    List<_i48.PageRouteInfo>? children,
  }) : super(
         OnboardingStep4Route.name,
         args: OnboardingStep4RouteArgs(
           key: key,
           fullName: fullName,
           workStatus: workStatus,
           targetRole: targetRole,
         ),
         initialChildren: children,
       );

  static const String name = 'OnboardingStep4Route';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OnboardingStep4RouteArgs>();
      return _i45.OnboardingStep4Screen(
        key: args.key,
        fullName: args.fullName,
        workStatus: args.workStatus,
        targetRole: args.targetRole,
      );
    },
  );
}

class OnboardingStep4RouteArgs {
  const OnboardingStep4RouteArgs({
    this.key,
    required this.fullName,
    this.workStatus,
    this.targetRole,
  });

  final _i49.Key? key;

  final String fullName;

  final String? workStatus;

  final String? targetRole;

  @override
  String toString() {
    return 'OnboardingStep4RouteArgs{key: $key, fullName: $fullName, workStatus: $workStatus, targetRole: $targetRole}';
  }
}

/// generated route for
/// [_i46.ProfileScreen]
class ProfileRoute extends _i48.PageRouteInfo<void> {
  const ProfileRoute({List<_i48.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i46.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i47.SplashScreen]
class SplashRoute extends _i48.PageRouteInfo<void> {
  const SplashRoute({List<_i48.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i48.PageInfo page = _i48.PageInfo(
    name,
    builder: (data) {
      return const _i47.SplashScreen();
    },
  );
}
