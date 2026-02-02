import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Resummy App'**
  String get appTitle;

  /// Welcome message on splash screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Resummy App'**
  String get welcomeMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginWithGoogle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @cvTools.
  ///
  /// In en, this message translates to:
  /// **'CV Tools'**
  String get cvTools;

  /// No description provided for @interview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get interview;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @welcomeToResummy.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Resummy'**
  String get welcomeToResummy;

  /// No description provided for @buildPerfectResumeWithAi.
  ///
  /// In en, this message translates to:
  /// **'Build your perfect resume with AI'**
  String get buildPerfectResumeWithAi;

  /// No description provided for @googleSignInComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In coming soon!'**
  String get googleSignInComingSoon;

  /// No description provided for @goToLanguageSelection.
  ///
  /// In en, this message translates to:
  /// **'Go to Language Selection'**
  String get goToLanguageSelection;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @letsBuildYourPerfectCareer.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build your perfect career'**
  String get letsBuildYourPerfectCareer;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @buildCv.
  ///
  /// In en, this message translates to:
  /// **'Build CV'**
  String get buildCv;

  /// No description provided for @analyzeCv.
  ///
  /// In en, this message translates to:
  /// **'Analyze CV'**
  String get analyzeCv;

  /// No description provided for @interviewPrep.
  ///
  /// In en, this message translates to:
  /// **'Interview Prep'**
  String get interviewPrep;

  /// No description provided for @translateCv.
  ///
  /// In en, this message translates to:
  /// **'Translate CV'**
  String get translateCv;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @cvAnalysisCompleted.
  ///
  /// In en, this message translates to:
  /// **'CV Analysis Completed'**
  String get cvAnalysisCompleted;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}/100'**
  String score(int score);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} day ago'**
  String daysAgo(int count);

  /// No description provided for @interviewPractice.
  ///
  /// In en, this message translates to:
  /// **'Interview Practice'**
  String get interviewPractice;

  /// No description provided for @softwareEngineer.
  ///
  /// In en, this message translates to:
  /// **'Software Engineer'**
  String get softwareEngineer;

  /// No description provided for @notificationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Notifications coming soon!'**
  String get notificationsComingSoon;

  /// No description provided for @cvAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'CV Analyzer'**
  String get cvAnalyzer;

  /// No description provided for @cvAnalyzerDesc.
  ///
  /// In en, this message translates to:
  /// **'Get AI-powered feedback on your CV'**
  String get cvAnalyzerDesc;

  /// No description provided for @cvBuilder.
  ///
  /// In en, this message translates to:
  /// **'CV Builder'**
  String get cvBuilder;

  /// No description provided for @cvBuilderDesc.
  ///
  /// In en, this message translates to:
  /// **'Build your CV step by step with AI assistance'**
  String get cvBuilderDesc;

  /// No description provided for @cvTranslator.
  ///
  /// In en, this message translates to:
  /// **'CV Translator'**
  String get cvTranslator;

  /// No description provided for @cvTranslatorDesc.
  ///
  /// In en, this message translates to:
  /// **'Translate your CV to multiple languages'**
  String get cvTranslatorDesc;

  /// No description provided for @cvHistory.
  ///
  /// In en, this message translates to:
  /// **'CV History'**
  String get cvHistory;

  /// No description provided for @cvHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'View and manage all your CVs'**
  String get cvHistoryDesc;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @certification.
  ///
  /// In en, this message translates to:
  /// **'Certification'**
  String get certification;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get additionalInfo;

  /// No description provided for @screenUnderConstruction.
  ///
  /// In en, this message translates to:
  /// **'This screen is under construction'**
  String get screenUnderConstruction;

  /// No description provided for @analysisDetail.
  ///
  /// In en, this message translates to:
  /// **'Analysis Detail'**
  String get analysisDetail;

  /// No description provided for @detailedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Detailed Analysis'**
  String get detailedAnalysis;

  /// No description provided for @analyzingCv.
  ///
  /// In en, this message translates to:
  /// **'Analyzing CV...'**
  String get analyzingCv;

  /// No description provided for @aiInterviewPractice.
  ///
  /// In en, this message translates to:
  /// **'AI Interview Practice'**
  String get aiInterviewPractice;

  /// No description provided for @practiceInterviewWithAi.
  ///
  /// In en, this message translates to:
  /// **'Practice interview with AI and get professional feedback'**
  String get practiceInterviewWithAi;

  /// No description provided for @startNewInterview.
  ///
  /// In en, this message translates to:
  /// **'Start New Interview'**
  String get startNewInterview;

  /// No description provided for @viewInterviewHistory.
  ///
  /// In en, this message translates to:
  /// **'View Interview History'**
  String get viewInterviewHistory;

  /// No description provided for @setupInterviewStep.
  ///
  /// In en, this message translates to:
  /// **'Setup Interview - Step {step}'**
  String setupInterviewStep(int step);

  /// No description provided for @selectCv.
  ///
  /// In en, this message translates to:
  /// **'Select CV'**
  String get selectCv;

  /// No description provided for @cvSoftwareEngineer.
  ///
  /// In en, this message translates to:
  /// **'CV Software Engineer'**
  String get cvSoftwareEngineer;

  /// No description provided for @analyzedOnDate.
  ///
  /// In en, this message translates to:
  /// **'Analyzed on {date} • Score: {score}'**
  String analyzedOnDate(String date, int score);

  /// No description provided for @interviewPracticeFrontend.
  ///
  /// In en, this message translates to:
  /// **'Interview Practice: Frontend Dev'**
  String get interviewPracticeFrontend;

  /// No description provided for @completedOnDate.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String completedOnDate(String date);

  /// No description provided for @moreHistoryWillAppear.
  ///
  /// In en, this message translates to:
  /// **'More history will appear here'**
  String get moreHistoryWillAppear;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get userEmail;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkThemeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Dark theme enabled'**
  String get darkThemeEnabled;

  /// No description provided for @lightThemeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Light theme enabled'**
  String get lightThemeEnabled;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @bahasaIndonesia.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get bahasaIndonesia;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get confirmLogout;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current}/{total}'**
  String stepProgress(int current, int total);

  /// No description provided for @whatsYourFullName.
  ///
  /// In en, this message translates to:
  /// **'What\'s your full name?'**
  String get whatsYourFullName;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @whatsYourCurrentStatus.
  ///
  /// In en, this message translates to:
  /// **'What\'s your current status?'**
  String get whatsYourCurrentStatus;

  /// No description provided for @freshGraduate.
  ///
  /// In en, this message translates to:
  /// **'Fresh Graduate'**
  String get freshGraduate;

  /// No description provided for @currentlyWorking.
  ///
  /// In en, this message translates to:
  /// **'Currently Working'**
  String get currentlyWorking;

  /// No description provided for @lookingForJob.
  ///
  /// In en, this message translates to:
  /// **'Looking for Job'**
  String get lookingForJob;

  /// No description provided for @freelancer.
  ///
  /// In en, this message translates to:
  /// **'Freelancer'**
  String get freelancer;

  /// No description provided for @whatsYourTargetRole.
  ///
  /// In en, this message translates to:
  /// **'What\'s your target role?'**
  String get whatsYourTargetRole;

  /// No description provided for @targetRole.
  ///
  /// In en, this message translates to:
  /// **'Target Role'**
  String get targetRole;

  /// No description provided for @targetRoleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Software Engineer, Product Manager'**
  String get targetRoleHint;

  /// No description provided for @typeToSeeSuggestions.
  ///
  /// In en, this message translates to:
  /// **'💡 Type to see suggestions'**
  String get typeToSeeSuggestions;

  /// No description provided for @whatsYourCareerGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your career goal?'**
  String get whatsYourCareerGoal;

  /// No description provided for @careerGoal.
  ///
  /// In en, this message translates to:
  /// **'Career Goal'**
  String get careerGoal;

  /// No description provided for @careerGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your career aspirations...'**
  String get careerGoalHint;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @yourProfileIsReady.
  ///
  /// In en, this message translates to:
  /// **'Your profile is ready!'**
  String get yourProfileIsReady;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @startUsingApp.
  ///
  /// In en, this message translates to:
  /// **'Start Using App'**
  String get startUsingApp;

  /// No description provided for @cvBuilderWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Professional CV'**
  String get cvBuilderWelcomeTitle;

  /// No description provided for @cvBuilderWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'We will guide you step by step to create an attractive CV'**
  String get cvBuilderWelcomeDesc;

  /// No description provided for @startCreatingCv.
  ///
  /// In en, this message translates to:
  /// **'Start Creating CV'**
  String get startCreatingCv;

  /// No description provided for @uploadCv.
  ///
  /// In en, this message translates to:
  /// **'Upload CV'**
  String get uploadCv;

  /// No description provided for @uploadYourCv.
  ///
  /// In en, this message translates to:
  /// **'Upload Your CV'**
  String get uploadYourCv;

  /// No description provided for @uploadNewCv.
  ///
  /// In en, this message translates to:
  /// **'Upload New CV'**
  String get uploadNewCv;

  /// No description provided for @useCvFromBuilder.
  ///
  /// In en, this message translates to:
  /// **'Use CV from Builder'**
  String get useCvFromBuilder;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
