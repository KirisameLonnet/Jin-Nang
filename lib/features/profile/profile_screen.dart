import 'package:flutter/material.dart';
import '../../core/di.dart';
import '../../core/models/user.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/app_safe_area.dart';
import '../../widgets/pressable.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              _buildTitle(),
              const SizedBox(height: 40),
              _buildProfileCard(),
              const SizedBox(height: 32),
              _buildStatsRow(),
              const SizedBox(height: 32),
              _buildSettingsList(),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'MY PROFILE',
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: AppColors.morandiText,
        height: 37.8 / 36,
        letterSpacing: -0.9,
        shadows: const [Shadow(color: AppColors.lavenderPurple, offset: Offset(3, 3), blurRadius: 0)],
      ),
    );
  }

  Widget _buildProfileCard() {
    final name = _profile?.displayName ?? '...';
    final label = _profile?.levelLabel ?? '...';
    final rank = _profile?.rank ?? '...';

    return Pressable(
      onPressed: () => _comingSoon(context),
      child: Container(
        padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Row(children: [
        _buildAvatar(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                    color: AppColors.morandiText.withValues(alpha: 0.6))),
            const SizedBox(height: 12),
            _buildRankBadge(rank),
          ]),
        ),
      ]),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 72, height: 72,
      decoration: BoxDecoration(
        color: AppColors.oldRose15,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Center(child: Image.asset('assets/icon/my.png', width: 32, height: 32)),
    );
  }

  Widget _buildRankBadge(String rank) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.straw14,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$rank Rank',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
    );
  }

  Widget _buildStatsRow() {
    final streak = _profile?.streakDays.toString() ?? '--';
    final words  = _profile?.totalWordsSeen.toString() ?? '--';
    final score  = _profile != null ? _profile!.avgScore.toStringAsFixed(1) : '--';

    return Row(children: [
      Expanded(child: _buildStatCard(iconPath: 'assets/icon/fire.png',  value: streak, label: 'Day Streak', color: AppColors.lavenderPurple)),
      const SizedBox(width: 16),
      Expanded(child: _buildStatCard(iconPath: 'assets/icon/study.png', value: words,  label: 'Words',     color: AppColors.baliHai30)),
      const SizedBox(width: 16),
      Expanded(child: _buildStatCard(iconPath: 'assets/icon/cup.png',   value: score,  label: 'Avg Score', color: AppColors.straw14)),
    ]);
  }

  Widget _buildStatCard({required String iconPath, required String value, required String label, required Color color}) {
    return Pressable(
      onPressed: () => _comingSoon(context),
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
      ),
      child: Column(children: [
        Image.asset(iconPath, width: 30, height: 20),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.morandiText)),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.morandiText)),
      ]),
      ),
    );
  }

  Widget _buildSettingsList() {
    const items = [
      ('Notifications', AppColors.lavenderPurple),
      ('Language Settings', AppColors.baliHai30),
      ('Help & FAQ', AppColors.straw14),
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('SETTINGS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,
              color: AppColors.morandiText, letterSpacing: -0.5)),
      const SizedBox(height: 16),
      ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSettingsItem(item.$1, item.$2),
          )),
    ]);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Pressable(
      onPressed: () async {
        await Di.tokenStore.clearToken();
        if (context.mounted) Di.router!.go('/login');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.semanticRed, width: 3),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: AppColors.semanticRed, offset: Offset(3, 3), blurRadius: 0)],
        ),
        child: const Center(
          child: Text('Log Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.semanticRed)),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String label, Color iconColor) {
    return Pressable(
      onPressed: () => _comingSoon(context),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.morandiText, width: 3),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: AppColors.morandiText, offset: Offset(3, 3), blurRadius: 0)],
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Image.asset('assets/icon/my.png', width: 18, height: 18)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.morandiText))),
        const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.naturalGray19),
      ]),
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
