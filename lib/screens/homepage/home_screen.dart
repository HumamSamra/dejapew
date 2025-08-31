part of 'home.imports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BackgroundPattern(
        pattern: BgPatternType.topography,
        children: [
          AppTopbar(title: 'DejaPew', autoImplyLeading: false),
          Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(30.0),
                child: Lottie.asset('assets/lottie/games.json', height: 250),
              ),
              Column(
                children: [
                  HomeMainBtn(
                    title: 'ابدأ اللعب',
                    onTap: () async {
                      SoundManager.playSound(SoundKeys.click);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChooseGameModeScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  Gap(20),
                  HomeOutlineBtn(
                    title: 'طريقة اللعب',
                    onTap: () async {
                      SoundManager.playSound(SoundKeys.click);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TutorialScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  Gap(20),
                  HomeOutlineBtn(
                    title: 'الإعدادات',
                    onTap: () async {
                      SoundManager.playSound(SoundKeys.click);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  Gap(20),
                  HomeOutlineBtn(
                    title: 'خروج',
                    onTap: () async {
                      SoundManager.playSound(SoundKeys.click);
                      _leaveWarning();
                    },
                  ),
                ],
              ),
            ],
          ),
          Gap(40),
          Spacer(),
          Text(
            "Created by Humam",
            style: TextStyle(fontSize: 25, color: AppColors.light),
          ),
          Gap(40),
        ],
      ),
    );
  }

  _leaveWarning() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: Text(
            'هل انت متأكد؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 25, color: AppColors.light),
          ),
          content: Text(
            'سيتم الخروج من اللعبة، هل انت متأكد من أنك تريد الخروج؟',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 18, color: AppColors.light),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SoundManager.playSound(SoundKeys.click);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('إلغاء', style: TextStyle(fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () async {
                SoundManager.playSound(SoundKeys.click);
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.light,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('خروج', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}
