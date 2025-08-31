import 'package:dejapew/common/sound_manager/sound_keys.dart';
import 'package:dejapew/common/sound_manager/sound_manager.dart';
import 'package:dejapew/common/theme/app_colors.dart';
import 'package:dejapew/screens/homepage/widgets/home_main_btn.dart';
import 'package:dejapew/screens/homepage/widgets/home_outline_btn.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class PauseMenu extends StatelessWidget {
  final bool isPaused;
  final int showAnimation;
  final Function()? onContinue;
  final Function()? onExit;
  final Function()? onrestart;
  final Function()? onEnd;
  const PauseMenu({
    super.key,
    required this.isPaused,
    required this.showAnimation,
    this.onContinue,
    this.onExit,
    this.onEnd,
    this.onrestart,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 400),
      opacity: isPaused ? 1 : 0,
      onEnd: () => onEnd,
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        color: AppColors.black.withAlpha(200),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/pause.json',
                repeat: false,
                height: 200,
              ),
              Text(
                'تم إيقاف اللعبة',
                style: TextStyle(fontSize: 25, color: AppColors.darklight),
              ),
              Gap(20),
              HomeMainBtn(
                title: 'إستئناف',
                onTap: () async {
                  SoundManager.playSound(SoundKeys.click);
                  if (onContinue != null && context.mounted) {
                    onContinue!();
                  }
                },
              ),
              Gap(20),
              HomeOutlineBtn(
                title: 'إعادة المباراة',
                onTap: () async {
                  SoundManager.playSound(SoundKeys.click);
                  if (onrestart != null && context.mounted) {
                    onrestart!();
                  }
                },
              ),
              Gap(20),
              HomeOutlineBtn(
                title: 'خروج',
                onTap: () async {
                  SoundManager.playSound(SoundKeys.click);
                  if (onExit != null && context.mounted) {
                    onExit!();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
