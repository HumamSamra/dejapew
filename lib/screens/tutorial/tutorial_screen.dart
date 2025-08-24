part of 'tutorial.imports.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.toInt() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BackgroundPattern(
        pattern: BgPatternType.topography,
        children: [
          AppTopbar(
            title: 'شرح طريقة اللعب',
            trailing: Icons.info_outline,
            trailingOnTap: () {},
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                TutorialCard(
                  title: 'تحدٍ للمخيلة',
                  subtitle:
                      'اختبر ذاكرتك وسرعة بديهتك في مطابقة الأوراق المتشابهة',
                  path: 'assets/images/1.png',
                ),
                TutorialCard(
                  title: 'لعبة الذاكرة',
                  subtitle:
                      'اقلب وابحث عن الزوج المطابق لتجميع أكبر عدد من الأوراق',
                  path: 'assets/images/2.png',
                ),
                TutorialCard(
                  title: 'ابحث عن التوأم',
                  subtitle: 'العب وتحدى أصدقائك في لعبة الذاكرة المثيرة',
                  path: 'assets/images/3.png',
                ),
                TutorialCard(
                  title: 'هل شاهدتها من قبل؟',
                  subtitle: 'استخدم ذاكرتك و حدسك لإيجاد البطاقات المتشابهة',
                  path: 'assets/images/4.png',
                ),
              ],
            ),
          ),
          Gap(20),
          SmoothPageIndicator(
            controller: _pageController,
            count: 4,
            effect: ExpandingDotsEffect(
              spacing: 10,
              dotWidth: 10,
              dotHeight: 10,
              dotColor: AppColors.gray,
              activeDotColor: AppColors.primary,
            ),
            onDotClicked: (index) => _pageController.jumpToPage(index),
          ),
          Gap(30),
          HomeMainBtn(
            title: 'ابدأ اللعب',
            onTap: _currentPage == 3
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChooseGameModeScreen(),
                    ),
                  )
                : null,
          ),
          Gap(60),
          Text("v1.0", style: TextStyle(fontSize: 25, color: AppColors.light)),
        ],
      ),
    );
  }
}
