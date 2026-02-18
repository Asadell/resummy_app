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

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

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

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @totalOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get totalOf;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @strengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get strengths;

  /// No description provided for @improvements.
  ///
  /// In en, this message translates to:
  /// **'Improvements'**
  String get improvements;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @suggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get suggestion;

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
  /// **'Score: {value}'**
  String score(int value);

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

  /// No description provided for @convertToCvAts.
  ///
  /// In en, this message translates to:
  /// **'Convert to CV ATS'**
  String get convertToCvAts;

  /// No description provided for @uploadOldCvDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload old CV, AI converts to ATS Friendly'**
  String get uploadOldCvDesc;

  /// No description provided for @myCvs.
  ///
  /// In en, this message translates to:
  /// **'My CVs'**
  String get myCvs;

  /// No description provided for @cvAtsConverter.
  ///
  /// In en, this message translates to:
  /// **'CV ATS Converter'**
  String get cvAtsConverter;

  /// No description provided for @step1UploadCv.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Upload CV'**
  String get step1UploadCv;

  /// No description provided for @uploadCvFormatPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload your CV file in PDF format'**
  String get uploadCvFormatPdf;

  /// No description provided for @step2WaitProcess.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Wait for Process'**
  String get step2WaitProcess;

  /// No description provided for @aiConvertingDesc.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing and converting your CV'**
  String get aiConvertingDesc;

  /// No description provided for @step3ReviewSave.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Review & Save'**
  String get step3ReviewSave;

  /// No description provided for @checkResultDesc.
  ///
  /// In en, this message translates to:
  /// **'Check the result, edit if necessary, then save to Library'**
  String get checkResultDesc;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNow;

  /// No description provided for @failedToSaveCv.
  ///
  /// In en, this message translates to:
  /// **'Failed to save CV'**
  String get failedToSaveCv;

  /// No description provided for @cvSavedToLibrary.
  ///
  /// In en, this message translates to:
  /// **'CV successfully saved to Library!'**
  String get cvSavedToLibrary;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it Works'**
  String get howItWorks;

  /// No description provided for @tapToSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to select file'**
  String get tapToSelectFile;

  /// No description provided for @supportedFormats.
  ///
  /// In en, this message translates to:
  /// **'PDF, JPG, PNG, WEBP'**
  String get supportedFormats;

  /// No description provided for @fileSelected.
  ///
  /// In en, this message translates to:
  /// **'File selected'**
  String get fileSelected;

  /// No description provided for @tapToChangeFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to change file'**
  String get tapToChangeFile;

  /// No description provided for @optionalTranslateCv.
  ///
  /// In en, this message translates to:
  /// **'Optional: Translate CV?'**
  String get optionalTranslateCv;

  /// No description provided for @startConversion.
  ///
  /// In en, this message translates to:
  /// **'Start Conversion'**
  String get startConversion;

  /// No description provided for @cvConvertedSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV successfully converted! Please check the preview below.'**
  String get cvConvertedSuccess;

  /// No description provided for @failedToSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to select file'**
  String get failedToSelectFile;

  /// No description provided for @failedToProcessCv.
  ///
  /// In en, this message translates to:
  /// **'Failed to process CV'**
  String get failedToProcessCv;

  /// No description provided for @extractingText.
  ///
  /// In en, this message translates to:
  /// **'Extracting text from document...'**
  String get extractingText;

  /// No description provided for @identifyingExperience.
  ///
  /// In en, this message translates to:
  /// **'Identifying work experience sections...'**
  String get identifyingExperience;

  /// No description provided for @organizingEducation.
  ///
  /// In en, this message translates to:
  /// **'Organizing education history...'**
  String get organizingEducation;

  /// No description provided for @groupingSkills.
  ///
  /// In en, this message translates to:
  /// **'Grouping skills...'**
  String get groupingSkills;

  /// No description provided for @finishingUp.
  ///
  /// In en, this message translates to:
  /// **'Finishing up...'**
  String get finishingUp;

  /// No description provided for @uploadCvStep.
  ///
  /// In en, this message translates to:
  /// **'Upload CV'**
  String get uploadCvStep;

  /// No description provided for @photoOrPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF or photo of your CV'**
  String get photoOrPdf;

  /// No description provided for @geminiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Gemini Analysis'**
  String get geminiAnalysis;

  /// No description provided for @aiExtractedInfo.
  ///
  /// In en, this message translates to:
  /// **'AI reads & extracts all info'**
  String get aiExtractedInfo;

  /// No description provided for @autoPopulate.
  ///
  /// In en, this message translates to:
  /// **'Auto-Populate'**
  String get autoPopulate;

  /// No description provided for @dataIntoForms.
  ///
  /// In en, this message translates to:
  /// **'Data directly goes to all forms'**
  String get dataIntoForms;

  /// No description provided for @editAndExport.
  ///
  /// In en, this message translates to:
  /// **'Edit & Export'**
  String get editAndExport;

  /// No description provided for @reviewEditExport.
  ///
  /// In en, this message translates to:
  /// **'Review, edit, and export ATS PDF'**
  String get reviewEditExport;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @namePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get namePlaceholder;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'john@example.com'**
  String get emailPlaceholder;

  /// No description provided for @linkedinPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'linkedin.com/in/yourname'**
  String get linkedinPlaceholder;

  /// No description provided for @portfolioPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'github.com/yourname'**
  String get portfolioPlaceholder;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'New York, USA'**
  String get locationPlaceholder;

  /// No description provided for @jobTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Software Engineer'**
  String get jobTitlePlaceholder;

  /// No description provided for @companyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Google Inc.'**
  String get companyPlaceholder;

  /// No description provided for @institutionPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Massachusetts Institute of Technology'**
  String get institutionPlaceholder;

  /// No description provided for @majorPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get majorPlaceholder;

  /// No description provided for @degreePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Bachelor\'s Degree (S1)'**
  String get degreePlaceholder;

  /// No description provided for @gpaPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'3.85'**
  String get gpaPlaceholder;

  /// No description provided for @startYearPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'2018'**
  String get startYearPlaceholder;

  /// No description provided for @endYearPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'2022'**
  String get endYearPlaceholder;

  /// No description provided for @organizationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Student Union'**
  String get organizationPlaceholder;

  /// No description provided for @rolePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Head of Division'**
  String get rolePlaceholder;

  /// No description provided for @categoryNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Programming Languages'**
  String get categoryNamePlaceholder;

  /// No description provided for @certificationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Google Cloud Associate'**
  String get certificationPlaceholder;

  /// No description provided for @issuingOrgPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get issuingOrgPlaceholder;

  /// No description provided for @editSkillCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Skill Category'**
  String get editSkillCategory;

  /// No description provided for @skillsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Dart, Flutter, Firebase'**
  String get skillsPlaceholder;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemsCount(Object count);

  /// No description provided for @exampleSoftwareEngineer.
  ///
  /// In en, this message translates to:
  /// **'e.g., Software Engineer'**
  String get exampleSoftwareEngineer;

  /// No description provided for @exampleBachelor.
  ///
  /// In en, this message translates to:
  /// **'e.g., Bachelor of Science'**
  String get exampleBachelor;

  /// No description provided for @exampleGoogle.
  ///
  /// In en, this message translates to:
  /// **'e.g., Google'**
  String get exampleGoogle;

  /// No description provided for @exampleUniversity.
  ///
  /// In en, this message translates to:
  /// **'e.g., MIT'**
  String get exampleUniversity;

  /// No description provided for @exampleLocation.
  ///
  /// In en, this message translates to:
  /// **'e.g., Mountain View, CA'**
  String get exampleLocation;

  /// No description provided for @exampleYear.
  ///
  /// In en, this message translates to:
  /// **'e.g., 2020 or Jan 2020'**
  String get exampleYear;

  /// No description provided for @exampleYearEnd.
  ///
  /// In en, this message translates to:
  /// **'e.g., 2022 or Feb 2022'**
  String get exampleYearEnd;

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
  /// **'Additional Information'**
  String get additionalInfo;

  /// No description provided for @screenUnderConstruction.
  ///
  /// In en, this message translates to:
  /// **'This screen is under construction'**
  String get screenUnderConstruction;

  /// No description provided for @translatingCv.
  ///
  /// In en, this message translates to:
  /// **'Translating CV... ⏳'**
  String get translatingCv;

  /// No description provided for @translationEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimate: 20-30 seconds'**
  String get translationEstimate;

  /// No description provided for @translationTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Once finished, you can review and edit the translation before downloading.'**
  String get translationTip;

  /// No description provided for @startTranslation.
  ///
  /// In en, this message translates to:
  /// **'Start Translation'**
  String get startTranslation;

  /// No description provided for @reviewTranslation.
  ///
  /// In en, this message translates to:
  /// **'Review Translation'**
  String get reviewTranslation;

  /// No description provided for @refreshPreview.
  ///
  /// In en, this message translates to:
  /// **'Refresh Preview'**
  String get refreshPreview;

  /// No description provided for @approveAllAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Approve All & Continue'**
  String get approveAllAndContinue;

  /// No description provided for @translationComplete.
  ///
  /// In en, this message translates to:
  /// **'Translation Complete!'**
  String get translationComplete;

  /// No description provided for @downloadingPdf.
  ///
  /// In en, this message translates to:
  /// **'Downloading PDF...'**
  String get downloadingPdf;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

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
  /// **'Currently working here'**
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
  /// **'Type to see suggestions'**
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

  /// No description provided for @chooseCvSource.
  ///
  /// In en, this message translates to:
  /// **'Choose your CV source'**
  String get chooseCvSource;

  /// No description provided for @uploadNewCv.
  ///
  /// In en, this message translates to:
  /// **'Upload New CV'**
  String get uploadNewCv;

  /// No description provided for @uploadCvFileHint.
  ///
  /// In en, this message translates to:
  /// **'Upload PDF file (Max 5MB)'**
  String get uploadCvFileHint;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @useExistingCv.
  ///
  /// In en, this message translates to:
  /// **'Use Existing CV'**
  String get useExistingCv;

  /// No description provided for @savedCvs.
  ///
  /// In en, this message translates to:
  /// **'Saved CVs'**
  String get savedCvs;

  /// No description provided for @cvNumber.
  ///
  /// In en, this message translates to:
  /// **'CV #{number}'**
  String cvNumber(int number);

  /// No description provided for @createdOnDate.
  ///
  /// In en, this message translates to:
  /// **'Created on {date}'**
  String createdOnDate(String date);

  /// No description provided for @appliedPosition.
  ///
  /// In en, this message translates to:
  /// **'Applied Position'**
  String get appliedPosition;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @startAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Start Analysis'**
  String get startAnalysis;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @analyzingCvPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Analyzing CV, please wait...'**
  String get analyzingCvPleaseWait;

  /// No description provided for @processingCv.
  ///
  /// In en, this message translates to:
  /// **'Processing your CV, please wait...'**
  String get processingCv;

  /// No description provided for @analysisResult.
  ///
  /// In en, this message translates to:
  /// **'Analysis Result'**
  String get analysisResult;

  /// No description provided for @yourCvScore.
  ///
  /// In en, this message translates to:
  /// **'Your CV Score'**
  String get yourCvScore;

  /// No description provided for @detailScore.
  ///
  /// In en, this message translates to:
  /// **'Score Details'**
  String get detailScore;

  /// No description provided for @keywordMatch.
  ///
  /// In en, this message translates to:
  /// **'Keyword Match'**
  String get keywordMatch;

  /// No description provided for @quantifiableAchievements.
  ///
  /// In en, this message translates to:
  /// **'Quantifiable Achievements'**
  String get quantifiableAchievements;

  /// No description provided for @structureCompleteness.
  ///
  /// In en, this message translates to:
  /// **'Structure Completeness'**
  String get structureCompleteness;

  /// No description provided for @languageProfessionalism.
  ///
  /// In en, this message translates to:
  /// **'Language Professionalism'**
  String get languageProfessionalism;

  /// No description provided for @missingKeywords.
  ///
  /// In en, this message translates to:
  /// **'Missing Keywords'**
  String get missingKeywords;

  /// No description provided for @improvementSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Improvement Suggestions'**
  String get improvementSuggestions;

  /// No description provided for @summaryFeedback.
  ///
  /// In en, this message translates to:
  /// **'Summary Feedback'**
  String get summaryFeedback;

  /// No description provided for @updatedOnDate.
  ///
  /// In en, this message translates to:
  /// **'Updated on {date}'**
  String updatedOnDate(String date);

  /// No description provided for @noSavedCvs.
  ///
  /// In en, this message translates to:
  /// **'No saved CVs yet'**
  String get noSavedCvs;

  /// No description provided for @deleteCvConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this CV?'**
  String get deleteCvConfirmation;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @aiInterviewSimulator.
  ///
  /// In en, this message translates to:
  /// **'AI Interview Simulator'**
  String get aiInterviewSimulator;

  /// No description provided for @setupStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Practice interview with AI tailored to your CV and role'**
  String get setupStep1Desc;

  /// No description provided for @formatInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview Format:'**
  String get formatInterview;

  /// No description provided for @durationAprox.
  ///
  /// In en, this message translates to:
  /// **'Duration: ±15 minutes'**
  String get durationAprox;

  /// No description provided for @questionsCount.
  ///
  /// In en, this message translates to:
  /// **'Questions: 5 questions'**
  String get questionsCount;

  /// No description provided for @languageOption.
  ///
  /// In en, this message translates to:
  /// **'Language: ID / EN'**
  String get languageOption;

  /// No description provided for @methodStar.
  ///
  /// In en, this message translates to:
  /// **'Method: STAR-based'**
  String get methodStar;

  /// No description provided for @step1SelectCv.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Select your CV'**
  String get step1SelectCv;

  /// No description provided for @setupInterview.
  ///
  /// In en, this message translates to:
  /// **'Setup Interview'**
  String get setupInterview;

  /// No description provided for @appliedPositionLabel.
  ///
  /// In en, this message translates to:
  /// **'Applied Position: *'**
  String get appliedPositionLabel;

  /// No description provided for @companyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company Name: (Optional)'**
  String get companyNameLabel;

  /// No description provided for @positionLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Position Level:'**
  String get positionLevelLabel;

  /// No description provided for @industryLabel.
  ///
  /// In en, this message translates to:
  /// **'Industry:'**
  String get industryLabel;

  /// No description provided for @autoFillFromProfile.
  ///
  /// In en, this message translates to:
  /// **'Auto-fill from your profile'**
  String get autoFillFromProfile;

  /// No description provided for @dataHelpsAiTailor.
  ///
  /// In en, this message translates to:
  /// **'This data helps AI tailor interview questions with relevant context'**
  String get dataHelpsAiTailor;

  /// No description provided for @juniorLevel.
  ///
  /// In en, this message translates to:
  /// **'Junior (0-2 years)'**
  String get juniorLevel;

  /// No description provided for @midLevel.
  ///
  /// In en, this message translates to:
  /// **'Mid-level (3-5 years)'**
  String get midLevel;

  /// No description provided for @seniorLevel.
  ///
  /// In en, this message translates to:
  /// **'Senior (5+ years)'**
  String get seniorLevel;

  /// No description provided for @jobDescription.
  ///
  /// In en, this message translates to:
  /// **'Job Description'**
  String get jobDescription;

  /// No description provided for @step3PasteJd.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Paste Job Description'**
  String get step3PasteJd;

  /// No description provided for @jdDetailHelpsAi.
  ///
  /// In en, this message translates to:
  /// **'The more detailed the JD, the more accurate the AI interview questions'**
  String get jdDetailHelpsAi;

  /// No description provided for @pasteJobDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Paste Job Description:'**
  String get pasteJobDescriptionLabel;

  /// No description provided for @extractKeyRequirements.
  ///
  /// In en, this message translates to:
  /// **'Extract Key Requirements'**
  String get extractKeyRequirements;

  /// No description provided for @extractedRequirements.
  ///
  /// In en, this message translates to:
  /// **'Extracted Requirements'**
  String get extractedRequirements;

  /// No description provided for @noJdQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a JD?'**
  String get noJdQuestion;

  /// No description provided for @skipThisStep.
  ///
  /// In en, this message translates to:
  /// **'Skip this step →'**
  String get skipThisStep;

  /// No description provided for @setupComplete.
  ///
  /// In en, this message translates to:
  /// **'Setup Complete'**
  String get setupComplete;

  /// No description provided for @readyToStartInterview.
  ///
  /// In en, this message translates to:
  /// **'Ready to start the interview'**
  String get readyToStartInterview;

  /// No description provided for @interviewSummary.
  ///
  /// In en, this message translates to:
  /// **'Interview Summary:'**
  String get interviewSummary;

  /// No description provided for @cvLabel.
  ///
  /// In en, this message translates to:
  /// **'CV:'**
  String get cvLabel;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role:'**
  String get roleLabel;

  /// No description provided for @companyLabel.
  ///
  /// In en, this message translates to:
  /// **'Company:'**
  String get companyLabel;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language:'**
  String get languageLabel;

  /// No description provided for @questionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions:'**
  String get questionsLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration:'**
  String get durationLabel;

  /// No description provided for @starMethodGuide.
  ///
  /// In en, this message translates to:
  /// **'STAR Method Guide'**
  String get starMethodGuide;

  /// No description provided for @viewStarExample.
  ///
  /// In en, this message translates to:
  /// **'View STAR Method Example →'**
  String get viewStarExample;

  /// No description provided for @starTips.
  ///
  /// In en, this message translates to:
  /// **'Tips: Give specific and measurable answers. Use numbers and concrete results to strengthen your story.'**
  String get starTips;

  /// No description provided for @startInterviewNow.
  ///
  /// In en, this message translates to:
  /// **'Start Interview Now! →'**
  String get startInterviewNow;

  /// No description provided for @interviewStarted.
  ///
  /// In en, this message translates to:
  /// **'Interview Started'**
  String get interviewStarted;

  /// No description provided for @tapToAnswer.
  ///
  /// In en, this message translates to:
  /// **'Tap to Answer'**
  String get tapToAnswer;

  /// No description provided for @toggleText.
  ///
  /// In en, this message translates to:
  /// **'Toggle Text:'**
  String get toggleText;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'ON 🟢'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF ⚪'**
  String get off;

  /// No description provided for @exitInterviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Interview?'**
  String get exitInterviewTitle;

  /// No description provided for @exitInterviewContent.
  ///
  /// In en, this message translates to:
  /// **'Progress will be lost if you exit now.'**
  String get exitInterviewContent;

  /// No description provided for @continueInterview.
  ///
  /// In en, this message translates to:
  /// **'Continue Interview'**
  String get continueInterview;

  /// No description provided for @exitYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, Exit'**
  String get exitYes;

  /// No description provided for @questionXofY.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionXofY(int current, int total);

  /// No description provided for @behavioralStar.
  ///
  /// In en, this message translates to:
  /// **'Behavioral (STAR)'**
  String get behavioralStar;

  /// No description provided for @aiInterviewer.
  ///
  /// In en, this message translates to:
  /// **'AI Interviewer:'**
  String get aiInterviewer;

  /// No description provided for @hintStarMethod.
  ///
  /// In en, this message translates to:
  /// **'Hint: Use STAR method'**
  String get hintStarMethod;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswer;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording...'**
  String get recording;

  /// No description provided for @noTimeLimit.
  ///
  /// In en, this message translates to:
  /// **'No time limit'**
  String get noTimeLimit;

  /// No description provided for @speakRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Speak naturally'**
  String get speakRelaxed;

  /// No description provided for @transcriptRealTime.
  ///
  /// In en, this message translates to:
  /// **'Transcript (Real-time):'**
  String get transcriptRealTime;

  /// No description provided for @wordsAndSeconds.
  ///
  /// In en, this message translates to:
  /// **'~{words} words • {seconds}s'**
  String wordsAndSeconds(int words, int seconds);

  /// No description provided for @goodStartSituation.
  ///
  /// In en, this message translates to:
  /// **'Good: You started with Situation!'**
  String get goodStartSituation;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @finishAnswering.
  ///
  /// In en, this message translates to:
  /// **'Finish Answering'**
  String get finishAnswering;

  /// No description provided for @startAnswering.
  ///
  /// In en, this message translates to:
  /// **'Start Answering'**
  String get startAnswering;

  /// No description provided for @noAnswerRecorded.
  ///
  /// In en, this message translates to:
  /// **'No answer recorded'**
  String get noAnswerRecorded;

  /// No description provided for @passFair.
  ///
  /// In en, this message translates to:
  /// **'Fair Pass'**
  String get passFair;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice'**
  String get fail;

  /// No description provided for @interviewResults.
  ///
  /// In en, this message translates to:
  /// **'Interview Results'**
  String get interviewResults;

  /// No description provided for @interviewFinished.
  ///
  /// In en, this message translates to:
  /// **'Interview Finished!'**
  String get interviewFinished;

  /// No description provided for @positionLabel.
  ///
  /// In en, this message translates to:
  /// **'Position:'**
  String get positionLabel;

  /// No description provided for @bandScore.
  ///
  /// In en, this message translates to:
  /// **'Band Score'**
  String get bandScore;

  /// No description provided for @passGood.
  ///
  /// In en, this message translates to:
  /// **'Good Pass'**
  String get passGood;

  /// No description provided for @goodJobReady.
  ///
  /// In en, this message translates to:
  /// **'Great job! You are ready for the real interview 🎉'**
  String get goodJobReady;

  /// No description provided for @scoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Score Details'**
  String get scoreDetails;

  /// No description provided for @starStructure.
  ///
  /// In en, this message translates to:
  /// **'STAR Structure'**
  String get starStructure;

  /// No description provided for @contentQuality.
  ///
  /// In en, this message translates to:
  /// **'Content Quality'**
  String get contentQuality;

  /// No description provided for @fluency.
  ///
  /// In en, this message translates to:
  /// **'Fluency'**
  String get fluency;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @viewFullReport.
  ///
  /// In en, this message translates to:
  /// **'View Full Report'**
  String get viewFullReport;

  /// No description provided for @listenToRecording.
  ///
  /// In en, this message translates to:
  /// **'Listen to Your Recording'**
  String get listenToRecording;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @basedOnPerformance.
  ///
  /// In en, this message translates to:
  /// **'Based on your interview performance'**
  String get basedOnPerformance;

  /// No description provided for @yourStrengths.
  ///
  /// In en, this message translates to:
  /// **'Your Strengths'**
  String get yourStrengths;

  /// No description provided for @areasForImprovement.
  ///
  /// In en, this message translates to:
  /// **'Areas for Improvement'**
  String get areasForImprovement;

  /// No description provided for @selectedPractice.
  ///
  /// In en, this message translates to:
  /// **'Selected Practice'**
  String get selectedPractice;

  /// No description provided for @readyForInterview.
  ///
  /// In en, this message translates to:
  /// **'Ready for Interview?'**
  String get readyForInterview;

  /// No description provided for @practiceAgain.
  ///
  /// In en, this message translates to:
  /// **'Practice Again'**
  String get practiceAgain;

  /// No description provided for @emailReport.
  ///
  /// In en, this message translates to:
  /// **'Email Report'**
  String get emailReport;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @aiMessageOpening.
  ///
  /// In en, this message translates to:
  /// **'Good morning! I\'m Maya, HR from PT Tech Startup Indonesia. Thank you for taking the time for the interview today.'**
  String get aiMessageOpening;

  /// No description provided for @transcriptToggleHint.
  ///
  /// In en, this message translates to:
  /// **'Toggle text to show/hide transcript'**
  String get transcriptToggleHint;

  /// No description provided for @startInterview.
  ///
  /// In en, this message translates to:
  /// **'Start Interview'**
  String get startInterview;

  /// No description provided for @sampleQuestion1.
  ///
  /// In en, this message translates to:
  /// **'Tell me about a time you led a challenging project and how you handled it.'**
  String get sampleQuestion1;

  /// No description provided for @sampleQuestion2.
  ///
  /// In en, this message translates to:
  /// **'How do you handle conflict with coworkers?'**
  String get sampleQuestion2;

  /// No description provided for @sampleQuestion3.
  ///
  /// In en, this message translates to:
  /// **'Tell me about your biggest failure and what you learned.'**
  String get sampleQuestion3;

  /// No description provided for @sampleQuestion4.
  ///
  /// In en, this message translates to:
  /// **'How do you prioritize tasks when deadlines are tight?'**
  String get sampleQuestion4;

  /// No description provided for @sampleQuestion5.
  ///
  /// In en, this message translates to:
  /// **'Why are you interested in working for our company?'**
  String get sampleQuestion5;

  /// No description provided for @hintStarDetail.
  ///
  /// In en, this message translates to:
  /// **'S: Describe the situation\nT: Your task\nA: Action taken\nR: Measurable results'**
  String get hintStarDetail;

  /// No description provided for @followupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Question'**
  String get followupQuestion;

  /// No description provided for @prevAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Answer:'**
  String get prevAnswerLabel;

  /// No description provided for @showFullAnswer.
  ///
  /// In en, this message translates to:
  /// **'View full answer ▼'**
  String get showFullAnswer;

  /// No description provided for @hideFullAnswer.
  ///
  /// In en, this message translates to:
  /// **'Hide ▲'**
  String get hideFullAnswer;

  /// No description provided for @followupHint.
  ///
  /// In en, this message translates to:
  /// **'AI asks for more detail. Focus on specific challenges and your decision-making process.'**
  String get followupHint;

  /// No description provided for @depthThinkingHint.
  ///
  /// In en, this message translates to:
  /// **'Follow-up questions help AI understand your depth and critical thinking'**
  String get depthThinkingHint;

  /// No description provided for @interviewCompleted.
  ///
  /// In en, this message translates to:
  /// **'Interview Completed!'**
  String get interviewCompleted;

  /// No description provided for @goodJobUser.
  ///
  /// In en, this message translates to:
  /// **'Good job, {name}!'**
  String goodJobUser(Object name);

  /// No description provided for @analyzingAnswers.
  ///
  /// In en, this message translates to:
  /// **'Analyzing answers'**
  String get analyzingAnswers;

  /// No description provided for @evaluatingStar.
  ///
  /// In en, this message translates to:
  /// **'Evaluating STAR structure'**
  String get evaluatingStar;

  /// No description provided for @calculatingFluency.
  ///
  /// In en, this message translates to:
  /// **'Calculating fluency score'**
  String get calculatingFluency;

  /// No description provided for @generatingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Generating recommendations'**
  String get generatingRecommendations;

  /// No description provided for @generatingFeedbackProgress.
  ///
  /// In en, this message translates to:
  /// **'Generating feedback...'**
  String get generatingFeedbackProgress;

  /// No description provided for @estimateTime.
  ///
  /// In en, this message translates to:
  /// **'Estimate: 15-20 seconds'**
  String get estimateTime;

  /// No description provided for @totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total Duration'**
  String get totalDuration;

  /// No description provided for @questionsAnswered.
  ///
  /// In en, this message translates to:
  /// **'{count} answered'**
  String questionsAnswered(Object count);

  /// No description provided for @wordsSpoken.
  ///
  /// In en, this message translates to:
  /// **'Words spoken'**
  String get wordsSpoken;

  /// No description provided for @followups.
  ///
  /// In en, this message translates to:
  /// **'Follow-ups'**
  String get followups;

  /// No description provided for @yourQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Questions'**
  String get yourQuestionsTitle;

  /// No description provided for @anyQuestionsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you have any questions for the interviewer?'**
  String get anyQuestionsPrompt;

  /// No description provided for @askInterviewer.
  ///
  /// In en, this message translates to:
  /// **'Ask Interviewer'**
  String get askInterviewer;

  /// No description provided for @aiClosingMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you very much, {name}. You will receive detailed feedback in a moment.'**
  String aiClosingMessage(Object name);

  /// No description provided for @excellentStructure.
  ///
  /// In en, this message translates to:
  /// **'Excellent structure'**
  String get excellentStructure;

  /// No description provided for @relevantDetailed.
  ///
  /// In en, this message translates to:
  /// **'Relevant & detailed'**
  String get relevantDetailed;

  /// No description provided for @tooManyFillers.
  ///
  /// In en, this message translates to:
  /// **'Too many fillers'**
  String get tooManyFillers;

  /// No description provided for @goodPaceTone.
  ///
  /// In en, this message translates to:
  /// **'Good pace & tone'**
  String get goodPaceTone;

  /// No description provided for @starAnalysis.
  ///
  /// In en, this message translates to:
  /// **'STAR Structure Analysis'**
  String get starAnalysis;

  /// No description provided for @fluencyAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Fluency Analysis'**
  String get fluencyAnalysis;

  /// No description provided for @speakingPace.
  ///
  /// In en, this message translates to:
  /// **'Speaking Pace'**
  String get speakingPace;

  /// No description provided for @wordsPerMinute.
  ///
  /// In en, this message translates to:
  /// **'Words per minute: {wpm} WPM'**
  String wordsPerMinute(Object wpm);

  /// No description provided for @syllablesPerMinute.
  ///
  /// In en, this message translates to:
  /// **'Syllables/minute: {spm} SPM'**
  String syllablesPerMinute(Object spm);

  /// No description provided for @speakingPaceChart.
  ///
  /// In en, this message translates to:
  /// **'Speaking Pace Over Time:'**
  String get speakingPaceChart;

  /// No description provided for @fillerWordsLabel.
  ///
  /// In en, this message translates to:
  /// **'Filler Words'**
  String get fillerWordsLabel;

  /// No description provided for @totalFillerLabel.
  ///
  /// In en, this message translates to:
  /// **'Total filler → {percentage}% (Target: <5%)'**
  String totalFillerLabel(Object percentage);

  /// No description provided for @pauseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Pauses & Hesitations'**
  String get pauseAnalysis;

  /// No description provided for @improvedSpeechTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Speech vs Improved Speech'**
  String get improvedSpeechTitle;

  /// No description provided for @originalSpeechLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Original Speech'**
  String get originalSpeechLabel;

  /// No description provided for @improvedSpeechLabel.
  ///
  /// In en, this message translates to:
  /// **'Improved Speech'**
  String get improvedSpeechLabel;

  /// No description provided for @listenImprovedVersion.
  ///
  /// In en, this message translates to:
  /// **'Listen to Improved Version'**
  String get listenImprovedVersion;

  /// No description provided for @proTips.
  ///
  /// In en, this message translates to:
  /// **'Pro Tips:'**
  String get proTips;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// No description provided for @trackingLast5Sessions.
  ///
  /// In en, this message translates to:
  /// **'Tracking last 5 sessions'**
  String get trackingLast5Sessions;

  /// No description provided for @scoreHistory.
  ///
  /// In en, this message translates to:
  /// **'Interview Score History'**
  String get scoreHistory;

  /// No description provided for @metricComparison.
  ///
  /// In en, this message translates to:
  /// **'Metric Comparison'**
  String get metricComparison;

  /// No description provided for @overallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Score'**
  String get overallScore;

  /// No description provided for @focusThisWeekFiller.
  ///
  /// In en, this message translates to:
  /// **'This Week\'s Focus: Reduce Fillers!'**
  String get focusThisWeekFiller;

  /// No description provided for @milestonesReached.
  ///
  /// In en, this message translates to:
  /// **'Milestones Reached'**
  String get milestonesReached;

  /// No description provided for @compareSessions.
  ///
  /// In en, this message translates to:
  /// **'Compare Sessions'**
  String get compareSessions;

  /// No description provided for @fullReport.
  ///
  /// In en, this message translates to:
  /// **'Full Report'**
  String get fullReport;

  /// No description provided for @fullReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Interview Report'**
  String get fullReportTitle;

  /// No description provided for @strengthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Strengths'**
  String get strengthsLabel;

  /// No description provided for @improvementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Areas for Improvement'**
  String get improvementsLabel;

  /// No description provided for @selectedPracticeLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Practice'**
  String get selectedPracticeLabel;

  /// No description provided for @readinessAssessment.
  ///
  /// In en, this message translates to:
  /// **'Ready for Interview?'**
  String get readinessAssessment;

  /// No description provided for @exportReport.
  ///
  /// In en, this message translates to:
  /// **'Export Progress Report'**
  String get exportReport;

  /// No description provided for @compare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compare;

  /// No description provided for @viewDetail.
  ///
  /// In en, this message translates to:
  /// **'View Detail →'**
  String get viewDetail;

  /// No description provided for @viewPracticeTips.
  ///
  /// In en, this message translates to:
  /// **'View Practice Tips'**
  String get viewPracticeTips;

  /// No description provided for @fiveInterviewsCompleted.
  ///
  /// In en, this message translates to:
  /// **'5 Interviews\nCompleted'**
  String get fiveInterviewsCompleted;

  /// No description provided for @score75FirstTime.
  ///
  /// In en, this message translates to:
  /// **'Score 7.5+\nFirst Time'**
  String get score75FirstTime;

  /// No description provided for @score80.
  ///
  /// In en, this message translates to:
  /// **'Score 8.0+'**
  String get score80;

  /// No description provided for @tenInterviewsCompleted.
  ///
  /// In en, this message translates to:
  /// **'10 Interviews\nCompleted'**
  String get tenInterviewsCompleted;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session #{number}'**
  String session(Object number);

  /// No description provided for @vs.
  ///
  /// In en, this message translates to:
  /// **'vs'**
  String get vs;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @practiceQ1Filler.
  ///
  /// In en, this message translates to:
  /// **'Repeat Q1 focusing on removing fillers'**
  String get practiceQ1Filler;

  /// No description provided for @practiceQ1Button.
  ///
  /// In en, this message translates to:
  /// **'Practice Q1 →'**
  String get practiceQ1Button;

  /// No description provided for @practiceQ5Star.
  ///
  /// In en, this message translates to:
  /// **'Practice Q5 with better STAR structure'**
  String get practiceQ5Star;

  /// No description provided for @practiceQ5Button.
  ///
  /// In en, this message translates to:
  /// **'Practice Q5 →'**
  String get practiceQ5Button;

  /// No description provided for @practiceStrongResults.
  ///
  /// In en, this message translates to:
  /// **'Prepare 3 strong Result stories'**
  String get practiceStrongResults;

  /// No description provided for @practiceTipsButton.
  ///
  /// In en, this message translates to:
  /// **'Study Tips →'**
  String get practiceTipsButton;

  /// No description provided for @readinessScoreMessage.
  ///
  /// In en, this message translates to:
  /// **'Based on 7.5/10 score, you are READY:'**
  String get readinessScoreMessage;

  /// No description provided for @readinessJuniorMid.
  ///
  /// In en, this message translates to:
  /// **'✓ Junior-Mid level positions'**
  String get readinessJuniorMid;

  /// No description provided for @readinessStartupEnv.
  ///
  /// In en, this message translates to:
  /// **'✓ Startup environment (fast-paced)'**
  String get readinessStartupEnv;

  /// No description provided for @readinessSeniorRoles.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Senior roles - add more metrics & impact'**
  String get readinessSeniorRoles;

  /// No description provided for @readinessStatusExcellent.
  ///
  /// In en, this message translates to:
  /// **'Ready for Interview'**
  String get readinessStatusExcellent;

  /// No description provided for @readinessStatusGood.
  ///
  /// In en, this message translates to:
  /// **'Getting There'**
  String get readinessStatusGood;

  /// No description provided for @readinessStatusNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Needs Practice'**
  String get readinessStatusNeedsWork;

  /// No description provided for @readinessDescExcellent.
  ///
  /// In en, this message translates to:
  /// **'You show strong potential for the role.'**
  String get readinessDescExcellent;

  /// No description provided for @readinessDescGood.
  ///
  /// In en, this message translates to:
  /// **'You have good points but need more practice.'**
  String get readinessDescGood;

  /// No description provided for @readinessDescNeedsWork.
  ///
  /// In en, this message translates to:
  /// **'Focus on the improvements above to get ready.'**
  String get readinessDescNeedsWork;

  /// No description provided for @generatingQuestions.
  ///
  /// In en, this message translates to:
  /// **'Generating interview questions...'**
  String get generatingQuestions;

  /// No description provided for @interviewFocus.
  ///
  /// In en, this message translates to:
  /// **'Interview Focus'**
  String get interviewFocus;

  /// No description provided for @selectInterviewFocus.
  ///
  /// In en, this message translates to:
  /// **'Select Interview Focus'**
  String get selectInterviewFocus;

  /// No description provided for @interviewFocusDesc.
  ///
  /// In en, this message translates to:
  /// **'Determine the type of questions you want to practice.'**
  String get interviewFocusDesc;

  /// No description provided for @focusBehavioralTitle.
  ///
  /// In en, this message translates to:
  /// **'Behavioral (STAR)'**
  String get focusBehavioralTitle;

  /// No description provided for @focusBehavioralDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on soft skills, leadership, and past experiences using the STAR method.'**
  String get focusBehavioralDesc;

  /// No description provided for @focusTechnicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical / Hard Skills'**
  String get focusTechnicalTitle;

  /// No description provided for @focusTechnicalDesc.
  ///
  /// In en, this message translates to:
  /// **'Deep focus on coding, architecture, and role-specific technical knowledge.'**
  String get focusTechnicalDesc;

  /// No description provided for @focusMixedTitle.
  ///
  /// In en, this message translates to:
  /// **'Mixed (Composition)'**
  String get focusMixedTitle;

  /// No description provided for @focusMixedDesc.
  ///
  /// In en, this message translates to:
  /// **'A balanced combination of technical and behavioral questions.'**
  String get focusMixedDesc;

  /// No description provided for @readyToStartDesc.
  ///
  /// In en, this message translates to:
  /// **'You are ready to start the AI interview simulation.'**
  String get readyToStartDesc;

  /// No description provided for @uploadedFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Uploaded from device'**
  String get uploadedFromDevice;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @recordAgain.
  ///
  /// In en, this message translates to:
  /// **'Record Again'**
  String get recordAgain;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @replayQuestionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Replay Question'**
  String get replayQuestionTooltip;

  /// No description provided for @jdHintText.
  ///
  /// In en, this message translates to:
  /// **'Requirements:\n- 3+ years exp in React\n- Strong in RESTful API\n- Experience with microservices\n- Docker & Kubernetes\n\nResponsibilities:\n- Lead frontend development\n- Mentor junior developers\n- Code review & quality'**
  String get jdHintText;

  /// No description provided for @cvDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Uploaded CV'**
  String get cvDefaultLabel;

  /// No description provided for @questionsCountDynamic.
  ///
  /// In en, this message translates to:
  /// **'{count} Questions'**
  String questionsCountDynamic(Object count);

  /// No description provided for @industryTechnology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get industryTechnology;

  /// No description provided for @industryFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get industryFinance;

  /// No description provided for @industryHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get industryHealthcare;

  /// No description provided for @industryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get industryEducation;

  /// No description provided for @industryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get industryOther;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @endDateError.
  ///
  /// In en, this message translates to:
  /// **'Select end date or check \"Currently Working\"'**
  String get endDateError;

  /// No description provided for @credentialUrlHelper.
  ///
  /// In en, this message translates to:
  /// **'Link to verify certificate'**
  String get credentialUrlHelper;

  /// No description provided for @skipStepPrompt.
  ///
  /// In en, this message translates to:
  /// **'If none, you can skip this step.'**
  String get skipStepPrompt;

  /// No description provided for @skillHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Flutter, Leadership, English'**
  String get skillHint;

  /// No description provided for @skillTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Enter one by one or press enter.'**
  String get skillTip;

  /// No description provided for @aiSuggestion.
  ///
  /// In en, this message translates to:
  /// **'AI Suggestion'**
  String get aiSuggestion;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon!'**
  String get featureComingSoon;

  /// No description provided for @aiInspirationTitle.
  ///
  /// In en, this message translates to:
  /// **'Need inspiration?'**
  String get aiInspirationTitle;

  /// No description provided for @aiInspirationDesc.
  ///
  /// In en, this message translates to:
  /// **'Our AI can generate a professional summary based on the data you\'ve entered.'**
  String get aiInspirationDesc;

  /// No description provided for @generateWithAi.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get generateWithAi;

  /// No description provided for @summaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryLabel;

  /// No description provided for @summaryHint.
  ///
  /// In en, this message translates to:
  /// **'Write a brief summary of your most notable experiences and skills...'**
  String get summaryHint;

  /// No description provided for @summaryTip.
  ///
  /// In en, this message translates to:
  /// **'Tip: Use 2-4 strong sentences to describe your experience and career goals.'**
  String get summaryTip;

  /// No description provided for @additionalHeader.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalHeader;

  /// No description provided for @additionalDesc.
  ///
  /// In en, this message translates to:
  /// **'Languages, Hobbies, Projects, etc.'**
  String get additionalDesc;

  /// No description provided for @sectionLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get sectionLanguages;

  /// No description provided for @sectionVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get sectionVolunteer;

  /// No description provided for @sectionReferences.
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get sectionReferences;

  /// No description provided for @sectionInterests.
  ///
  /// In en, this message translates to:
  /// **'Interests & Hobbies'**
  String get sectionInterests;

  /// No description provided for @hintLanguages.
  ///
  /// In en, this message translates to:
  /// **'E.g., English (Passive), Japanese (N3)'**
  String get hintLanguages;

  /// No description provided for @hintVolunteer.
  ///
  /// In en, this message translates to:
  /// **'E.g., Disaster Relief Volunteer (2018), Event Committee Chair'**
  String get hintVolunteer;

  /// No description provided for @hintReferences.
  ///
  /// In en, this message translates to:
  /// **'E.g., John Doe - Manager (08123xxxx)'**
  String get hintReferences;

  /// No description provided for @hintInterests.
  ///
  /// In en, this message translates to:
  /// **'E.g., Reading, Traveling, Photography'**
  String get hintInterests;

  /// No description provided for @previewCV.
  ///
  /// In en, this message translates to:
  /// **'Preview CV'**
  String get previewCV;

  /// No description provided for @yourNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME'**
  String get yourNamePlaceholder;

  /// No description provided for @labelTechnicalSkills.
  ///
  /// In en, this message translates to:
  /// **'Technical Skills'**
  String get labelTechnicalSkills;

  /// No description provided for @labelSoftSkills.
  ///
  /// In en, this message translates to:
  /// **'Soft Skills'**
  String get labelSoftSkills;

  /// No description provided for @cvSavedTo.
  ///
  /// In en, this message translates to:
  /// **'CV saved to {path}'**
  String cvSavedTo(Object path);

  /// No description provided for @failedToGeneratePdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF: {error}'**
  String failedToGeneratePdf(Object error);

  /// No description provided for @noCvData.
  ///
  /// In en, this message translates to:
  /// **'No CV Data Found'**
  String get noCvData;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @exitBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit CV Builder?'**
  String get exitBuilderTitle;

  /// No description provided for @exitBuilderMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress is saved automatically. Are you sure you want to leave?'**
  String get exitBuilderMessage;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @gpaLabel.
  ///
  /// In en, this message translates to:
  /// **'GPA'**
  String get gpaLabel;

  /// No description provided for @sectionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Section not found'**
  String get sectionNotFound;

  /// No description provided for @invalidSectionType.
  ///
  /// In en, this message translates to:
  /// **'Invalid section type'**
  String get invalidSectionType;

  /// No description provided for @addedCategories.
  ///
  /// In en, this message translates to:
  /// **'Added Categories'**
  String get addedCategories;

  /// No description provided for @addNewCategory.
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @skillCategoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Skill category added successfully'**
  String get skillCategoryAdded;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryRequired;

  /// No description provided for @skillsRequired.
  ///
  /// In en, this message translates to:
  /// **'Skills are required'**
  String get skillsRequired;

  /// No description provided for @skillsHint.
  ///
  /// In en, this message translates to:
  /// **'Separate with commas: Java, Python, C++'**
  String get skillsHint;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'characters'**
  String get characters;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{category}\" category?'**
  String deleteCategoryConfirmation(Object category);

  /// No description provided for @skillsOrganizationTips.
  ///
  /// In en, this message translates to:
  /// **'Skills Organization Tips:'**
  String get skillsOrganizationTips;

  /// No description provided for @skillsTip1.
  ///
  /// In en, this message translates to:
  /// **'Group skills by category (Technical, Languages, Tools)'**
  String get skillsTip1;

  /// No description provided for @skillsTip2.
  ///
  /// In en, this message translates to:
  /// **'List most relevant skills first'**
  String get skillsTip2;

  /// No description provided for @skillsTip3.
  ///
  /// In en, this message translates to:
  /// **'Be specific (Node.js instead of just JavaScript)'**
  String get skillsTip3;

  /// No description provided for @skillsTip4.
  ///
  /// In en, this message translates to:
  /// **'Include proficiency levels if relevant'**
  String get skillsTip4;

  /// No description provided for @projectExperience.
  ///
  /// In en, this message translates to:
  /// **'Project / Experience'**
  String get projectExperience;

  /// No description provided for @courseCertification.
  ///
  /// In en, this message translates to:
  /// **'Course / Certification'**
  String get courseCertification;

  /// No description provided for @otherSkills.
  ///
  /// In en, this message translates to:
  /// **'Other Skills'**
  String get otherSkills;

  /// No description provided for @briefProfile.
  ///
  /// In en, this message translates to:
  /// **'Brief Profile'**
  String get briefProfile;

  /// No description provided for @selectSectionFormat.
  ///
  /// In en, this message translates to:
  /// **'Select Section Format'**
  String get selectSectionFormat;

  /// No description provided for @createSection.
  ///
  /// In en, this message translates to:
  /// **'Create Section'**
  String get createSection;

  /// No description provided for @templateExperienceName.
  ///
  /// In en, this message translates to:
  /// **'Experience Format'**
  String get templateExperienceName;

  /// No description provided for @templateExperienceDesc.
  ///
  /// In en, this message translates to:
  /// **'Suitable for: Volunteer, Projects, Awards with details'**
  String get templateExperienceDesc;

  /// No description provided for @templateEducationName.
  ///
  /// In en, this message translates to:
  /// **'Education Format'**
  String get templateEducationName;

  /// No description provided for @templateEducationDesc.
  ///
  /// In en, this message translates to:
  /// **'Suitable for: Courses, Informal certifications, Training'**
  String get templateEducationDesc;

  /// No description provided for @templateSkillsName.
  ///
  /// In en, this message translates to:
  /// **'Skills Format'**
  String get templateSkillsName;

  /// No description provided for @templateSkillsDesc.
  ///
  /// In en, this message translates to:
  /// **'Suitable for: Category - Tools, Languages, Technical Skills'**
  String get templateSkillsDesc;

  /// No description provided for @templateBulletName.
  ///
  /// In en, this message translates to:
  /// **'Bullet List'**
  String get templateBulletName;

  /// No description provided for @templateBulletDesc.
  ///
  /// In en, this message translates to:
  /// **'Suitable for: Simple list like Skills, Hobbies'**
  String get templateBulletDesc;

  /// No description provided for @templateParagraphName.
  ///
  /// In en, this message translates to:
  /// **'Paragraph'**
  String get templateParagraphName;

  /// No description provided for @templateParagraphDesc.
  ///
  /// In en, this message translates to:
  /// **'Suitable for: Long narratives, Profile, Statement'**
  String get templateParagraphDesc;

  /// No description provided for @reorderSectionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Reorder sections by pressing and dragging the menu icon'**
  String get reorderSectionsDesc;

  /// No description provided for @templateExperienceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience (Project, etc.)'**
  String get templateExperienceNameLabel;

  /// No description provided for @templateEducationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Education (Course, etc.)'**
  String get templateEducationNameLabel;

  /// No description provided for @templateSkillsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Skills (Category: skill 1, 2)'**
  String get templateSkillsNameLabel;

  /// No description provided for @templateBulletNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Bullet List'**
  String get templateBulletNameLabel;

  /// No description provided for @templateParagraphNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Paragraph (Free Text)'**
  String get templateParagraphNameLabel;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items yet'**
  String get noItems;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategories;

  /// No description provided for @addCategoryPrompt.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add Category\" to start'**
  String get addCategoryPrompt;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item?'**
  String get deleteItem;

  /// No description provided for @deleteItemConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteItemConfirmation(Object title);

  /// No description provided for @employmentTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get employmentTypeLabel;

  /// No description provided for @employmentTypeFullTime.
  ///
  /// In en, this message translates to:
  /// **'Full-time'**
  String get employmentTypeFullTime;

  /// No description provided for @employmentTypePartTime.
  ///
  /// In en, this message translates to:
  /// **'Part-time'**
  String get employmentTypePartTime;

  /// No description provided for @employmentTypeContract.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get employmentTypeContract;

  /// No description provided for @employmentTypeFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get employmentTypeFreelance;

  /// No description provided for @employmentTypeInternship.
  ///
  /// In en, this message translates to:
  /// **'Internship'**
  String get employmentTypeInternship;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String entriesCount(Object count);

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @currentlyActive.
  ///
  /// In en, this message translates to:
  /// **'Currently Active'**
  String get currentlyActive;

  /// No description provided for @bulletPoints.
  ///
  /// In en, this message translates to:
  /// **'Bullet Points'**
  String get bulletPoints;

  /// No description provided for @addBulletPointHint.
  ///
  /// In en, this message translates to:
  /// **'Add bullet point...'**
  String get addBulletPointHint;

  /// No description provided for @contentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get contentLabel;

  /// No description provided for @contentHint.
  ///
  /// In en, this message translates to:
  /// **'Write content for this section...'**
  String get contentHint;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @categoryAndSkillsRequired.
  ///
  /// In en, this message translates to:
  /// **'Category name and skills are required'**
  String get categoryAndSkillsRequired;

  /// No description provided for @typeAndAddHint.
  ///
  /// In en, this message translates to:
  /// **'Type item and press Add...'**
  String get typeAndAddHint;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @formatExperience.
  ///
  /// In en, this message translates to:
  /// **'Format: Experience'**
  String get formatExperience;

  /// No description provided for @formatEducation.
  ///
  /// In en, this message translates to:
  /// **'Format: Education'**
  String get formatEducation;

  /// No description provided for @formatSkills.
  ///
  /// In en, this message translates to:
  /// **'Format: Skills'**
  String get formatSkills;

  /// No description provided for @formatBulletList.
  ///
  /// In en, this message translates to:
  /// **'Format: Bullet List'**
  String get formatBulletList;

  /// No description provided for @formatParagraph.
  ///
  /// In en, this message translates to:
  /// **'Format: Paragraph'**
  String get formatParagraph;

  /// No description provided for @saveAsDraft.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get saveAsDraft;

  /// No description provided for @cvSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'CV saved successfully!'**
  String get cvSavedSuccess;

  /// No description provided for @downloadPdfUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Download PDF will be available soon!'**
  String get downloadPdfUnavailable;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @optionalField.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optionalField;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @stepHeader.
  ///
  /// In en, this message translates to:
  /// **'Step {current}/{total}'**
  String stepHeader(Object current, Object total);

  /// No description provided for @personalInfoHeader.
  ///
  /// In en, this message translates to:
  /// **'Personal Info / Header'**
  String get personalInfoHeader;

  /// No description provided for @personalInfoDesc.
  ///
  /// In en, this message translates to:
  /// **'Basic contact information'**
  String get personalInfoDesc;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @linkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedin;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio/Website'**
  String get portfolio;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'City, Country'**
  String get location;

  /// No description provided for @autoFillHint.
  ///
  /// In en, this message translates to:
  /// **'← Auto-fill if toggle ON'**
  String get autoFillHint;

  /// No description provided for @educationHistoryHeader.
  ///
  /// In en, this message translates to:
  /// **'Education History'**
  String get educationHistoryHeader;

  /// No description provided for @educationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Add formal/non-formal education'**
  String get educationHistoryDesc;

  /// No description provided for @noEducationData.
  ///
  /// In en, this message translates to:
  /// **'No education data yet'**
  String get noEducationData;

  /// No description provided for @addEducationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add your education history to make your CV look professional.'**
  String get addEducationPrompt;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'Add Education'**
  String get addEducation;

  /// No description provided for @addAnotherEducation.
  ///
  /// In en, this message translates to:
  /// **'Add Another Education'**
  String get addAnotherEducation;

  /// No description provided for @editEducation.
  ///
  /// In en, this message translates to:
  /// **'Edit Education'**
  String get editEducation;

  /// No description provided for @institutionName.
  ///
  /// In en, this message translates to:
  /// **'Institution Name'**
  String get institutionName;

  /// No description provided for @major.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get major;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'Degree'**
  String get degree;

  /// No description provided for @startYear.
  ///
  /// In en, this message translates to:
  /// **'Start Year'**
  String get startYear;

  /// No description provided for @endYear.
  ///
  /// In en, this message translates to:
  /// **'End Year'**
  String get endYear;

  /// No description provided for @currentlyStudying.
  ///
  /// In en, this message translates to:
  /// **'Currently studying here'**
  String get currentlyStudying;

  /// No description provided for @gpa.
  ///
  /// In en, this message translates to:
  /// **'GPA'**
  String get gpa;

  /// No description provided for @gpaOptional.
  ///
  /// In en, this message translates to:
  /// **'GPA / Final Grade (Optional)'**
  String get gpaOptional;

  /// No description provided for @organizationHistoryHeader.
  ///
  /// In en, this message translates to:
  /// **'Organization Experience'**
  String get organizationHistoryHeader;

  /// No description provided for @organizationHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Add volunteering, leadership, or other relevant experience'**
  String get organizationHistoryDesc;

  /// No description provided for @noOrganizationData.
  ///
  /// In en, this message translates to:
  /// **'No organization data yet'**
  String get noOrganizationData;

  /// No description provided for @addOrganization.
  ///
  /// In en, this message translates to:
  /// **'Add Organization'**
  String get addOrganization;

  /// No description provided for @editOrganization.
  ///
  /// In en, this message translates to:
  /// **'Edit Organization'**
  String get editOrganization;

  /// No description provided for @organizationRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get organizationRole;

  /// No description provided for @organizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get organizationName;

  /// No description provided for @experienceHistoryHeader.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get experienceHistoryHeader;

  /// No description provided for @experienceHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Add relevant work experience'**
  String get experienceHistoryDesc;

  /// No description provided for @noExperienceData.
  ///
  /// In en, this message translates to:
  /// **'No experience data yet'**
  String get noExperienceData;

  /// No description provided for @addExperiencePrompt.
  ///
  /// In en, this message translates to:
  /// **'Work experience is crucial to show your qualifications.'**
  String get addExperiencePrompt;

  /// No description provided for @addExperience.
  ///
  /// In en, this message translates to:
  /// **'Add Experience'**
  String get addExperience;

  /// No description provided for @addAnotherExperience.
  ///
  /// In en, this message translates to:
  /// **'Add Another Experience'**
  String get addAnotherExperience;

  /// No description provided for @editExperience.
  ///
  /// In en, this message translates to:
  /// **'Edit Experience'**
  String get editExperience;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @responsibilities.
  ///
  /// In en, this message translates to:
  /// **'Description / Responsibilities'**
  String get responsibilities;

  /// No description provided for @responsibilitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your responsibilities and achievements...'**
  String get responsibilitiesHint;

  /// No description provided for @certificationHeader.
  ///
  /// In en, this message translates to:
  /// **'Certifications & Licenses'**
  String get certificationHeader;

  /// No description provided for @certificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Add relevant certifications'**
  String get certificationDesc;

  /// No description provided for @noCertificationData.
  ///
  /// In en, this message translates to:
  /// **'No certification data yet'**
  String get noCertificationData;

  /// No description provided for @addCertificationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Certifications can validate your skills.'**
  String get addCertificationPrompt;

  /// No description provided for @addCertification.
  ///
  /// In en, this message translates to:
  /// **'Add Certification'**
  String get addCertification;

  /// No description provided for @addAnotherCertification.
  ///
  /// In en, this message translates to:
  /// **'Add Another Certification'**
  String get addAnotherCertification;

  /// No description provided for @editCertification.
  ///
  /// In en, this message translates to:
  /// **'Edit Certification'**
  String get editCertification;

  /// No description provided for @certificationName.
  ///
  /// In en, this message translates to:
  /// **'Certification Name'**
  String get certificationName;

  /// No description provided for @issuingOrganization.
  ///
  /// In en, this message translates to:
  /// **'Issuing Organization'**
  String get issuingOrganization;

  /// No description provided for @issueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue Date'**
  String get issueDate;

  /// No description provided for @expirationDate.
  ///
  /// In en, this message translates to:
  /// **'Expiration Date'**
  String get expirationDate;

  /// No description provided for @doesNotExpire.
  ///
  /// In en, this message translates to:
  /// **'Does not expire'**
  String get doesNotExpire;

  /// No description provided for @credentialId.
  ///
  /// In en, this message translates to:
  /// **'Credential ID (Optional)'**
  String get credentialId;

  /// No description provided for @credentialUrl.
  ///
  /// In en, this message translates to:
  /// **'Credential URL (Optional)'**
  String get credentialUrl;

  /// No description provided for @skillsHeader.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsHeader;

  /// No description provided for @skillsDesc.
  ///
  /// In en, this message translates to:
  /// **'Add technical and soft skills'**
  String get skillsDesc;

  /// No description provided for @noSkillsData.
  ///
  /// In en, this message translates to:
  /// **'No skills data yet'**
  String get noSkillsData;

  /// No description provided for @addSkillPrompt.
  ///
  /// In en, this message translates to:
  /// **'Specific skills will help you pass ATS screening.'**
  String get addSkillPrompt;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'Add Skill'**
  String get addSkill;

  /// No description provided for @addAnotherSkill.
  ///
  /// In en, this message translates to:
  /// **'Add Another Skill'**
  String get addAnotherSkill;

  /// No description provided for @editSkill.
  ///
  /// In en, this message translates to:
  /// **'Edit Skill'**
  String get editSkill;

  /// No description provided for @skillName.
  ///
  /// In en, this message translates to:
  /// **'Skill Name'**
  String get skillName;

  /// No description provided for @skillLevel.
  ///
  /// In en, this message translates to:
  /// **'Proficiency Level'**
  String get skillLevel;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get levelExpert;

  /// No description provided for @summaryHeader.
  ///
  /// In en, this message translates to:
  /// **'Professional Summary'**
  String get summaryHeader;

  /// No description provided for @summaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of your profile'**
  String get summaryDesc;

  /// No description provided for @generatingSummary.
  ///
  /// In en, this message translates to:
  /// **'Generating summary...'**
  String get generatingSummary;

  /// No description provided for @summaryTips.
  ///
  /// In en, this message translates to:
  /// **'Tips for ATS-friendly summary:\n• Mention years of experience\n• List key technical skills\n• Focus on measurable achievements\n• Keep it 2-3 sentences'**
  String get summaryTips;

  /// No description provided for @sectionManagerTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Sections'**
  String get sectionManagerTitle;

  /// No description provided for @sectionManagerDesc.
  ///
  /// In en, this message translates to:
  /// **'Reorder, rename, hide/show, or add custom sections'**
  String get sectionManagerDesc;

  /// No description provided for @sectionManagerTips.
  ///
  /// In en, this message translates to:
  /// **'Drag sections to reorder • Tap title to rename • Toggle to hide/show'**
  String get sectionManagerTips;

  /// No description provided for @addCustomSection.
  ///
  /// In en, this message translates to:
  /// **'Add Custom Section'**
  String get addCustomSection;

  /// No description provided for @deleteSection.
  ///
  /// In en, this message translates to:
  /// **'Delete Section'**
  String get deleteSection;

  /// No description provided for @deleteSectionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this section?'**
  String get deleteSectionConfirmation;

  /// No description provided for @noAdditionalData.
  ///
  /// In en, this message translates to:
  /// **'No additional information yet'**
  String get noAdditionalData;

  /// No description provided for @addAdditional.
  ///
  /// In en, this message translates to:
  /// **'Add Information'**
  String get addAdditional;

  /// No description provided for @addAnotherAdditional.
  ///
  /// In en, this message translates to:
  /// **'Add Another Information'**
  String get addAnotherAdditional;

  /// No description provided for @editAdditional.
  ///
  /// In en, this message translates to:
  /// **'Edit Information'**
  String get editAdditional;

  /// No description provided for @sectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Section Label'**
  String get sectionLabel;

  /// No description provided for @sectionLabelHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., Languages, Hobbies, Projects'**
  String get sectionLabelHint;

  /// No description provided for @sectionValue.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sectionValue;

  /// No description provided for @sectionValueHint.
  ///
  /// In en, this message translates to:
  /// **'E.g., English (Active), Football'**
  String get sectionValueHint;

  /// No description provided for @saveAndFinish.
  ///
  /// In en, this message translates to:
  /// **'Save & Finish'**
  String get saveAndFinish;

  /// No description provided for @phoneNoLeadingZero.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot start with 0'**
  String get phoneNoLeadingZero;

  /// No description provided for @phoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get phoneTooShort;

  /// No description provided for @yearTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Cannot exceed current year'**
  String get yearTooHigh;

  /// No description provided for @yearStartAfterEnd.
  ///
  /// In en, this message translates to:
  /// **'Start year cannot be after end year'**
  String get yearStartAfterEnd;

  /// No description provided for @dateStartAfterEnd.
  ///
  /// In en, this message translates to:
  /// **'Start date cannot be after end date'**
  String get dateStartAfterEnd;

  /// No description provided for @editContent.
  ///
  /// In en, this message translates to:
  /// **'Edit Content'**
  String get editContent;

  /// No description provided for @editCustomSection.
  ///
  /// In en, this message translates to:
  /// **'Edit Custom Section'**
  String get editCustomSection;

  /// No description provided for @emptyCustomSection.
  ///
  /// In en, this message translates to:
  /// **'No content yet. Click \"Edit Content\" to add.'**
  String get emptyCustomSection;

  /// No description provided for @templateLabel.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get templateLabel;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewLabel;

  /// No description provided for @addBulletPoint.
  ///
  /// In en, this message translates to:
  /// **'Add bullet point'**
  String get addBulletPoint;

  /// No description provided for @invalidYearMin1945.
  ///
  /// In en, this message translates to:
  /// **'Year must be at least 1945'**
  String get invalidYearMin1945;

  /// No description provided for @stopInterviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop Analysis?'**
  String get stopInterviewTitle;

  /// No description provided for @stopInterviewDesc.
  ///
  /// In en, this message translates to:
  /// **'If you leave now, the analysis will be cancelled and you will lose your interview data.'**
  String get stopInterviewDesc;

  /// No description provided for @recentInterviews.
  ///
  /// In en, this message translates to:
  /// **'Recent Interviews'**
  String get recentInterviews;

  /// No description provided for @noInterviewHistory.
  ///
  /// In en, this message translates to:
  /// **'No interview history yet.'**
  String get noInterviewHistory;

  /// No description provided for @sectionOrderVisibility.
  ///
  /// In en, this message translates to:
  /// **'Section Order & Visibility'**
  String get sectionOrderVisibility;

  /// No description provided for @sectionOrderTip.
  ///
  /// In en, this message translates to:
  /// **'Drag sections to reorder, toggle visibility, or edit titles'**
  String get sectionOrderTip;

  /// No description provided for @jobDescSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For more accurate keyword analysis'**
  String get jobDescSubtitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get filterHigh;

  /// No description provided for @filterMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get filterMedium;

  /// No description provided for @filterLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get filterLow;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cobaLagi.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get cobaLagi;

  /// No description provided for @uploadYourCv.
  ///
  /// In en, this message translates to:
  /// **'Upload Your CV'**
  String get uploadYourCv;

  /// No description provided for @cvAnalyzerSetupDesc.
  ///
  /// In en, this message translates to:
  /// **'Get in-depth analysis and improvement suggestions for your CV'**
  String get cvAnalyzerSetupDesc;

  /// No description provided for @jobDescPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste job description here for better keyword matching...'**
  String get jobDescPasteHint;

  /// No description provided for @max5Pages.
  ///
  /// In en, this message translates to:
  /// **'Max 5 pages'**
  String get max5Pages;

  /// No description provided for @applyingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Applying suggestions and reformatting your CV...'**
  String get applyingSuggestions;

  /// No description provided for @overallAtsScore.
  ///
  /// In en, this message translates to:
  /// **'Overall ATS Score'**
  String get overallAtsScore;

  /// No description provided for @noSuggestionsForFilter.
  ///
  /// In en, this message translates to:
  /// **'No suggestions for this filter'**
  String get noSuggestionsForFilter;

  /// No description provided for @originalText.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalText;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @undoApply.
  ///
  /// In en, this message translates to:
  /// **'Undo Apply'**
  String get undoApply;

  /// No description provided for @undoDismiss.
  ///
  /// In en, this message translates to:
  /// **'Undo Dismiss'**
  String get undoDismiss;

  /// No description provided for @createCvFromSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Create CV ATS from these {count} suggestions'**
  String createCvFromSuggestions(Object count);

  /// No description provided for @createNewAtsCvTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New CV ATS?'**
  String get createNewAtsCvTitle;

  /// No description provided for @createCvAtsConfirmationDesc.
  ///
  /// In en, this message translates to:
  /// **'The system will create a new CV based on your original CV plus all the suggestions you have \"Applied\".\n\nThis CV can be edited again in the CV Builder.'**
  String get createCvAtsConfirmationDesc;

  /// No description provided for @createNow.
  ///
  /// In en, this message translates to:
  /// **'Create Now'**
  String get createNow;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @replayQuestion.
  ///
  /// In en, this message translates to:
  /// **'Replay Question'**
  String get replayQuestion;

  /// No description provided for @processingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Processing answer...'**
  String get processingAnswer;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @companyNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Google, Microsoft'**
  String get companyNameHint;

  /// No description provided for @max5PagesInterview.
  ///
  /// In en, this message translates to:
  /// **'Max 5 pages for interview simulation.'**
  String get max5PagesInterview;

  /// No description provided for @profileInfo.
  ///
  /// In en, this message translates to:
  /// **'Profile Info'**
  String get profileInfo;

  /// No description provided for @errorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile. Please try again.'**
  String get errorSavingProfile;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String loginError(Object error);

  /// No description provided for @buildYourCareer.
  ///
  /// In en, this message translates to:
  /// **'Build Your Career'**
  String get buildYourCareer;

  /// No description provided for @cvSourceBuilder.
  ///
  /// In en, this message translates to:
  /// **'Builder'**
  String get cvSourceBuilder;

  /// No description provided for @cvSourceAtsConverter.
  ///
  /// In en, this message translates to:
  /// **'ATS Converter'**
  String get cvSourceAtsConverter;

  /// No description provided for @cvSourceAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'Analyzer'**
  String get cvSourceAnalyzer;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// No description provided for @timeDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get timeDaysSuffix;

  /// No description provided for @timeHoursSuffix.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get timeHoursSuffix;

  /// No description provided for @timeMinutesSuffix.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get timeMinutesSuffix;

  /// No description provided for @debugSkipQuestions.
  ///
  /// In en, this message translates to:
  /// **'DEBUG: Skip with 5 Questions'**
  String get debugSkipQuestions;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @appliedStatus.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get appliedStatus;

  /// No description provided for @dismissedStatus.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get dismissedStatus;

  /// No description provided for @originalLanguage.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalLanguage;

  /// No description provided for @linkedinLabel.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get linkedinLabel;

  /// No description provided for @portfolioLabel.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolioLabel;

  /// No description provided for @credentialIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get credentialIdLabel;

  /// No description provided for @educationDegreesConnector.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get educationDegreesConnector;

  /// No description provided for @exportCv.
  ///
  /// In en, this message translates to:
  /// **'Export CV'**
  String get exportCv;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareDesc.
  ///
  /// In en, this message translates to:
  /// **'Share via WhatsApp, Email, etc.'**
  String get shareDesc;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @saveToDownloads.
  ///
  /// In en, this message translates to:
  /// **'Save to Downloads folder'**
  String get saveToDownloads;

  /// No description provided for @activityHistory.
  ///
  /// In en, this message translates to:
  /// **'Activity History'**
  String get activityHistory;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor your career progress here'**
  String get historySubtitle;

  /// No description provided for @weeklyInsight.
  ///
  /// In en, this message translates to:
  /// **'Weekly Insight'**
  String get weeklyInsight;

  /// No description provided for @weeklyInsightDesc.
  ///
  /// In en, this message translates to:
  /// **'Your CV score increased by 15 points in the last 2 weeks! 🚀'**
  String get weeklyInsightDesc;

  /// No description provided for @viewProgressDetail.
  ///
  /// In en, this message translates to:
  /// **'View Progress Detail'**
  String get viewProgressDetail;

  /// No description provided for @suggestionForYou.
  ///
  /// In en, this message translates to:
  /// **'Improvement Suggestion'**
  String get suggestionForYou;

  /// No description provided for @suggestionForYouDesc.
  ///
  /// In en, this message translates to:
  /// **'Already revised CV 2x for PM position. Time to try an interview simulation?'**
  String get suggestionForYouDesc;

  /// No description provided for @startPracticeBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Practice →'**
  String get startPracticeBtn;

  /// No description provided for @filterCv.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get filterCv;

  /// No description provided for @filterInterview.
  ///
  /// In en, this message translates to:
  /// **'Interview'**
  String get filterInterview;

  /// No description provided for @noActivityFound.
  ///
  /// In en, this message translates to:
  /// **'No activity found yet'**
  String get noActivityFound;

  /// No description provided for @deleteExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Experience?'**
  String get deleteExperienceTitle;

  /// No description provided for @deleteExperienceContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this experience? This action cannot be undone.'**
  String get deleteExperienceContent;

  /// No description provided for @deleteEducationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Education?'**
  String get deleteEducationTitle;

  /// No description provided for @deleteEducationContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this education? This action cannot be undone.'**
  String get deleteEducationContent;
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
