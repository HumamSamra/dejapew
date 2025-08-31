import 'package:dejapew/common/sound_manager/sound_keys.dart';
import 'package:dejapew/common/sound_manager/sound_manager.dart';
import 'package:dejapew/common/theme/app_colors.dart';
import 'package:dejapew/screens/homepage/widgets/home_main_btn.dart';
import 'package:dejapew/screens/homepage/widgets/home_outline_btn.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EndMenu extends StatelessWidget {
  final bool show1;
  final bool show2;
  final int p1Score, p2Score;
  final String winner;
  final Function()? onrestart;
  final Function()? onBack;
  const EndMenu({
    super.key,
    required this.show1,
    required this.show2,
    required this.p1Score,
    required this.p2Score,
    required this.winner,
    this.onrestart,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Fade in background overlay
          AnimatedOpacity(
            opacity: show1 ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              color: AppColors.black.withAlpha(200),
            ),
          ),

          // Content (light fade+slide)
          Center(
            child: AnimatedOpacity(
              opacity: show2 ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSlide(
                offset: show2 ? Offset.zero : const Offset(0, 0.2),
                duration: const Duration(milliseconds: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/game_over.gif', height: 180),
                    const Gap(20),
                    if (p1Score != p2Score)
                      Text(
                        'النقاط: ${p1Score > p2Score ? p1Score : p2Score}',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 25,
                          color: AppColors.darklight,
                        ),
                      ),
                    if (p1Score != p2Score) const Gap(10),
                    Text(
                      p1Score != p2Score
                          ? 'لقد فاز اللاعب:'
                          : 'لقد انتهت المباراة',
                      style: TextStyle(color: AppColors.light, fontSize: 40),
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      winner,
                      style: TextStyle(color: AppColors.primary, fontSize: 40),
                    ),
                    const Gap(20),
                    HomeMainBtn(
                      title: 'إعادة الجولة',
                      onTap: () async {
                        SoundManager.playSound(SoundKeys.click);
                        if (onrestart != null && context.mounted) {
                          onrestart!();
                        }
                      },
                    ),
                    const Gap(20),
                    HomeOutlineBtn(
                      title: 'العودة',
                      onTap: () async {
                        SoundManager.playSound(SoundKeys.click);
                        if (onBack != null && context.mounted) {
                          onBack!();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
