import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart'; 暂时不用谷歌font,后续考虑兼容性再说

// 颜色常量
const _primaryColor = Color(0xFF888BD6);
const _primaryLight = Color(0x33888BD6);
const _cardBgDark = Color(0xFF808080);
const _cardBgLight = Color(0xFFB3B3B3);
const _bottomBarBg = Color(0xFFE6E6E6);
const _textLight = Color(0xFFE6E6E6);

// 文字样式,字体很可能做不到一模一样，需要感性调整
const _titleStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 48,
  height: 1,
  letterSpacing: 0.5,
  color: Colors.black,
);

const _cardTitleStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 20,
  height: 0.8,
  letterSpacing: 1,
  color: _textLight,
);

void main() {
  runApp(MaterialApp(
    home: _MainPage(), 
  ));
}

// 主页面
class _MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  int _currentIndex = 0;  // 0=Study, 1=Toolbox, 2=Me

  final List<Widget> _pages = [
    HomePage(),     // 学习页(主页)
    ToolboxPage(),  // 工具箱页
    MePage(),       // 个人页
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  //底部导航栏
  Widget _buildBottomNavBar() {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _bottomBarBg,
      child: Row(
        children: [
          _buildNavItem('images/Icon-Study.png', "Study", 0),
          _buildNavItem('images/Icon-Toolbox.png', "Toolbox", 1),
          _buildNavItem('images/Icon-Me.png', "Me", 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imagePath, String label, int index) { //icon暂时用图片
    final isSelected = _currentIndex == index; 
    
    return Expanded(
      child: GestureDetector(  // 点击事件
        onTap: () {
          setState(() {
            _currentIndex = index; 
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0), //其实这里不需要 否则会超出高度
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? _primaryLight : Colors.transparent,  // 淡紫色:无色
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Image.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                  color: isSelected ? _primaryColor : Colors.black,  //紫色:黑色
                ),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? _primaryColor : Colors.black,  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// 学习页（主页）
class HomePage extends StatelessWidget {
  const HomePage({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 27), //设计图没有加左右padding 补上
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max, //上下fill
          crossAxisAlignment: CrossAxisAlignment.center, //水平居中
          children: [
            SizedBox(height: 104), //设计图没有标出间距 只能手动计算
            _buildTitle(),
            SizedBox(height: 139),
            _buildFeatureCard("Vocabulary Learning", _cardBgLight),
            SizedBox(height: 24),
            _buildFeatureCard("Dialogue Practice", _cardBgDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      height: 80,
      width: double.infinity, //左右fill (其实是默认值
      child: Text(
        "Study",
        textAlign: TextAlign.center,
        style: _titleStyle,
      ),
    );
  }

  Widget _buildFeatureCard(String title, Color bgColor) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 26, top: 127), //没标间距 建议画设计图的时候改成用容器嵌套 不然会有误差
        child: SizedBox(
          height: 24,
          width: double.infinity,
          child: Text(
            title,
            style: _cardTitleStyle,
          ),
        ),
      ),
    );
  }
}

// 工具箱页（占位）
class ToolboxPage extends StatelessWidget {
  const ToolboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Toolbox Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// 个人页（占位)
class MePage extends StatelessWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Me Page",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}