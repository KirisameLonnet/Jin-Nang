import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 米黄色背景
      backgroundColor: const Color(0xFFD4C08B),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Jin Nang 标题
            Text(
              'Jin Nang',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -1,
                shadows: [
                  Shadow(
                    offset: const Offset(5, 5),
                    blurRadius: 0,
                    color: const Color(0xFF7A9DB8), // 蓝灰色硬阴影
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // LOADING... 胶囊
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE), // 浅灰白
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    blurRadius: 0,
                    spreadRadius: 0,
                    color: Colors.black.withOpacity(0.65),
                  ),
                ],
              ),
              child: const Text(
                'LOADING...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}