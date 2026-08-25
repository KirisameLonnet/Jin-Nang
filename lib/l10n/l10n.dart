import 'package:flutter/material.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  bool get usesChinese => Localizations.localeOf(this).languageCode == 'zh';
}

String localizeAuthError(
  BuildContext context,
  String? serverMessage, {
  required bool isLogin,
}) {
  final l10n = context.l10n;
  return switch (serverMessage) {
    'Invalid credentials' => l10n.invalidCredentials,
    'Email and password are required' => l10n.emailPasswordRequired,
    'Invalid email address' => l10n.invalidEmail,
    'Password must be 8-128 characters' => l10n.passwordLength,
    'Display name must be 1-50 characters' => l10n.displayNameLength,
    'Email already registered' => l10n.emailRegistered,
    _ => isLogin ? l10n.loginFailed : l10n.registrationFailed,
  };
}

String localizeRank(BuildContext context, String value) {
  final l10n = context.l10n;
  return switch (value) {
    'Bronze' => l10n.bronze,
    'Silver' => l10n.silver,
    'Gold' => l10n.gold,
    'Platinum' => l10n.platinum,
    'Beginner' => l10n.beginner,
    'Elementary Learner' => l10n.elementaryLearner,
    'Intermediate Learner' => l10n.intermediateLearner,
    'Advanced Learner' => l10n.advancedLearner,
    'Learner' => l10n.learner,
    _ => value,
  };
}

String localizeSceneSubtitle(BuildContext context, String sceneName) {
  final l10n = context.l10n;
  return switch (sceneName.toLowerCase()) {
    'restaurant' => l10n.restaurantSubtitle,
    'supermarket' => l10n.supermarketSubtitle,
    'airport' => l10n.airportSubtitle,
    _ => l10n.loadFailed,
  };
}

String localizeDialogueSceneTitle(BuildContext context, String sceneName) {
  final l10n = context.l10n;
  return switch (sceneName.toLowerCase()) {
    'restaurant' => l10n.restaurantDialogueTitle,
    'supermarket' => l10n.supermarketDialogueTitle,
    'airport' => l10n.airportDialogueTitle,
    _ => sceneName,
  };
}
