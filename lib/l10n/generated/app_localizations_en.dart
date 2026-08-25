// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Jin Nang';

  @override
  String get loading => 'LOADING...';

  @override
  String get welcomeBack => 'Welcome\nBack';

  @override
  String get signInSubtitle => 'Sign in to continue learning.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get signIn => 'Sign In';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get signUp => 'Sign Up';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get loginFailed => 'Login failed. Please try again.';

  @override
  String get invalidCredentials => 'Incorrect email or password.';

  @override
  String get emailPasswordRequired => 'Email and password are required.';

  @override
  String get createAccountTitle => 'Create\nAccount';

  @override
  String get registerSubtitle => 'Start your Chinese learning journey.';

  @override
  String get createAccount => 'Create Account';

  @override
  String get creatingAccount => 'Creating...';

  @override
  String get hasAccount => 'Already have an account? ';

  @override
  String get registrationFailed => 'Registration failed. Please try again.';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get passwordLength => 'Password must be 8–128 characters.';

  @override
  String get displayNameLength => 'Name must be 1–50 characters.';

  @override
  String get emailRegistered => 'This email is already registered.';

  @override
  String get studyTab => 'STUDY';

  @override
  String get toolboxTab => 'TOOLBOX';

  @override
  String get profileTab => 'MY';

  @override
  String greeting(String name) {
    return 'Yo! $name';
  }

  @override
  String get readyToLevelUp => 'Ready to\nLevel Up?';

  @override
  String get streak => 'STREAK';

  @override
  String dayCount(int count) {
    return '$count Days';
  }

  @override
  String get rank => 'RANK';

  @override
  String get missions => 'MISSIONS';

  @override
  String get vocabLearning => 'Vocab\nLearning';

  @override
  String get vocabLearningSingleLine => 'Vocab Learning';

  @override
  String wordsLearned(int count) {
    return '$count words learned';
  }

  @override
  String get dialoguePractice => 'Dialogue\nPractice';

  @override
  String get dialoguePracticeSingleLine => 'Dialogue Practice';

  @override
  String minutes(int count) {
    return '$count mins';
  }

  @override
  String get featureComingSoon => 'This feature is coming soon.';

  @override
  String get selectScene => 'Select a scene';

  @override
  String get sceneComingSoon => 'This scene is coming soon.';

  @override
  String get loadFailed => 'Couldn\'t load this content. Please try again.';

  @override
  String get restaurantSubtitle => 'Master ordering food and drinks.';

  @override
  String get supermarketSubtitle => 'Shopping lists and checkout.';

  @override
  String get airportSubtitle => 'Check-in, boarding and more.';

  @override
  String get restaurantDialogueTitle => 'Ordering at a Restaurant';

  @override
  String get supermarketDialogueTitle => 'Shopping at a Supermarket';

  @override
  String get airportDialogueTitle => 'At the Airport';

  @override
  String get toolboxTitle => 'TOOLBOX';

  @override
  String get toolboxSubtitle => 'Useful phrases for real life.';

  @override
  String get usefulPhrases => 'Useful Phrases';

  @override
  String get retry => 'Retry';

  @override
  String chapter(int number) {
    return 'Chapter $number';
  }

  @override
  String sentenceCount(int count) {
    return '$count sentences';
  }

  @override
  String get previous => 'Prev';

  @override
  String get next => 'Next';

  @override
  String get finish => 'Finish';

  @override
  String get start => 'START';

  @override
  String get replay => 'Replay';

  @override
  String get review => 'Review';

  @override
  String get none => 'None';

  @override
  String get exampleSentence => 'Example sentence';

  @override
  String get associatedWords => 'Associated';

  @override
  String get phrases => 'Phrases';

  @override
  String get synonyms => 'Synonyms';

  @override
  String get antonyms => 'Antonyms';

  @override
  String get expandedWords => 'Related words';

  @override
  String get learnTheseWords => 'Let\'s learn these words first';

  @override
  String cardsLearned(int learned, int total) {
    return 'Tap cards to learn ($learned/$total)';
  }

  @override
  String get startPractice => 'All done — start practice →';

  @override
  String get myProfile => 'MY PROFILE';

  @override
  String rankLabel(String rank) {
    return '$rank Rank';
  }

  @override
  String get dayStreak => 'Day Streak';

  @override
  String get words => 'Words';

  @override
  String get averageScore => 'Avg Score';

  @override
  String get settings => 'SETTINGS';

  @override
  String get notifications => 'Notifications';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get helpFaq => 'Help & FAQ';

  @override
  String get logOut => 'Log Out';

  @override
  String get comingSoon => 'Coming soon.';

  @override
  String get language => 'App language';

  @override
  String get followSystem => 'Follow system';

  @override
  String get english => 'English';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get languageBadgeEnglish => 'EN';

  @override
  String get languageBadgeChinese => '中';

  @override
  String points(int count) {
    return '$count PTS';
  }

  @override
  String rewardPoints(int count) {
    return '+$count PTS';
  }

  @override
  String starCount(int count) {
    return '×$count';
  }

  @override
  String get exampleSentencePinyin => 'Lìjù';

  @override
  String get bronze => 'Bronze';

  @override
  String get silver => 'Silver';

  @override
  String get gold => 'Gold';

  @override
  String get platinum => 'Platinum';

  @override
  String get beginner => 'Beginner';

  @override
  String get elementaryLearner => 'Elementary Learner';

  @override
  String get intermediateLearner => 'Intermediate Learner';

  @override
  String get advancedLearner => 'Advanced Learner';

  @override
  String get learner => 'Learner';

  @override
  String levelNumber(int number) {
    return 'LEVEL $number / 4';
  }

  @override
  String levelTitle(int number, String title) {
    return 'Level $number: $title';
  }

  @override
  String get passed => 'Passed';

  @override
  String get locked => 'Locked';

  @override
  String passProgress(int correct, int total) {
    return 'Passed: $correct/$total';
  }

  @override
  String get completePreviousLevel => 'Complete the previous level first.';

  @override
  String questModule(String scene) {
    return '$scene QUEST MODULE';
  }

  @override
  String get questRewardHint => 'Complete challenges to earn stars and points!';

  @override
  String get vocabMatch => 'Vocabulary Match';

  @override
  String get listeningChoice => 'Listening Choice';

  @override
  String get blankFilling => 'Blank Filling';

  @override
  String get rolePlay => 'Ordering Role Play';

  @override
  String get vocabMatchDescription =>
      'Recognize form and meaning: choose the correct English meaning or match the Chinese word.';

  @override
  String get listeningChoiceDescription =>
      'Listen and choose the matching Chinese word.';

  @override
  String get blankFillingDescription =>
      'Choose the best word to complete the restaurant dialogue.';

  @override
  String get rolePlayDescription =>
      'Practice a Chinese conversation with a server in a realistic restaurant scenario.';

  @override
  String get unlockNextLevelDescription =>
      'Complete the questions to unlock the next level.';

  @override
  String get playPinyinAudio => 'Play the pronunciation audio';

  @override
  String get correctAnswer => 'Correct';

  @override
  String get incorrectAnswer => 'Incorrect';

  @override
  String get seeResults => 'See Results';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get submitAnswer => 'Submit Answer';

  @override
  String get summary => 'Summary';

  @override
  String get score => 'SCORE';

  @override
  String get levelPassed => 'Congratulations, you passed!';

  @override
  String get tryAgain => 'Try again!';

  @override
  String get rewards => 'Rewards';

  @override
  String get returnToLevels => 'Return to Levels';

  @override
  String get retryLevel => 'Retry Level';

  @override
  String get challengePassed => 'Challenge complete!';

  @override
  String get challengeFailed => 'Not passed';

  @override
  String get done => 'Done';

  @override
  String get dialogueReview => 'Dialogue Review';
}
