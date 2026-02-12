// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Resummy App';

  @override
  String get welcomeMessage => 'Welcome to Resummy App';

  @override
  String get login => 'Login';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get logout => 'Logout';

  @override
  String get home => 'Home';

  @override
  String get cvTools => 'CV Tools';

  @override
  String get interview => 'Interview';

  @override
  String get history => 'History';

  @override
  String get profile => 'Profile';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get finish => 'Finish';

  @override
  String get question => 'Question';

  @override
  String get questions => 'Questions';

  @override
  String get previous => 'Previous';

  @override
  String get suggestion => 'Suggestion';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueText => 'Continue';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get welcomeToResummy => 'Welcome to Resummy';

  @override
  String get buildPerfectResumeWithAi => 'Build your perfect resume with AI';

  @override
  String get googleSignInComingSoon => 'Google Sign-In coming soon!';

  @override
  String get goToLanguageSelection => 'Go to Language Selection';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get letsBuildYourPerfectCareer => 'Let\'s build your perfect career';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get buildCv => 'Build CV';

  @override
  String get analyzeCv => 'Analyze CV';

  @override
  String get interviewPrep => 'Interview Prep';

  @override
  String get translateCv => 'Translate CV';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get viewAll => 'View All';

  @override
  String get cvAnalysisCompleted => 'CV Analysis Completed';

  @override
  String score(int score) {
    return 'Score: $score/100';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String daysAgo(int count) {
    return '$count day ago';
  }

  @override
  String get interviewPractice => 'Interview Practice';

  @override
  String get softwareEngineer => 'Software Engineer';

  @override
  String get notificationsComingSoon => 'Notifications coming soon!';

  @override
  String get cvAnalyzer => 'CV Analyzer';

  @override
  String get cvAnalyzerDesc => 'Get AI-powered feedback on your CV';

  @override
  String get cvBuilder => 'CV Builder';

  @override
  String get cvBuilderDesc => 'Build your CV step by step with AI assistance';

  @override
  String get cvTranslator => 'CV Translator';

  @override
  String get cvTranslatorDesc => 'Translate your CV to multiple languages';

  @override
  String get cvHistory => 'CV History';

  @override
  String get cvHistoryDesc => 'View and manage all your CVs';

  @override
  String get personalInfo => 'Personal Info';

  @override
  String get education => 'Education';

  @override
  String get experience => 'Experience';

  @override
  String get certification => 'Certification';

  @override
  String get skills => 'Skills';

  @override
  String get summary => 'Summary';

  @override
  String get additionalInfo => 'Additional Info';

  @override
  String get screenUnderConstruction => 'This screen is under construction';

  @override
  String get analysisDetail => 'Analysis Detail';

  @override
  String get detailedAnalysis => 'Detailed Analysis';

  @override
  String get analyzingCv => 'Analyzing CV...';

  @override
  String get aiInterviewPractice => 'AI Interview Practice';

  @override
  String get practiceInterviewWithAi =>
      'Practice interview with AI and get professional feedback';

  @override
  String get startNewInterview => 'Start New Interview';

  @override
  String get viewInterviewHistory => 'View Interview History';

  @override
  String setupInterviewStep(int step) {
    return 'Setup Interview - Step $step';
  }

  @override
  String get selectCv => 'Select CV';

  @override
  String get cvSoftwareEngineer => 'CV Software Engineer';

  @override
  String analyzedOnDate(String date, int score) {
    return 'Analyzed on $date • Score: $score';
  }

  @override
  String get interviewPracticeFrontend => 'Interview Practice: Frontend Dev';

  @override
  String completedOnDate(String date) {
    return 'Completed on $date';
  }

  @override
  String get moreHistoryWillAppear => 'More history will appear here';

  @override
  String get userName => 'User Name';

  @override
  String get userEmail => 'user@example.com';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkThemeEnabled => 'Dark theme enabled';

  @override
  String get lightThemeEnabled => 'Light theme enabled';

  @override
  String get language => 'Language';

  @override
  String get bahasaIndonesia => 'Bahasa Indonesia';

  @override
  String get confirmLogout => 'Are you sure you want to logout?';

  @override
  String stepProgress(int current, int total) {
    return 'Step $current/$total';
  }

  @override
  String get whatsYourFullName => 'What\'s your full name?';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get whatsYourCurrentStatus => 'What\'s your current status?';

  @override
  String get freshGraduate => 'Fresh Graduate';

  @override
  String get currentlyWorking => 'Currently Working';

  @override
  String get lookingForJob => 'Looking for Job';

  @override
  String get freelancer => 'Freelancer';

  @override
  String get whatsYourTargetRole => 'What\'s your target role?';

  @override
  String get targetRole => 'Target Role';

  @override
  String get targetRoleHint => 'e.g., Software Engineer, Product Manager';

  @override
  String get typeToSeeSuggestions => '💡 Type to see suggestions';

  @override
  String get whatsYourCareerGoal => 'What\'s your career goal?';

  @override
  String get careerGoal => 'Career Goal';

  @override
  String get careerGoalHint => 'Describe your career aspirations...';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get yourProfileIsReady => 'Your profile is ready!';

  @override
  String get status => 'Status';

  @override
  String get goal => 'Goal';

  @override
  String get startUsingApp => 'Start Using App';

  @override
  String get cvBuilderWelcomeTitle => 'Create Professional CV';

  @override
  String get cvBuilderWelcomeDesc =>
      'We will guide you step by step to create an attractive CV';

  @override
  String get startCreatingCv => 'Start Creating CV';

  @override
  String get uploadCv => 'Upload CV';

  @override
  String get chooseCvSource => 'Choose your CV source';

  @override
  String get uploadNewCv => 'Upload New CV';

  @override
  String get uploadCvFileHint => 'Upload PDF file (Max 5MB)';

  @override
  String get or => 'or';

  @override
  String get useExistingCv => 'Use Existing CV';

  @override
  String get savedCvs => 'Saved CVs';

  @override
  String cvNumber(int number) {
    return 'CV $number';
  }

  @override
  String createdOnDate(String date) {
    return 'Created on $date';
  }

  @override
  String get appliedPosition => 'Applied Position';

  @override
  String get optional => 'Optional';

  @override
  String get startAnalysis => 'Start Analysis';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get analyzingCvPleaseWait => 'Analyzing CV, please wait...';

  @override
  String get processingCv => 'Processing your CV, please wait...';

  @override
  String get analysisResult => 'Analysis Result';

  @override
  String get yourCvScore => 'Your CV Score';

  @override
  String get detailScore => 'Score Details';

  @override
  String get keywordMatch => 'Keyword Match';

  @override
  String get quantifiableAchievements => 'Quantifiable Achievements';

  @override
  String get structureCompleteness => 'Structure Completeness';

  @override
  String get languageProfessionalism => 'Language Professionalism';

  @override
  String get missingKeywords => 'Missing Keywords';

  @override
  String get improvementSuggestions => 'Improvement Suggestions';

  @override
  String get summaryFeedback => 'Summary Feedback';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get aiInterviewSimulator => 'AI Interview Simulator';

  @override
  String get setupStep1Desc =>
      'Practice interview with AI tailored to your CV and role';

  @override
  String get formatInterview => 'Interview Format:';

  @override
  String get durationAprox => 'Duration: ±15 minutes';

  @override
  String get questionsCount => 'Questions: 5 questions';

  @override
  String get languageOption => 'Language: ID / EN';

  @override
  String get methodStar => 'Method: STAR-based';

  @override
  String get step1SelectCv => 'Step 1: Select your CV';

  @override
  String get setupInterview => 'Setup Interview';

  @override
  String get appliedPositionLabel => 'Applied Position: *';

  @override
  String get companyNameLabel => 'Company Name: (Optional)';

  @override
  String get positionLevelLabel => 'Position Level:';

  @override
  String get industryLabel => 'Industry:';

  @override
  String get autoFillFromProfile => 'Auto-fill from your profile';

  @override
  String get dataHelpsAiTailor =>
      'This data helps AI tailor interview questions with relevant context';

  @override
  String get juniorLevel => 'Junior (0-2 years)';

  @override
  String get midLevel => 'Mid-level (3-5 years)';

  @override
  String get seniorLevel => 'Senior (5+ years)';

  @override
  String get jobDescription => 'Job Description';

  @override
  String get step3PasteJd => 'Step 3: Paste Job Description';

  @override
  String get jdDetailHelpsAi =>
      'The more detailed the JD, the more accurate the AI interview questions';

  @override
  String get pasteJobDescriptionLabel => 'Paste Job Description:';

  @override
  String get extractKeyRequirements => 'Extract Key Requirements';

  @override
  String get extractedRequirements => 'Extracted Requirements:';

  @override
  String get noJdQuestion => 'Don\'t have a JD?';

  @override
  String get skipThisStep => 'Skip this step →';

  @override
  String get setupComplete => 'Setup Complete';

  @override
  String get readyToStartInterview => 'Ready to start the interview';

  @override
  String get interviewSummary => 'Interview Summary:';

  @override
  String get cvLabel => 'CV:';

  @override
  String get roleLabel => 'Role:';

  @override
  String get companyLabel => 'Company:';

  @override
  String get languageLabel => 'Language:';

  @override
  String get questionsLabel => 'Questions:';

  @override
  String get durationLabel => 'Duration:';

  @override
  String get starMethodGuide => 'STAR Method Guide';

  @override
  String get viewStarExample => 'View STAR Method Example →';

  @override
  String get starTips =>
      'Tips: Give specific and measurable answers. Use numbers and concrete results to strengthen your story.';

  @override
  String get startInterviewNow => 'Start Interview Now! →';

  @override
  String get interviewStarted => 'Interview Started';

  @override
  String get tapToAnswer => 'Tap to Answer';

  @override
  String get toggleText => 'Toggle Text:';

  @override
  String get on => 'ON 🟢';

  @override
  String get off => 'OFF ⚪';

  @override
  String get exitInterviewTitle => 'Exit Interview?';

  @override
  String get exitInterviewContent => 'Progress will be lost if you exit now.';

  @override
  String get continueInterview => 'Continue Interview';

  @override
  String get exitYes => 'Yes, Exit';

  @override
  String questionXofY(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get behavioralStar => 'Behavioral (STAR)';

  @override
  String get aiInterviewer => 'AI Interviewer:';

  @override
  String get hintStarMethod => 'Hint: Use STAR method';

  @override
  String get yourAnswer => 'Your Answer';

  @override
  String get recording => 'Recording...';

  @override
  String get noTimeLimit => 'No time limit';

  @override
  String get speakRelaxed => '💬 Speak naturally';

  @override
  String get transcriptRealTime => 'Transcript (Real-time):';

  @override
  String wordsAndSeconds(int words, int seconds) {
    return '~$words words • ${seconds}s';
  }

  @override
  String get goodStartSituation => 'Good: You started with Situation!';

  @override
  String get pause => 'Pause';

  @override
  String get finishAnswering => 'Finish Answering';

  @override
  String get startAnswering => 'Start Answering';

  @override
  String get interviewResults => 'Interview Results';

  @override
  String get interviewFinished => 'Interview Finished!';

  @override
  String get positionLabel => 'Position:';

  @override
  String get bandScore => 'Band Score';

  @override
  String get passGood => 'Good Pass';

  @override
  String get goodJobReady =>
      'Great job! You are ready for the real interview 🎉';

  @override
  String get scoreDetails => 'Score Details';

  @override
  String get starStructure => 'STAR Structure';

  @override
  String get contentQuality => 'Content Quality';

  @override
  String get fluency => 'Fluency';

  @override
  String get confidence => 'Confidence';

  @override
  String get viewFullReport => 'View Full Report';

  @override
  String get listenToRecording => 'Listen to Your Recording';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get basedOnPerformance => 'Based on your interview performance';

  @override
  String get yourStrengths => 'Your Strengths';

  @override
  String get areasForImprovement => 'Areas for Improvement';

  @override
  String get selectedPractice => 'Selected Practice';

  @override
  String get readyForInterview => 'Ready for Interview?';

  @override
  String get practiceAgain => 'Practice Again';

  @override
  String get emailReport => 'Email Report';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get aiMessageOpening =>
      'Good morning! I\'m Maya, HR from PT Tech Startup Indonesia. Thank you for taking the time for the interview today.';

  @override
  String get transcriptToggleHint => 'Toggle text to show/hide transcript';

  @override
  String get startInterview => 'Start Interview';

  @override
  String get sampleQuestion1 =>
      'Tell me about a time you led a challenging project and how you handled it.';

  @override
  String get sampleQuestion2 => 'How do you handle conflict with coworkers?';

  @override
  String get sampleQuestion3 =>
      'Tell me about your biggest failure and what you learned.';

  @override
  String get sampleQuestion4 =>
      'How do you prioritize tasks when deadlines are tight?';

  @override
  String get sampleQuestion5 =>
      'Why are you interested in working for our company?';

  @override
  String get hintStarDetail =>
      'S: Describe the situation\nT: Your task\nA: Action taken\nR: Measurable results';

  @override
  String get followupQuestion => 'Follow-up Question';

  @override
  String get prevAnswerLabel => 'Your Answer:';

  @override
  String get showFullAnswer => 'View full answer ▼';

  @override
  String get hideFullAnswer => 'Hide ▲';

  @override
  String get followupHint =>
      'AI asks for more detail. Focus on specific challenges and your decision-making process.';

  @override
  String get depthThinkingHint =>
      'Follow-up questions help AI understand your depth and critical thinking';

  @override
  String get interviewCompleted => 'Interview Completed!';

  @override
  String goodJobUser(Object name) {
    return 'Good job, $name!';
  }

  @override
  String get analyzingAnswers => 'Analyzing answers';

  @override
  String get evaluatingStar => 'Evaluating STAR structure';

  @override
  String get calculatingFluency => 'Calculating fluency score';

  @override
  String get generatingRecommendations => 'Generating recommendations';

  @override
  String get generatingFeedbackProgress => 'Generating feedback...';

  @override
  String get estimateTime => 'Estimate: 15-20 seconds';

  @override
  String get totalDuration => 'Total Duration';

  @override
  String questionsAnswered(Object count) {
    return '$count answered';
  }

  @override
  String get wordsSpoken => 'Words spoken';

  @override
  String get followups => 'Follow-ups';

  @override
  String get yourQuestionsTitle => 'Your Questions';

  @override
  String get anyQuestionsPrompt =>
      'Do you have any questions for the interviewer?';

  @override
  String get askInterviewer => 'Ask Interviewer';

  @override
  String aiClosingMessage(Object name) {
    return 'Thank you very much, $name. You will receive detailed feedback in a moment.';
  }

  @override
  String get excellentStructure => 'Excellent structure';

  @override
  String get relevantDetailed => 'Relevant & detailed';

  @override
  String get tooManyFillers => 'Too many fillers';

  @override
  String get goodPaceTone => 'Good pace & tone';

  @override
  String get starAnalysis => 'STAR Structure Analysis';

  @override
  String get fluencyAnalysis => 'Fluency Analysis';

  @override
  String get speakingPace => 'Speaking Pace';

  @override
  String wordsPerMinute(Object wpm) {
    return 'Words per minute: $wpm WPM';
  }

  @override
  String syllablesPerMinute(Object spm) {
    return 'Syllables/minute: $spm SPM';
  }

  @override
  String get speakingPaceChart => 'Speaking Pace Over Time:';

  @override
  String get fillerWordsLabel => 'Filler Words';

  @override
  String totalFillerLabel(Object percentage) {
    return 'Total filler → $percentage% (Target: <5%)';
  }

  @override
  String get pauseAnalysis => 'Pauses & Hesitations';

  @override
  String get improvedSpeechTitle => '✨ Your Speech vs Improved Speech';

  @override
  String get originalSpeechLabel => 'Your Original Speech';

  @override
  String get improvedSpeechLabel => 'Improved Speech';

  @override
  String get listenImprovedVersion => 'Listen to Improved Version';

  @override
  String get proTips => 'Pro Tips:';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get trackingLast5Sessions => 'Tracking last 5 sessions';

  @override
  String get scoreHistory => 'Interview Score History';

  @override
  String get metricComparison => 'Metric Comparison';

  @override
  String get overallScore => 'Overall Score';

  @override
  String get focusThisWeekFiller => 'This Week\'s Focus: Reduce Fillers!';

  @override
  String get milestonesReached => 'Milestones Reached';

  @override
  String get compareSessions => 'Compare Sessions';

  @override
  String get fullReport => 'Full Report';

  @override
  String get fullReportTitle => 'Full Interview Report';

  @override
  String get strengthsLabel => 'Your Strengths';

  @override
  String get improvementsLabel => 'Areas for Improvement';

  @override
  String get selectedPracticeLabel => 'Selected Practice';

  @override
  String get readinessAssessment => 'Ready for Interview?';

  @override
  String get exportReport => 'Export Progress Report';

  @override
  String get compare => 'Compare';

  @override
  String get viewDetail => 'View Detail →';

  @override
  String get viewPracticeTips => 'View Practice Tips';

  @override
  String get fiveInterviewsCompleted => '5 Interviews\nCompleted';

  @override
  String get score75FirstTime => 'Score 7.5+\nFirst Time';

  @override
  String get score80 => 'Score 8.0+';

  @override
  String get tenInterviewsCompleted => '10 Interviews\nCompleted';

  @override
  String session(Object number) {
    return 'Session #$number';
  }

  @override
  String get vs => 'vs';

  @override
  String get downloadPdf => 'Download PDF Report';

  @override
  String get practiceQ1Filler => 'Repeat Q1 focusing on removing fillers';

  @override
  String get practiceQ1Button => 'Practice Q1 →';

  @override
  String get practiceQ5Star => 'Practice Q5 with better STAR structure';

  @override
  String get practiceQ5Button => 'Practice Q5 →';

  @override
  String get practiceStrongResults => 'Prepare 3 strong Result stories';

  @override
  String get practiceTipsButton => 'Study Tips →';

  @override
  String get readinessScoreMessage => 'Based on 7.5/10 score, you are READY:';

  @override
  String get readinessJuniorMid => '✓ Junior-Mid level positions';

  @override
  String get readinessStartupEnv => '✓ Startup environment (fast-paced)';

  @override
  String get readinessSeniorRoles =>
      '⚠️ Senior roles - add more metrics & impact';
}
