import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Jin Nang'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'LOADING...'**
  String get loading;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome\nBack'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue learning.'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @emailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required.'**
  String get emailPasswordRequired;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create\nAccount'**
  String get createAccountTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your Chinese learning journey.'**
  String get registerSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creatingAccount;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get hasAccount;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get registrationFailed;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8–128 characters.'**
  String get passwordLength;

  /// No description provided for @displayNameLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be 1–50 characters.'**
  String get displayNameLength;

  /// No description provided for @emailRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailRegistered;

  /// No description provided for @studyTab.
  ///
  /// In en, this message translates to:
  /// **'STUDY'**
  String get studyTab;

  /// No description provided for @toolboxTab.
  ///
  /// In en, this message translates to:
  /// **'TOOLBOX'**
  String get toolboxTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'MY'**
  String get profileTab;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Yo! {name}'**
  String greeting(String name);

  /// No description provided for @readyToLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Ready to\nLevel Up?'**
  String get readyToLevelUp;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get streak;

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String dayCount(int count);

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'RANK'**
  String get rank;

  /// No description provided for @missions.
  ///
  /// In en, this message translates to:
  /// **'MISSIONS'**
  String get missions;

  /// No description provided for @vocabLearning.
  ///
  /// In en, this message translates to:
  /// **'Vocab\nLearning'**
  String get vocabLearning;

  /// No description provided for @vocabLearningSingleLine.
  ///
  /// In en, this message translates to:
  /// **'Vocab Learning'**
  String get vocabLearningSingleLine;

  /// No description provided for @wordsLearned.
  ///
  /// In en, this message translates to:
  /// **'{count} words learned'**
  String wordsLearned(int count);

  /// No description provided for @dialoguePractice.
  ///
  /// In en, this message translates to:
  /// **'Dialogue\nPractice'**
  String get dialoguePractice;

  /// No description provided for @dialoguePracticeSingleLine.
  ///
  /// In en, this message translates to:
  /// **'Dialogue Practice'**
  String get dialoguePracticeSingleLine;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count} mins'**
  String minutes(int count);

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon.'**
  String get featureComingSoon;

  /// No description provided for @selectScene.
  ///
  /// In en, this message translates to:
  /// **'Select a scene'**
  String get selectScene;

  /// No description provided for @sceneComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This scene is coming soon.'**
  String get sceneComingSoon;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this content. Please try again.'**
  String get loadFailed;

  /// No description provided for @restaurantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Master ordering food and drinks.'**
  String get restaurantSubtitle;

  /// No description provided for @supermarketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping lists and checkout.'**
  String get supermarketSubtitle;

  /// No description provided for @airportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in, boarding and more.'**
  String get airportSubtitle;

  /// No description provided for @restaurantDialogueTitle.
  ///
  /// In en, this message translates to:
  /// **'Ordering at a Restaurant'**
  String get restaurantDialogueTitle;

  /// No description provided for @supermarketDialogueTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping at a Supermarket'**
  String get supermarketDialogueTitle;

  /// No description provided for @airportDialogueTitle.
  ///
  /// In en, this message translates to:
  /// **'At the Airport'**
  String get airportDialogueTitle;

  /// No description provided for @toolboxTitle.
  ///
  /// In en, this message translates to:
  /// **'TOOLBOX'**
  String get toolboxTitle;

  /// No description provided for @toolboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Useful phrases for real life.'**
  String get toolboxSubtitle;

  /// No description provided for @usefulPhrases.
  ///
  /// In en, this message translates to:
  /// **'Useful Phrases'**
  String get usefulPhrases;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}'**
  String chapter(int number);

  /// No description provided for @sentenceCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sentences'**
  String sentenceCount(int count);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @exampleSentence.
  ///
  /// In en, this message translates to:
  /// **'Example sentence'**
  String get exampleSentence;

  /// No description provided for @associatedWords.
  ///
  /// In en, this message translates to:
  /// **'Associated'**
  String get associatedWords;

  /// No description provided for @phrases.
  ///
  /// In en, this message translates to:
  /// **'Phrases'**
  String get phrases;

  /// No description provided for @synonyms.
  ///
  /// In en, this message translates to:
  /// **'Synonyms'**
  String get synonyms;

  /// No description provided for @antonyms.
  ///
  /// In en, this message translates to:
  /// **'Antonyms'**
  String get antonyms;

  /// No description provided for @expandedWords.
  ///
  /// In en, this message translates to:
  /// **'Related words'**
  String get expandedWords;

  /// No description provided for @learnTheseWords.
  ///
  /// In en, this message translates to:
  /// **'Let\'s learn these words first'**
  String get learnTheseWords;

  /// No description provided for @cardsLearned.
  ///
  /// In en, this message translates to:
  /// **'Tap cards to learn ({learned}/{total})'**
  String cardsLearned(int learned, int total);

  /// No description provided for @startPractice.
  ///
  /// In en, this message translates to:
  /// **'All done — start practice →'**
  String get startPractice;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'MY PROFILE'**
  String get myProfile;

  /// No description provided for @rankLabel.
  ///
  /// In en, this message translates to:
  /// **'{rank} Rank'**
  String rankLabel(String rank);

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get dayStreak;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Avg Score'**
  String get averageScore;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaq;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon.'**
  String get comingSoon;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get language;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @simplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// No description provided for @languageBadgeEnglish.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageBadgeEnglish;

  /// No description provided for @languageBadgeChinese.
  ///
  /// In en, this message translates to:
  /// **'中'**
  String get languageBadgeChinese;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'{count} PTS'**
  String points(int count);

  /// No description provided for @rewardPoints.
  ///
  /// In en, this message translates to:
  /// **'+{count} PTS'**
  String rewardPoints(int count);

  /// No description provided for @starCount.
  ///
  /// In en, this message translates to:
  /// **'×{count}'**
  String starCount(int count);

  /// No description provided for @exampleSentencePinyin.
  ///
  /// In en, this message translates to:
  /// **'Lìjù'**
  String get exampleSentencePinyin;

  /// No description provided for @bronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get bronze;

  /// No description provided for @silver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get silver;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @platinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get platinum;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @elementaryLearner.
  ///
  /// In en, this message translates to:
  /// **'Elementary Learner'**
  String get elementaryLearner;

  /// No description provided for @intermediateLearner.
  ///
  /// In en, this message translates to:
  /// **'Intermediate Learner'**
  String get intermediateLearner;

  /// No description provided for @advancedLearner.
  ///
  /// In en, this message translates to:
  /// **'Advanced Learner'**
  String get advancedLearner;

  /// No description provided for @learner.
  ///
  /// In en, this message translates to:
  /// **'Learner'**
  String get learner;

  /// No description provided for @levelNumber.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {number} / 4'**
  String levelNumber(int number);

  /// No description provided for @levelTitle.
  ///
  /// In en, this message translates to:
  /// **'Level {number}: {title}'**
  String levelTitle(int number, String title);

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @passProgress.
  ///
  /// In en, this message translates to:
  /// **'Passed: {correct}/{total}'**
  String passProgress(int correct, int total);

  /// No description provided for @completePreviousLevel.
  ///
  /// In en, this message translates to:
  /// **'Complete the previous level first.'**
  String get completePreviousLevel;

  /// No description provided for @questModule.
  ///
  /// In en, this message translates to:
  /// **'{scene} QUEST MODULE'**
  String questModule(String scene);

  /// No description provided for @questRewardHint.
  ///
  /// In en, this message translates to:
  /// **'Complete challenges to earn stars and points!'**
  String get questRewardHint;

  /// No description provided for @vocabMatch.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Match'**
  String get vocabMatch;

  /// No description provided for @listeningChoice.
  ///
  /// In en, this message translates to:
  /// **'Listening Choice'**
  String get listeningChoice;

  /// No description provided for @blankFilling.
  ///
  /// In en, this message translates to:
  /// **'Blank Filling'**
  String get blankFilling;

  /// No description provided for @rolePlay.
  ///
  /// In en, this message translates to:
  /// **'Ordering Role Play'**
  String get rolePlay;

  /// No description provided for @vocabMatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Recognize form and meaning: choose the correct English meaning or match the Chinese word.'**
  String get vocabMatchDescription;

  /// No description provided for @listeningChoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Listen and choose the matching Chinese word.'**
  String get listeningChoiceDescription;

  /// No description provided for @blankFillingDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the best word to complete the restaurant dialogue.'**
  String get blankFillingDescription;

  /// No description provided for @rolePlayDescription.
  ///
  /// In en, this message translates to:
  /// **'Practice a Chinese conversation with a server in a realistic restaurant scenario.'**
  String get rolePlayDescription;

  /// No description provided for @unlockNextLevelDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete the questions to unlock the next level.'**
  String get unlockNextLevelDescription;

  /// No description provided for @playPinyinAudio.
  ///
  /// In en, this message translates to:
  /// **'Play the pronunciation audio'**
  String get playPinyinAudio;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correctAnswer;

  /// No description provided for @incorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrectAnswer;

  /// No description provided for @seeResults.
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get seeResults;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @submitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get submitAnswer;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'SCORE'**
  String get score;

  /// No description provided for @levelPassed.
  ///
  /// In en, this message translates to:
  /// **'Congratulations, you passed!'**
  String get levelPassed;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again!'**
  String get tryAgain;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @returnToLevels.
  ///
  /// In en, this message translates to:
  /// **'Return to Levels'**
  String get returnToLevels;

  /// No description provided for @retryLevel.
  ///
  /// In en, this message translates to:
  /// **'Retry Level'**
  String get retryLevel;

  /// No description provided for @challengePassed.
  ///
  /// In en, this message translates to:
  /// **'Challenge complete!'**
  String get challengePassed;

  /// No description provided for @challengeFailed.
  ///
  /// In en, this message translates to:
  /// **'Not passed'**
  String get challengeFailed;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @dialogueReview.
  ///
  /// In en, this message translates to:
  /// **'Dialogue Review'**
  String get dialogueReview;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
