part of 'choose_game_mode.imports.dart';

class ChooseGameModeScreen extends StatefulWidget {
  const ChooseGameModeScreen({super.key});

  @override
  State<ChooseGameModeScreen> createState() => _ChooseGameModeScreenState();
}

class _ChooseGameModeScreenState extends State<ChooseGameModeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BackgroundPattern(
        pattern: BgPatternType.topography,
        children: [
          AppTopbar(
            title: 'اختر طور اللعب',
            trailing: Icons.info_outline,
            trailingOnTap: () async {
              SoundManager.playSound(SoundKeys.click);
              if (context.mounted) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: AppColors.background,
                      title: Text(
                        'طور اللعب',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 25, color: AppColors.light),
                      ),
                      content: Text(
                        'يمكنك اللعب بأطوار مختلفة، اختر ما يناسبك وابدأ اللعب!',
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
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
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.light,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'لقد فهمت',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          Spacer(),
          ModeBtn(
            title: 'ضد صديق',
            onTap: () async {
              SoundManager.playSound(SoundKeys.click);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChooseDifficultyScreen(
                      gameType: GameType.against_friend,
                    ),
                  ),
                );
              }
            },
            icon: Icons.co_present_outlined,
          ),
          Gap(20),
          ModeBtn(
            title: 'ضد الكمبيوتر',
            onTap: () async {
              SoundManager.playSound(SoundKeys.click);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChooseDifficultyScreen(gameType: GameType.against_bot),
                  ),
                );
              }
            },
            icon: Icons.devices,
          ),
          Spacer(),
          Text("v1.0", style: TextStyle(fontSize: 25, color: AppColors.light)),
        ],
      ),
    );
  }
}
