import 'package:flutter/material.dart';

// ==================== 颜色（与之前页面统一）====================
class AppColors {
  static const bg = Color(0xFFF5F0E8);
  static const dark = Color(0xFF3D3D3D);
  static const cardBg = Color(0xFFF0EDE6);
  static const white = Color(0xFFFAF8F3);
  static const blue = Color(0xFF7A9E9F);
  static const green = Color(0xFF8FD694);
  static const gold = Color(0xFFD4C896);
  static const lightGray = Color(0xFFE8E5DE);
  static const purpleTint = Color(0xFFEAE8F0);
}

// ==================== 入口（测试用）====================
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SummaryPage(score: 5, total: 6, stars: 3, points: 50),
    ));

// ==================== 闯关报告页 ====================
class SummaryPage extends StatelessWidget {
  /// 答对题数
  final int score;
  /// 总题数
  final int total;
  /// 获得星星数 (1-3)
  final int stars;
  /// 获得积分
  final int points;

  const SummaryPage({
    super.key,
    required this.score,
    required this.total,
    required this.stars,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- 顶部导航 ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _circleBtn(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '闯关报告(Summary)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),

            // ---------- 主体卡片 ----------
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // 大卡片
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: AppColors.dark, width: 3.5),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.dark,
                              offset: Offset(5, 5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 50, 24, 28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 星星
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: _star(filled: index < stars),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // 得分标题
                              const Text(
                                '得分 SCORE',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // 分数
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.dark,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '$score',
                                      style: const TextStyle(fontSize: 64, height: 1.1),
                                    ),
                                    TextSpan(
                                      text: ' / $total',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // 提示文案
                              Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                    height: 1.5,
                                  ),
                                  children: [
                                    const TextSpan(text: '需正确答对'),
                                    TextSpan(
                                      text: '$score',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.dark,
                                      ),
                                    ),
                                    const TextSpan(text: '题以实现完美解锁。'),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 28),

                              // 奖励区域
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.dark,
                                    width: 2.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      '通关获得奖励',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          color: AppColors.gold,
                                          size: 28,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '+${points}PTS',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.dark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              // 虚线分隔
                              _dashedLine(),

                              const SizedBox(height: 28),

                              // 返回按钮
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.dark,
                                      width: 2.5,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.dark,
                                        offset: Offset(3, 3),
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    '返回关卡选择',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 顶部标签：闯关成功！
                      Positioned(
                        top: -22,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.dark,
                              width: 3,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.dark,
                                offset: Offset(3, 3),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: const Text(
                            '闯关成功！',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.dark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------- 带粗描边的卡通星星 ----------
  Widget _star({required bool filled}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 外圈描边
        Icon(
          Icons.star,
          size: 46,
          color: AppColors.dark,
        ),
        // 内部填充
        Icon(
          Icons.star,
          size: 38,
          color: filled ? AppColors.gold : AppColors.lightGray,
        ),
      ],
    );
  }

  // ---------- 圆形返回按钮 ----------
  Widget _circleBtn({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.dark, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: AppColors.dark,
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.dark, size: 22),
      ),
    );
  }

  // ---------- 虚线 ----------
  Widget _dashedLine() {
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 1,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}