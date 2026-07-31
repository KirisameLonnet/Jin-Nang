import 'package:flutter/material.dart';
import '../../core/di.dart';
import '../../core/models/user.dart';
import '../../theme/app_colors.dart';
//import '../../theme/app_fonts.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/pressable.dart';
import '../../widgets/title_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await Di.api.getMe();
      if (!mounted) return;
      setState(() => _profile = profile);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.springWood14,
      child: AppSafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildWelcomeSection(),
              const SizedBox(height: 29),
              _buildStatsCards(),
              const SizedBox(height: 16),
              Expanded(child: _buildMissionsSection(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final name = _profile?.displayName ?? '...';
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNameCard('Yo! $name'),
              const SizedBox(height: 9),
              const TitleSection(title: 'Ready to\nLevel Up?', subtitle: ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNameCard(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.baliHai30,
        border: Border.all(color: AppColors.morandiText, width: 2.389),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900,
              color: AppColors.morandiText, letterSpacing: 0.35)),
    );
  }

  Widget _buildStatsCards() {
    final streak = _profile?.streakDays ?? 0;
    final rank = _profile?.rank ?? '--';
    return Row(
      children: [
        Expanded(child: _buildStreakCard(streak)),
        const SizedBox(width: 16),
        Expanded(child: _buildRankCard(rank)),
      ],
    );
  }

  Widget _buildStreakCard(int days) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lavenderPurple,
        border: Border.all(color: AppColors.morandiText, width: 2.389),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildStatIcon('assets/icon/fire.png'),
          const SizedBox(height: 5),
        const Text('STREAK',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              children: [
              TextSpan(text: '$days ',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
              const TextSpan(text: 'Days',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.morandiText)),
              ],
            ),
          ),
      ]),
    );
  }

  Widget _buildRankCard(String rank) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.straw14,
        border: Border.all(color: AppColors.morandiText, width: 2.389),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildStatIcon('assets/icon/cup.png'),
          const SizedBox(height: 5),
        const Text('RANK',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
          const SizedBox(height: 5),
        Text(rank,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
      ]),
    );
  }

  Widget _buildStatIcon(String assetPath) {
    return Container(
      width: 32, height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 1.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Image.asset(assetPath),
    );
  }

  Widget _buildMissionsSection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('MISSIONS',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900,
              color: AppColors.morandiText, letterSpacing: -0.65)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            clipBehavior: Clip.none,
            children: [
              Pressable(
                onPressed: () => Di.router!.go('/study/vocab-scene'),
                child: _buildMissionCard(
                  title: 'Vocab\nLearning',
                  subtitle: '${_profile?.totalWordsSeen ?? 0} words learned',
                  color: AppColors.straw14,
                  iconPath: 'assets/icon/study.png',
                ),
              ),
              const SizedBox(height: 16),
              Pressable(
                onPressed: () => Di.router!.go('/study/dialogue-scene'),
                child: _buildMissionCard(
                  title: 'Dialogue\nPractice',
                  subtitle: 'Pick a scene to practice',
                  color: AppColors.baliHai30,
                  iconPath: 'assets/icon/dialogue_learning.png',
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
    ]);
  }

  Widget _buildMissionCard({
    required String title,
    required String subtitle,
    required Color color,
    required String iconPath,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.morandiText, width: 2.389),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Row(children: [
          _buildMissionIcon(iconPath),
          const SizedBox(width: 12),
          Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
                    color: AppColors.morandiText, height: 25 / 20)),
                const SizedBox(height: 7),
            Text(subtitle,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                    color: AppColors.morandiText.withValues(alpha: 0.7))),
          ]),
          ),
      ]),
    );
  }

  Widget _buildMissionIcon(String iconPath) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Center(child: Image.asset(iconPath, width: 22, height: 22)),
    );
  }
}
