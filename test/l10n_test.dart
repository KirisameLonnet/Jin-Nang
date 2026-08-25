import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test1/features/auth/login_screen.dart';
import 'package:test1/l10n/l10n.dart';

Widget _localizedLogin(Locale locale) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: const LoginScreen(),
  );
}

void main() {
  testWidgets('login UI follows the selected English locale', (tester) async {
    await tester.pumpWidget(_localizedLogin(const Locale('en')));

    expect(find.text('Welcome\nBack'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('登录'), findsNothing);
  });

  testWidgets('login UI follows the selected Simplified Chinese locale', (
    tester,
  ) async {
    await tester.pumpWidget(_localizedLogin(const Locale('zh')));

    expect(find.text('欢迎\n回来'), findsOneWidget);
    expect(find.text('登录'), findsOneWidget);
    expect(find.text('Sign In'), findsNothing);
  });
}
