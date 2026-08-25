// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '锦囊';

  @override
  String get loading => '加载中…';

  @override
  String get welcomeBack => '欢迎\n回来';

  @override
  String get signInSubtitle => '登录后继续学习。';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get name => '昵称';

  @override
  String get signIn => '登录';

  @override
  String get signingIn => '正在登录…';

  @override
  String get signUp => '注册';

  @override
  String get noAccount => '还没有账号？';

  @override
  String get loginFailed => '登录失败，请稍后重试。';

  @override
  String get invalidCredentials => '邮箱或密码错误。';

  @override
  String get emailPasswordRequired => '请输入邮箱和密码。';

  @override
  String get createAccountTitle => '创建\n账号';

  @override
  String get registerSubtitle => '开始你的中文学习之旅。';

  @override
  String get createAccount => '创建账号';

  @override
  String get creatingAccount => '正在创建…';

  @override
  String get hasAccount => '已有账号？';

  @override
  String get registrationFailed => '注册失败，请稍后重试。';

  @override
  String get invalidEmail => '请输入有效的邮箱地址。';

  @override
  String get passwordLength => '密码长度须为 8–128 个字符。';

  @override
  String get displayNameLength => '昵称长度须为 1–50 个字符。';

  @override
  String get emailRegistered => '该邮箱已经注册。';

  @override
  String get studyTab => '学习';

  @override
  String get toolboxTab => '工具箱';

  @override
  String get profileTab => '我的';

  @override
  String greeting(String name) {
    return '你好，$name';
  }

  @override
  String get readyToLevelUp => '准备好\n升级了吗？';

  @override
  String get streak => '连续学习';

  @override
  String dayCount(int count) {
    return '$count 天';
  }

  @override
  String get rank => '段位';

  @override
  String get missions => '学习任务';

  @override
  String get vocabLearning => '词汇\n学习';

  @override
  String get vocabLearningSingleLine => '词汇学习';

  @override
  String wordsLearned(int count) {
    return '已学 $count 个词';
  }

  @override
  String get dialoguePractice => '对话\n练习';

  @override
  String get dialoguePracticeSingleLine => '对话练习';

  @override
  String minutes(int count) {
    return '$count 分钟';
  }

  @override
  String get featureComingSoon => '该功能即将上线。';

  @override
  String get selectScene => '选择场景';

  @override
  String get sceneComingSoon => '该场景即将上线。';

  @override
  String get loadFailed => '内容加载失败，请稍后重试。';

  @override
  String get restaurantSubtitle => '学习餐厅点餐与饮品表达。';

  @override
  String get supermarketSubtitle => '学习购物清单与结账表达。';

  @override
  String get airportSubtitle => '学习值机、登机等出行表达。';

  @override
  String get restaurantDialogueTitle => '餐厅点餐';

  @override
  String get supermarketDialogueTitle => '超市购物';

  @override
  String get airportDialogueTitle => '机场出行';

  @override
  String get toolboxTitle => '工具箱';

  @override
  String get toolboxSubtitle => '真实生活场景常用表达。';

  @override
  String get usefulPhrases => '实用短语';

  @override
  String get retry => '重试';

  @override
  String chapter(int number) {
    return '第 $number 章';
  }

  @override
  String sentenceCount(int count) {
    return '$count 句话';
  }

  @override
  String get previous => '上一页';

  @override
  String get next => '下一页';

  @override
  String get finish => '完成';

  @override
  String get start => '开始';

  @override
  String get replay => '再练一次';

  @override
  String get review => '回顾';

  @override
  String get none => '无';

  @override
  String get exampleSentence => '例句';

  @override
  String get associatedWords => '关联词';

  @override
  String get phrases => '短语';

  @override
  String get synonyms => '近义词';

  @override
  String get antonyms => '反义词';

  @override
  String get expandedWords => '拓展词';

  @override
  String get learnTheseWords => '先来学学这几个词';

  @override
  String cardsLearned(int learned, int total) {
    return '点击卡片学习（$learned/$total）';
  }

  @override
  String get startPractice => '学完了，去练习 →';

  @override
  String get myProfile => '我的资料';

  @override
  String rankLabel(String rank) {
    return '$rank段位';
  }

  @override
  String get dayStreak => '连续学习';

  @override
  String get words => '已学词汇';

  @override
  String get averageScore => '平均分';

  @override
  String get settings => '设置';

  @override
  String get notifications => '通知';

  @override
  String get languageSettings => '语言设置';

  @override
  String get helpFaq => '帮助与常见问题';

  @override
  String get logOut => '退出登录';

  @override
  String get comingSoon => '即将上线。';

  @override
  String get language => '应用语言';

  @override
  String get followSystem => '跟随系统';

  @override
  String get english => 'English';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get languageBadgeEnglish => 'EN';

  @override
  String get languageBadgeChinese => '中';

  @override
  String points(int count) {
    return '$count 积分';
  }

  @override
  String rewardPoints(int count) {
    return '+$count 积分';
  }

  @override
  String starCount(int count) {
    return '×$count';
  }

  @override
  String get exampleSentencePinyin => 'Lìjù';

  @override
  String get bronze => '青铜';

  @override
  String get silver => '白银';

  @override
  String get gold => '黄金';

  @override
  String get platinum => '铂金';

  @override
  String get beginner => '初学者';

  @override
  String get elementaryLearner => '基础学习者';

  @override
  String get intermediateLearner => '中级学习者';

  @override
  String get advancedLearner => '高级学习者';

  @override
  String get learner => '学习者';

  @override
  String levelNumber(int number) {
    return '第 $number 关 / 4';
  }

  @override
  String levelTitle(int number, String title) {
    return '第 $number 关：$title';
  }

  @override
  String get passed => '已通关';

  @override
  String get locked => '未解锁';

  @override
  String passProgress(int correct, int total) {
    return '通关：$correct/$total 题';
  }

  @override
  String get completePreviousLevel => '请先通关前一关。';

  @override
  String questModule(String scene) {
    return '$scene · 挑战关卡';
  }

  @override
  String get questRewardHint => '完成挑战即可获得星星与积分！';

  @override
  String get vocabMatch => '词汇匹配';

  @override
  String get listeningChoice => '听力选择';

  @override
  String get blankFilling => '句子填空';

  @override
  String get rolePlay => '点餐角色扮演';

  @override
  String get vocabMatchDescription => '识形、知意：选择正确的英文释义或匹配中文词。';

  @override
  String get listeningChoiceDescription => '听音知意：播放音频，从备选中文汉字中选择正确答案。';

  @override
  String get blankFillingDescription => '选择最合适的词语补全餐厅对话。';

  @override
  String get rolePlayDescription => '模拟真实餐厅场景，与服务员进行中文对话练习。';

  @override
  String get unlockNextLevelDescription => '完成题目，解锁下一关。';

  @override
  String get playPinyinAudio => '请播放拼音音频';

  @override
  String get correctAnswer => '回答正确';

  @override
  String get incorrectAnswer => '回答错误';

  @override
  String get seeResults => '查看结果';

  @override
  String get nextQuestion => '下一题';

  @override
  String get submitAnswer => '确认提交';

  @override
  String get summary => '闯关报告';

  @override
  String get score => '得分';

  @override
  String get levelPassed => '恭喜通过本关！';

  @override
  String get tryAgain => '再来一次！';

  @override
  String get rewards => '通关奖励';

  @override
  String get returnToLevels => '返回关卡选择';

  @override
  String get retryLevel => '重试本关';

  @override
  String get challengePassed => '闯关成功！';

  @override
  String get challengeFailed => '未通过';

  @override
  String get done => '完成';

  @override
  String get dialogueReview => '对话回顾';
}
