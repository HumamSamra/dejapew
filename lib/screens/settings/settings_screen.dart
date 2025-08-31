part of 'settings.imports.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double soundVolume = 0;
  bool soundMuted = false;

  CardsType cardsType = CardsType.ios_emojies;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cardsType = await Utils.getCardType();
    soundVolume = await StorageService.getDouble(StorageKeys.sound_volume) ?? 0;
    soundMuted = await StorageService.getBool(StorageKeys.sound_mute) ?? false;
    setState(() {});
  }

  setVolume(double value) async {
    await StorageService.setDouble(StorageKeys.sound_volume, value);
    SoundManager.volume = value;
  }

  setMute(bool muted) async {
    await StorageService.setBool(StorageKeys.sound_mute, muted);
    SoundManager.volume = muted ? 0 : soundVolume;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BackgroundPattern(
        pattern: BgPatternType.topography,
        children: [
          AppTopbar(title: 'الإعدادات', autoImplyLeading: true),
          Gap(20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Text(
              'اختر نوع البطاقات:',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 30, color: AppColors.light),
            ),
          ),
          Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CardTypeTile(
                  name: 'ايقونات',
                  path: 'assets/game_cards/ios_emojies/1.png',
                  isActive: cardsType == CardsType.ios_emojies,
                  onTap: () async {
                    if (cardsType != CardsType.ios_emojies) {
                      cardsType = CardsType.ios_emojies;
                      Utils.setCardType(cardsType);
                      setState(() {});
                    }
                    SoundManager.playSound(SoundKeys.click);
                  },
                ),
                CardTypeTile(
                  name: 'شركات',
                  path: 'assets/game_cards/brands/3.png',
                  isActive: cardsType == CardsType.brands,
                  onTap: () async {
                    if (cardsType != CardsType.brands) {
                      cardsType = CardsType.brands;
                      Utils.setCardType(cardsType);
                      setState(() {});
                    }
                    SoundManager.playSound(SoundKeys.click);
                  },
                ),
                CardTypeTile(
                  name: 'سيارات',
                  path: 'assets/game_cards/car_brands/14.png',
                  isActive: cardsType == CardsType.car_brands,
                  onTap: () async {
                    if (cardsType != CardsType.car_brands) {
                      cardsType = CardsType.car_brands;
                      Utils.setCardType(cardsType);
                      setState(() {});
                    }
                    SoundManager.playSound(SoundKeys.click);
                  },
                ),
              ],
            ),
          ),
          Gap(30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Text(
              'مستوى الصوت',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 30, color: AppColors.light),
            ),
          ),
          Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async {
                    if (soundVolume == 0 || soundMuted) {
                      soundMuted = false;
                    } else {
                      soundMuted = true;
                    }
                    await setMute(soundMuted);
                    setState(() {});
                    SoundManager.playSound(SoundKeys.soundChange);
                  },
                  color: AppColors.darklight,
                  iconSize: 40,
                  icon: Icon(
                    (soundVolume == 0 || soundMuted)
                        ? Icons.volume_off_outlined
                        : soundVolume > 50
                        ? Icons.volume_up_outlined
                        : Icons.volume_down_outlined,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: soundMuted ? 0 : soundVolume,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (value) async {
                      soundMuted = false;
                      soundVolume = value;
                      await setMute(false);
                      await setVolume(value);
                      SoundManager.playSound(SoundKeys.soundChange);
                      setState(() {});
                    },
                    thumbColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'جميع الحقوق المتعلقة بالخطوط والصور المستخدمة في هذا التطبيق محفوظة لأصحابها الأصليين.',
              style: TextStyle(fontSize: 23, color: AppColors.darklight),
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
            ),
          ),
          Spacer(),
          Text("v1.0", style: TextStyle(fontSize: 25, color: AppColors.light)),
        ],
      ),
    );
  }
}
