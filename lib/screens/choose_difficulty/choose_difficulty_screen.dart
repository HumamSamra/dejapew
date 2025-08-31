part of 'choose_difficulty.imports.dart';

class ChooseDifficultyScreen extends StatefulWidget {
  final GameType gameType;
  const ChooseDifficultyScreen({super.key, required this.gameType});

  @override
  State<ChooseDifficultyScreen> createState() => _ChooseDifficultyScreenState();
}

class _ChooseDifficultyScreenState extends State<ChooseDifficultyScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BackgroundPattern(
        pattern: BgPatternType.topography,
        children: [
          AppTopbar(
            title: 'اختر الصعوبة',
            trailing: Icons.info_outline,
            trailingOnTap: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: AppColors.background,
                  title: Text(
                    'صعوبة اللعبة',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 25, color: AppColors.light),
                  ),
                  content: Text(
                    'تختلف صعوبة اللعبة باختلاف عدد البطاقات الموجودة على الساحة، عليك بالحصول على أكبر عدد من البطاقات بأسرع وقت!',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 18, color: AppColors.light),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        SoundManager.playSound(SoundKeys.click);
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.light,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('لقد فهمت', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                );
              },
            ),
          ),
          Spacer(),
          Icon(
            widget.gameType == GameType.against_bot
                ? Icons.devices
                : Icons.co_present_outlined,
            color: AppColors.light,
            size: 60,
          ),
          Text(
            widget.gameType == GameType.against_bot
                ? 'ضد الكمبيوتر'
                : 'ضد صديق',
            style: TextStyle(fontSize: 40, color: AppColors.light),
          ),
          Gap(30),
          DifficultyBtn(
            title: 'سهل',
            size: 1,
            onTap: () async {
              SoundManager.playSound(SoundKeys.click);
              final cardsType = await Utils.getCardType();
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameSessionScreen(
                      level: DifficultyLevel.easy,
                      gameType: widget.gameType,
                      cardsType: cardsType,
                    ),
                  ),
                );
              }
            },
          ),
          Gap(20),
          DifficultyBtn(
            title: 'عادي',
            size: 2,
            onTap: () async {
              SoundManager.playSound(SoundKeys.click);
              final cardsType = await Utils.getCardType();
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameSessionScreen(
                      level: DifficultyLevel.normal,
                      gameType: widget.gameType,
                      cardsType: cardsType,
                    ),
                  ),
                );
              }
            },
          ),
          Gap(20),
          DifficultyBtn(
            title: 'صعب',
            size: 3,
            onTap: () async {
              SoundManager.playSound(SoundKeys.click);
              final cardsType = await Utils.getCardType();
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameSessionScreen(
                      level: DifficultyLevel.hard,
                      gameType: widget.gameType,
                      cardsType: cardsType,
                    ),
                  ),
                );
              }
            },
          ),
          Gap(30),
          Spacer(),
          Text("v1.0", style: TextStyle(fontSize: 25, color: AppColors.light)),
        ],
      ),
    );
  }
}
