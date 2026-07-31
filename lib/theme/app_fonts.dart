/// 全局字体常量
///
/// Inter 负责拉丁字符（与 Figma 设计稿一致），
/// HarmonyOS Sans SC 负责中文字符作为 fallback。
class AppFonts {
  AppFonts._();

  /// 英文字体 — Inter（与 Figma 设计稿完全一致）
  static const String english = 'Inter';

  /// 中文字体 — 鸿蒙黑体（HarmonyOS Sans SC），含简体中文字符集
  static const String chinese = 'HarmonyOS Sans SC';
}
