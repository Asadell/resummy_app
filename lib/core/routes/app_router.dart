import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: LanguageSelectionRoute.page),
        AutoRoute(page: OnboardingStep1Route.page),
        AutoRoute(page: OnboardingStep2Route.page),
        AutoRoute(page: OnboardingStep3Route.page),
        AutoRoute(page: OnboardingStep4Route.page),
        AutoRoute(page: OnboardingConfirmationRoute.page),
        AutoRoute(
          page: MainRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, initial: true),
            AutoRoute(page: CvToolsHubRoute.page),
            AutoRoute(page: InterviewPrepRoute.page),
            AutoRoute(page: HistoryRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
        AutoRoute(page: CvAnalyzerUploadRoute.page),
        AutoRoute(page: CvBuilderWelcomeRoute.page),
        AutoRoute(page: CvBuilderStep1Route.page),
        AutoRoute(page: CvBuilderStep2Route.page),
        AutoRoute(page: CvBuilderStep3Route.page),
        AutoRoute(page: CvBuilderStep4Route.page),
        AutoRoute(page: CvBuilderStep5Route.page),
        AutoRoute(page: CvBuilderStep6Route.page),
        AutoRoute(page: CvBuilderStep7Route.page),
        AutoRoute(page: CvBuilderStep8Route.page),
        AutoRoute(page: CvBuilderCustomSectionStepRoute.page),
        AutoRoute(page: CvBuilderPreviewRoute.page),
        AutoRoute(page: CvAtsConverterRoute.page),
        AutoRoute(page: CvHistoryRoute.page),
        AutoRoute(page: InterviewSetupStep1Route.page),
        AutoRoute(page: InterviewSetupStep2Route.page),
        AutoRoute(page: InterviewSetupStep3Route.page),
        AutoRoute(page: InterviewSetupStep4Route.page),
        AutoRoute(page: InterviewSetupConfirmationRoute.page),
        AutoRoute(page: InterviewSessionOpeningRoute.page),
        AutoRoute(page: InterviewSessionQuestionRoute.page),
        AutoRoute(page: InterviewSessionClosingRoute.page),
        AutoRoute(page: InterviewFeedbackOverviewRoute.page),
        AutoRoute(page: InterviewFeedbackQuestionsRoute.page),
        AutoRoute(page: InterviewFeedbackDetailRoute.page),
        AutoRoute(page: InterviewFeedbackRecommendationsRoute.page),
        AutoRoute(page: InterviewFeedbackProgressRoute.page),
      ];
}
