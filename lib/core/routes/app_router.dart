import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Splash & Auth (No Bottom Nav)
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: LanguageSelectionRoute.page),
        
        // Onboarding (No Bottom Nav)
        AutoRoute(page: OnboardingStep1Route.page),
        AutoRoute(page: OnboardingStep2Route.page),
        AutoRoute(page: OnboardingStep3Route.page),
        AutoRoute(page: OnboardingStep4Route.page),
        AutoRoute(page: OnboardingConfirmationRoute.page),
        
        // Main App with Bottom Nav
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
        
        // CV Analyzer (No Bottom Nav)
        AutoRoute(page: CvAnalyzerUploadRoute.page),
        AutoRoute(page: CvAnalyzerInputRoute.page),
        AutoRoute(page: CvAnalyzerLoadingRoute.page),
        AutoRoute(page: CvAnalyzerResultRoute.page),
        
        // CV Builder (No Bottom Nav)
        AutoRoute(page: CvBuilderWelcomeRoute.page),
        AutoRoute(page: CvBuilderStep1Route.page),
        AutoRoute(page: CvBuilderStep2Route.page),
        AutoRoute(page: CvBuilderStep3Route.page),
        AutoRoute(page: CvBuilderStep4Route.page),
        AutoRoute(page: CvBuilderStep5Route.page),
        AutoRoute(page: CvBuilderStep6Route.page),
        AutoRoute(page: CvBuilderStep7Route.page),
        AutoRoute(page: CvBuilderPreviewRoute.page),
        
        // CV Translator (No Bottom Nav)
        AutoRoute(page: CvTranslatorUploadRoute.page),
        AutoRoute(page: CvTranslatorLanguageRoute.page),
        AutoRoute(page: CvTranslatorLoadingRoute.page),
        AutoRoute(page: CvTranslatorReviewRoute.page),
        AutoRoute(page: CvTranslatorDownloadRoute.page),
        
        // CV History (No Bottom Nav)
        AutoRoute(page: CvHistoryRoute.page),
        
        // Interview Setup (No Bottom Nav)
        AutoRoute(page: InterviewSetupStep1Route.page),
        AutoRoute(page: InterviewSetupStep2Route.page),
        AutoRoute(page: InterviewSetupStep3Route.page),
        AutoRoute(page: InterviewSetupStep4Route.page),
        AutoRoute(page: InterviewSetupConfirmationRoute.page),
        
        // Interview Session (No Bottom Nav)
        AutoRoute(page: InterviewSessionOpeningRoute.page),
        AutoRoute(page: InterviewSessionQuestionRoute.page),
        AutoRoute(page: InterviewSessionFollowupRoute.page),
        AutoRoute(page: InterviewSessionUserQuestionsRoute.page),
        AutoRoute(page: InterviewSessionClosingRoute.page),
        
        // Interview Feedback (No Bottom Nav)
        AutoRoute(page: InterviewFeedbackOverviewRoute.page),
        AutoRoute(page: InterviewFeedbackQuestionsRoute.page),
        AutoRoute(page: InterviewFeedbackDetailRoute.page),
        AutoRoute(page: InterviewFeedbackRecommendationsRoute.page),
        AutoRoute(page: InterviewFeedbackProgressRoute.page),
      ];
}
