import 'package:dejapew/common/sound_manager/sound_keys.dart';
import 'package:dejapew/common/sound_manager/sound_manager.dart';
import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartAnimation extends StatefulWidget {
  final int animationState;
  final Function()? onEnd;
  final Function(LottieComposition) onLoaded;
  const StartAnimation({
    super.key,
    required this.animationState,
    required this.onLoaded,
    this.onEnd,
  });

  @override
  State<StartAnimation> createState() => _StartAnimationState();
}

class _StartAnimationState extends State<StartAnimation> {
  @override
  void initState() {
    super.initState();
    SoundManager.playSound(SoundKeys.countdown);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.animationState == 1 ? 1 : 0,
      duration: Duration(milliseconds: 300),
      onEnd: widget.onEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.black.withAlpha(50),
        alignment: Alignment.center,
        child: Lottie.asset(
          'assets/lottie/countdown.json',
          repeat: false,
          onLoaded: (composition) async {
            if (context.mounted) {
              widget.onLoaded(composition);
            }
          },
        ),
      ),
    );
  }
}
