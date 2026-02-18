import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id')
  ];

  String get appTitle;

  String get welcomeMessage;

  String get login;

  String get loginWithGoogle;

  String get logout;

  String get home;

  String get cvTools;

  String get interview;

  String get history;

  String get profile;

  String get next;

  String get add;

  String get back;

  String get cancel;

  String get save;

  String get delete;

  String get edit;

  String get done;

  String get skip;

  String get finish;

  String get question;

  String get questions;

  String get totalOf;

  String get feedback;

  String get strengths;

  String get improvements;

  String get previous;

  String get suggestion;

  String get getStarted;

  String get continueText;

  String get selectLanguage;

  String get english;

  String get indonesian;

  String get welcomeToResummy;

  String get buildPerfectResumeWithAi;

  String get googleSignInComingSoon;

  String get goToLanguageSelection;

  String get welcomeBack;

  String get letsBuildYourPerfectCareer;

  String get quickActions;

  String get buildCv;

  String get analyzeCv;

  String get interviewPrep;

  String get translateCv;

  String get recentActivity;

  String get viewAll;

  String get cvAnalysisCompleted;

  String score(int score);

  String hoursAgo(int count);

  String daysAgo(int count);

  String get interviewPractice;

  String get softwareEngineer;

  String get notificationsComingSoon;

  String get cvAnalyzer;

  String get cvAnalyzerDesc;

  String get cvBuilder;

  String get cvBuilderDesc;

  String get cvTranslator;

  String get cvTranslatorDesc;

  String get cvHistory;

  String get cvHistoryDesc;

  String get convertToCvAts;

  String get uploadOldCvDesc;

  String get myCvs;

  String get cvAtsConverter;

  String get step1UploadCv;

  String get uploadCvFormatPdf;

  String get step2WaitProcess;

  String get aiConvertingDesc;

  String get step3ReviewSave;

  String get checkResultDesc;

  String get startNow;

  String get failedToSaveCv;

  String get cvSavedToLibrary;

  String get howItWorks;

  String get tapToSelectFile;

  String get supportedFormats;

  String get fileSelected;

  String get tapToChangeFile;

  String get optionalTranslateCv;

  String get startConversion;

  String get cvConvertedSuccess;

  String get failedToSelectFile;

  String get failedToProcessCv;

  String get extractingText;

  String get identifyingExperience;

  String get organizingEducation;

  String get groupingSkills;

  String get finishingUp;

  String get uploadCvStep;

  String get photoOrPdf;

  String get geminiAnalysis;

  String get aiExtractedInfo;

  String get autoPopulate;

  String get dataIntoForms;

  String get editAndExport;

  String get reviewEditExport;

  String get emailLabel;

  String get namePlaceholder;

  String get emailPlaceholder;

  String get linkedinPlaceholder;

  String get portfolioPlaceholder;

  String get locationPlaceholder;

  String get jobTitlePlaceholder;

  String get companyPlaceholder;

  String get institutionPlaceholder;

  String get majorPlaceholder;

  String get degreePlaceholder;

  String get gpaPlaceholder;

  String get startYearPlaceholder;

  String get endYearPlaceholder;

  String get organizationPlaceholder;

  String get rolePlaceholder;

  String get categoryNamePlaceholder;

  String get certificationPlaceholder;

  String get issuingOrgPlaceholder;

  String get editSkillCategory;

  String get skillsPlaceholder;

  String itemsCount(Object count);

  String get exampleSoftwareEngineer;

  String get exampleBachelor;

  String get exampleGoogle;

  String get exampleUniversity;

  String get exampleLocation;

  String get exampleYear;

  String get exampleYearEnd;

  String get personalInfo;

  String get education;

  String get experience;

  String get certification;

  String get skills;

  String get summary;

  String get additionalInfo;

  String get screenUnderConstruction;

  String get translatingCv;

  String get translationEstimate;

  String get translationTip;

  String get startTranslation;

  String get reviewTranslation;

  String get refreshPreview;

  String get approveAllAndContinue;

  String get translationComplete;

  String get downloadingPdf;

  String get backToDashboard;

  String get analysisDetail;

  String get detailedAnalysis;

  String get analyzingCv;

  String get aiInterviewPractice;

  String get practiceInterviewWithAi;

  String get startNewInterview;

  String get viewInterviewHistory;

  String setupInterviewStep(int step);

  String get selectCv;

  String get cvSoftwareEngineer;

  String analyzedOnDate(String date, int score);

  String get interviewPracticeFrontend;

  String completedOnDate(String date);

  String get moreHistoryWillAppear;

  String get userName;

  String get userEmail;

  String get settings;

  String get darkMode;

  String get darkThemeEnabled;

  String get lightThemeEnabled;

  String get language;

  String get bahasaIndonesia;

  String get confirmLogout;

  String stepProgress(int current, int total);

  String get whatsYourFullName;

  String get fullName;

  String get enterYourFullName;

  String get whatsYourCurrentStatus;

  String get freshGraduate;

  String get currentlyWorking;

  String get lookingForJob;

  String get freelancer;

  String get whatsYourTargetRole;

  String get targetRole;

  String get targetRoleHint;

  String get typeToSeeSuggestions;

  String get whatsYourCareerGoal;

  String get careerGoal;

  String get careerGoalHint;

  String get confirmation;

  String get yourProfileIsReady;

  String get status;

  String get goal;

  String get startUsingApp;

  String get cvBuilderWelcomeTitle;

  String get cvBuilderWelcomeDesc;

  String get startCreatingCv;

  String get uploadCv;

  String get chooseCvSource;

  String get uploadNewCv;

  String get uploadCvFileHint;

  String get or;

  String get useExistingCv;

  String get savedCvs;

  String cvNumber(int number);

  String createdOnDate(String date);

  String get appliedPosition;

  String get optional;

  String get startAnalysis;

  String get noFileSelected;

  String get analyzingCvPleaseWait;

  String get processingCv;

  String get analysisResult;

  String get yourCvScore;

  String get detailScore;

  String get keywordMatch;

  String get quantifiableAchievements;

  String get structureCompleteness;

  String get languageProfessionalism;

  String get missingKeywords;

  String get improvementSuggestions;

  String get summaryFeedback;

  String updatedOnDate(Object date);

  String get noSavedCvs;

  String get deleteCvConfirmation;

  String get backToHome;

  String get aiInterviewSimulator;

  String get setupStep1Desc;

  String get formatInterview;

  String get durationAprox;

  String get questionsCount;

  String get languageOption;

  String get methodStar;

  String get step1SelectCv;

  String get setupInterview;

  String get appliedPositionLabel;

  String get companyNameLabel;

  String get positionLevelLabel;

  String get industryLabel;

  String get autoFillFromProfile;

  String get dataHelpsAiTailor;

  String get juniorLevel;

  String get midLevel;

  String get seniorLevel;

  String get jobDescription;

  String get step3PasteJd;

  String get jdDetailHelpsAi;

  String get pasteJobDescriptionLabel;

  String get extractKeyRequirements;

  String get extractedRequirements;

  String get noJdQuestion;

  String get skipThisStep;

  String get setupComplete;

  String get readyToStartInterview;

  String get interviewSummary;

  String get cvLabel;

  String get roleLabel;

  String get companyLabel;

  String get languageLabel;

  String get questionsLabel;

  String get durationLabel;

  String get starMethodGuide;

  String get viewStarExample;

  String get starTips;

  String get startInterviewNow;

  String get interviewStarted;

  String get tapToAnswer;

  String get toggleText;

  String get on;

  String get off;

  String get exitInterviewTitle;

  String get exitInterviewContent;

  String get continueInterview;

  String get exitYes;

  String questionXofY(int current, int total);

  String get behavioralStar;

  String get aiInterviewer;

  String get hintStarMethod;

  String get yourAnswer;

  String get recording;

  String get noTimeLimit;

  String get speakRelaxed;

  String get transcriptRealTime;

  String wordsAndSeconds(int words, int seconds);

  String get goodStartSituation;

  String get pause;

  String get finishAnswering;

  String get startAnswering;

  String get noAnswerRecorded;

  String get passFair;

  String get fail;

  String get interviewResults;

  String get interviewFinished;

  String get positionLabel;

  String get bandScore;

  String get passGood;

  String get goodJobReady;

  String get scoreDetails;

  String get starStructure;

  String get contentQuality;

  String get fluency;

  String get confidence;

  String get viewFullReport;

  String get listenToRecording;

  String get recommendations;

  String get basedOnPerformance;

  String get yourStrengths;

  String get areasForImprovement;

  String get selectedPractice;

  String get readyForInterview;

  String get practiceAgain;

  String get emailReport;

  String get dashboard;

  String get aiMessageOpening;

  String get transcriptToggleHint;

  String get startInterview;

  String get sampleQuestion1;

  String get sampleQuestion2;

  String get sampleQuestion3;

  String get sampleQuestion4;

  String get sampleQuestion5;

  String get hintStarDetail;

  String get followupQuestion;

  String get prevAnswerLabel;

  String get showFullAnswer;

  String get hideFullAnswer;

  String get followupHint;

  String get depthThinkingHint;

  String get interviewCompleted;

  String goodJobUser(Object name);

  String get analyzingAnswers;

  String get evaluatingStar;

  String get calculatingFluency;

  String get generatingRecommendations;

  String get generatingFeedbackProgress;

  String get estimateTime;

  String get totalDuration;

  String questionsAnswered(Object count);

  String get wordsSpoken;

  String get followups;

  String get yourQuestionsTitle;

  String get anyQuestionsPrompt;

  String get askInterviewer;

  String aiClosingMessage(Object name);

  String get excellentStructure;

  String get relevantDetailed;

  String get tooManyFillers;

  String get goodPaceTone;

  String get starAnalysis;

  String get fluencyAnalysis;

  String get speakingPace;

  String wordsPerMinute(Object wpm);

  String syllablesPerMinute(Object spm);

  String get speakingPaceChart;

  String get fillerWordsLabel;

  String totalFillerLabel(Object percentage);

  String get pauseAnalysis;

  String get improvedSpeechTitle;

  String get originalSpeechLabel;

  String get improvedSpeechLabel;

  String get listenImprovedVersion;

  String get proTips;

  String get yourProgress;

  String get trackingLast5Sessions;

  String get scoreHistory;

  String get metricComparison;

  String get overallScore;

  String get focusThisWeekFiller;

  String get milestonesReached;

  String get compareSessions;

  String get fullReport;

  String get fullReportTitle;

  String get strengthsLabel;

  String get improvementsLabel;

  String get selectedPracticeLabel;

  String get readinessAssessment;

  String get exportReport;

  String get compare;

  String get viewDetail;

  String get viewPracticeTips;

  String get fiveInterviewsCompleted;

  String get score75FirstTime;

  String get score80;

  String get tenInterviewsCompleted;

  String session(Object number);

  String get vs;

  String get downloadPdf;

  String get practiceQ1Filler;

  String get practiceQ1Button;

  String get practiceQ5Star;

  String get practiceQ5Button;

  String get practiceStrongResults;

  String get practiceTipsButton;

  String get readinessScoreMessage;

  String get readinessJuniorMid;

  String get readinessStartupEnv;

  String get readinessSeniorRoles;

  String get readinessStatusExcellent;

  String get readinessStatusGood;

  String get readinessStatusNeedsWork;

  String get readinessDescExcellent;

  String get readinessDescGood;

  String get readinessDescNeedsWork;

  String get generatingQuestions;

  String get interviewFocus;

  String get selectInterviewFocus;

  String get interviewFocusDesc;

  String get focusBehavioralTitle;

  String get focusBehavioralDesc;

  String get focusTechnicalTitle;

  String get focusTechnicalDesc;

  String get focusMixedTitle;

  String get focusMixedDesc;

  String get readyToStartDesc;

  String get uploadedFromDevice;

  String get errorTitle;

  String get unknownError;

  String get recordAgain;

  String get stop;

  String get replayQuestionTooltip;

  String get jdHintText;

  String get cvDefaultLabel;

  String questionsCountDynamic(Object count);

  String get industryTechnology;

  String get industryFinance;

  String get industryHealthcare;

  String get industryEducation;

  String get industryOther;

  String get selectDate;

  String get endDateError;

  String get credentialUrlHelper;

  String get skipStepPrompt;

  String get skillHint;

  String get skillTip;

  String get aiSuggestion;

  String get featureComingSoon;

  String get aiInspirationTitle;

  String get aiInspirationDesc;

  String get generateWithAi;

  String get summaryLabel;

  String get summaryHint;

  String get summaryTip;

  String get additionalHeader;

  String get additionalDesc;

  String get sectionLanguages;

  String get sectionVolunteer;

  String get sectionReferences;

  String get sectionInterests;

  String get hintLanguages;

  String get hintVolunteer;

  String get hintReferences;

  String get hintInterests;

  String get previewCV;

  String get yourNamePlaceholder;

  String get labelTechnicalSkills;

  String get labelSoftSkills;

  String cvSavedTo(Object path);

  String failedToGeneratePdf(Object error);

  String get noCvData;

  String get goBack;

  String get exitBuilderTitle;

  String get exitBuilderMessage;

  String get stay;

  String get exit;

  String get gpaLabel;

  String get sectionNotFound;

  String get invalidSectionType;

  String get addedCategories;

  String get addNewCategory;

  String get editCategory;

  String get categoryName;

  String get skillCategoryAdded;

  String get categoryRequired;

  String get skillsRequired;

  String get skillsHint;

  String get characters;

  String get deleteCategory;

  String deleteCategoryConfirmation(Object category);

  String get skillsOrganizationTips;

  String get skillsTip1;

  String get skillsTip2;

  String get skillsTip3;

  String get skillsTip4;

  String get projectExperience;

  String get courseCertification;

  String get otherSkills;

  String get briefProfile;

  String get selectSectionFormat;

  String get createSection;

  String get templateExperienceName;

  String get templateExperienceDesc;

  String get templateEducationName;

  String get templateEducationDesc;

  String get templateSkillsName;

  String get templateSkillsDesc;

  String get templateBulletName;

  String get templateBulletDesc;

  String get templateParagraphName;

  String get templateParagraphDesc;

  String get reorderSectionsDesc;

  String get templateExperienceNameLabel;

  String get templateEducationNameLabel;

  String get templateSkillsNameLabel;

  String get templateBulletNameLabel;

  String get templateParagraphNameLabel;

  String get noItems;

  String get addCategory;

  String get noCategories;

  String get addCategoryPrompt;

  String get deleteItem;

  String deleteItemConfirmation(Object title);

  String get employmentTypeLabel;

  String get employmentTypeFullTime;

  String get employmentTypePartTime;

  String get employmentTypeContract;

  String get employmentTypeFreelance;

  String get employmentTypeInternship;

  String entriesCount(Object count);

  String get startDate;

  String get endDate;

  String get currentlyActive;

  String get bulletPoints;

  String get addBulletPointHint;

  String get contentLabel;

  String get contentHint;

  String get titleRequired;

  String get categoryAndSkillsRequired;

  String get typeAndAddHint;

  String get editItem;

  String get addItem;

  String get formatExperience;

  String get formatEducation;

  String get formatSkills;

  String get formatBulletList;

  String get formatParagraph;

  String get saveAsDraft;

  String get cvSavedSuccess;

  String get downloadPdfUnavailable;

  String get requiredField;

  String get optionalField;

  String get present;

  String stepHeader(Object current, Object total);

  String get personalInfoHeader;

  String get personalInfoDesc;

  String get phoneNumber;

  String get linkedin;

  String get portfolio;

  String get location;

  String get autoFillHint;

  String get educationHistoryHeader;

  String get educationHistoryDesc;

  String get noEducationData;

  String get addEducationPrompt;

  String get addEducation;

  String get addAnotherEducation;

  String get editEducation;

  String get institutionName;

  String get major;

  String get degree;

  String get startYear;

  String get endYear;

  String get currentlyStudying;

  String get gpa;

  String get gpaOptional;

  String get organizationHistoryHeader;

  String get organizationHistoryDesc;

  String get noOrganizationData;

  String get addOrganization;

  String get editOrganization;

  String get organizationRole;

  String get organizationName;

  String get experienceHistoryHeader;

  String get experienceHistoryDesc;

  String get noExperienceData;

  String get addExperiencePrompt;

  String get addExperience;

  String get addAnotherExperience;

  String get editExperience;

  String get jobTitle;

  String get companyName;

  String get responsibilities;

  String get responsibilitiesHint;

  String get certificationHeader;

  String get certificationDesc;

  String get noCertificationData;

  String get addCertificationPrompt;

  String get addCertification;

  String get addAnotherCertification;

  String get editCertification;

  String get certificationName;

  String get issuingOrganization;

  String get issueDate;

  String get expirationDate;

  String get doesNotExpire;

  String get credentialId;

  String get credentialUrl;

  String get skillsHeader;

  String get skillsDesc;

  String get noSkillsData;

  String get addSkillPrompt;

  String get addSkill;

  String get addAnotherSkill;

  String get editSkill;

  String get skillName;

  String get skillLevel;

  String get levelBeginner;

  String get levelIntermediate;

  String get levelAdvanced;

  String get levelExpert;

  String get summaryHeader;

  String get summaryDesc;

  String get generatingSummary;

  String get summaryTips;

  String get sectionManagerTitle;

  String get sectionManagerDesc;

  String get sectionManagerTips;

  String get addCustomSection;

  String get deleteSection;

  String get deleteSectionConfirmation;

  String get noAdditionalData;

  String get addAdditional;

  String get addAnotherAdditional;

  String get editAdditional;

  String get sectionLabel;

  String get sectionLabelHint;

  String get sectionValue;

  String get sectionValueHint;

  String get saveAndFinish;

  String get phoneNoLeadingZero;

  String get phoneTooShort;

  String get yearTooHigh;

  String get yearStartAfterEnd;

  String get dateStartAfterEnd;

  String get editContent;

  String get editCustomSection;

  String get emptyCustomSection;

  String get templateLabel;

  String get previewLabel;

  String get addBulletPoint;

  String get invalidYearMin1945;

  String get stopInterviewTitle;

  String get stopInterviewDesc;

  String get recentInterviews;

  String get noInterviewHistory;

  String get sectionOrderVisibility;

  String get sectionOrderTip;

  String get jobDescSubtitle;

  String get filterAll;

  String get filterHigh;

  String get filterMedium;

  String get filterLow;

  String get retry;

  String get cobaLagi;

  String get uploadYourCv;

  String get cvAnalyzerSetupDesc;

  String get jobDescPasteHint;

  String get max5Pages;

  String get applyingSuggestions;

  String get overallAtsScore;

  String get noSuggestionsForFilter;

  String get originalText;

  String get dismiss;

  String get apply;

  String get undoApply;

  String get undoDismiss;

  String createCvFromSuggestions(Object count);

  String get createNewAtsCvTitle;

  String get createCvAtsConfirmationDesc;

  String get createNow;

  String get report;

  String get replayQuestion;

  String get processingAnswer;

  String get processing;

  String get companyNameHint;

  String get max5PagesInterview;

  String get profileInfo;

  String get errorSavingProfile;

  String loginError(Object error);

  String get buildYourCareer;

  String get cvSourceBuilder;

  String get cvSourceAtsConverter;

  String get cvSourceAnalyzer;
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
