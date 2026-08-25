import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'core/di.dart';
import 'l10n/l10n.dart';
import 'theme/app_theme.dart';
import 'features/shell/main_shell.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/toolbox/toolbox_screen.dart';
import 'features/toolbox/toolbox_scene_screen.dart';
import 'features/toolbox/toolbox_card.dart';
import 'features/toolbox/toolbox_chapter_screen.dart';
import 'features/profile/profile_screen.dart';
import 'core/models/phrase.dart';
import 'features/home/vocab_learning/vocab_scene_screen.dart';
import 'features/home/vocab_learning/vocab_learning_screen.dart';
import 'features/home/dialogue/dialogue_scene_screen.dart';
import 'features/home/dialogue/dialogue_practice_screen.dart';
import 'features/home/dialogue/level_screen.dart';
import 'features/home/dialogue/review_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Di.localeController.load();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  Di.router = _router;
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorStudyKey = GlobalKey<NavigatorState>(debugLabel: 'study');
final _shellNavigatorToolboxKey = GlobalKey<NavigatorState>(
  debugLabel: 'toolbox',
);
final _shellNavigatorMeKey = GlobalKey<NavigatorState>(debugLabel: 'me');

CustomTransitionPage<T> _slidePage<T>({required Widget child}) {
  return CustomTransitionPage<T>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final position = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curvedAnimation);

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(position: position, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );
}

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _slidePage(child: const LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          _slidePage(child: const RegisterScreen()),
    ),

    // Sub-pages (no bottom tab) — declared first so they match before the shell
    GoRoute(
      path: '/study/vocab-scene',
      pageBuilder: (context, state) =>
          _slidePage(child: const VocabSceneScreen()),
    ),
    GoRoute(
      path: '/study/vocab-battle/:sceneId',
      pageBuilder: (context, state) {
        final sceneId = int.parse(state.pathParameters['sceneId']!);
        return _slidePage(child: ToolboxCard(sceneId: sceneId));
      },
    ),
    GoRoute(
      path: '/study/vocab-learning/:sceneId',
      pageBuilder: (context, state) {
        final sceneId = int.parse(state.pathParameters['sceneId']!);
        return _slidePage(child: VocabLearningScreen(sceneId: sceneId));
      },
    ),
    GoRoute(
      path: '/study/dialogue-scene',
      pageBuilder: (context, state) =>
          _slidePage(child: const DialogueSceneScreen()),
    ),
    GoRoute(
      path: '/study/dialogue-practice/:sceneId',
      pageBuilder: (context, state) {
        final sceneId = int.parse(state.pathParameters['sceneId']!);
        final sceneName =
            state.uri.queryParameters['sceneName'] ?? context.l10n.selectScene;
        final sceneNameZh =
            state.uri.queryParameters['sceneNameZh'] ?? sceneName;
        return _slidePage(
          child: DialoguePracticeScreen(
            sceneId: sceneId,
            sceneName: sceneName,
            sceneNameZh: sceneNameZh,
          ),
        );
      },
    ),
    GoRoute(
      path: '/study/level/:levelId/review',
      pageBuilder: (context, state) {
        final levelId = int.parse(state.pathParameters['levelId']!);
        final sceneId = int.parse(state.uri.queryParameters['sceneId'] ?? '1');
        return _slidePage(
          child: ReviewScreen(levelId: levelId, sceneId: sceneId),
        );
      },
    ),
    GoRoute(
      path: '/study/level/:levelId',
      pageBuilder: (context, state) {
        final levelId = int.parse(state.pathParameters['levelId']!);
        final sceneId = int.parse(state.uri.queryParameters['sceneId'] ?? '1');
        return _slidePage(
          child: LevelScreen(levelId: levelId, sceneId: sceneId),
        );
      },
    ),
    // Toolbox sub-pages
    GoRoute(
      path: '/toolbox/:sceneId',
      pageBuilder: (context, state) {
        final sceneId = int.parse(state.pathParameters['sceneId']!);
        return _slidePage(child: ToolboxScreen(sceneId: sceneId));
      },
    ),
    GoRoute(
      path: '/toolbox/:sceneId/chapter/:initialChapter',
      pageBuilder: (context, state) {
        final sceneId = int.parse(state.pathParameters['sceneId']!);
        final initialChapter = int.parse(
          state.pathParameters['initialChapter']!,
        );
        return _slidePage(
          child: ToolboxChapterScreen(
            sceneId: sceneId,
            initialTopic: state.extra as Topic?,
            initialChapter: initialChapter,
          ),
        );
      },
    ),
    // Shell with bottom tab — only root pages
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStudyKey,
          routes: [
            GoRoute(
              path: '/study',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorToolboxKey,
          routes: [
            GoRoute(
              path: '/toolbox',
              builder: (context, state) => const ToolboxSceneScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorMeKey,
          routes: [
            GoRoute(
              path: '/me',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: Di.localeController,
      builder: (context, locale, _) => MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appTitle,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
