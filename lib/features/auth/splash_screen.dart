import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di.dart';
import '../../theme/app_colors.dart';
import '../../l10n/l10n.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _opacity = 0.0);
    });
    Timer(const Duration(seconds: 3), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final hasToken = await Di.tokenStore.hasToken();
    if (!mounted) return;
    context.go(hasToken ? '/study' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.straw14,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeIn,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Jin Nang 标题
              Text(
                context.l10n.appTitle,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.morandiText,
                  letterSpacing: -1,
                  shadows: const [
                    Shadow(
                      offset: Offset(5, 5),
                      blurRadius: 0,
                      color: AppColors.baliHai30,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // LOADING... 胶囊
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.springWood14,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.morandiText, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.morandiText,
                      offset: Offset(0, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  context.l10n.loading,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.morandiText,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
