import 'package:dejapew/common/theme/app_colors.dart';
import 'package:dejapew/screens/homepage/widgets/home_main_btn.dart';
import 'package:dejapew/screens/homepage/widgets/home_outline_btn.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class WinningScreen extends StatefulWidget {
  final String playerName;
  final Function()? onBack;
  final Function()? onRestart;
  const WinningScreen({
    super.key,
    required this.playerName,
    this.onBack,
    this.onRestart,
  });

  @override
  State<WinningScreen> createState() => _WinningScreenState();
}

class _WinningScreenState extends State<WinningScreen> {
  bool show1 = false, show2 = false, show3 = false;

  @override
  void initState() {
    super.initState();
    _showAnimationCycle();
  }

  _showAnimationCycle() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => show1 = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => show2 = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => show3 = true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        // Fade in background overlay
        AnimatedOpacity(
          opacity: show1 ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.black.withAlpha(200),
          ),
        ),

        // Main content
        Center(
          child: AnimatedOpacity(
            opacity: show3 ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: AnimatedSlide(
              offset: show3 ? Offset.zero : const Offset(0, 0.2),
              duration: const Duration(milliseconds: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lottie/congratulations.json',
                    repeat: false,
                  ),
                  const Gap(10),
                  Text(
                    'لقد فاز اللاعب:',
                    style: TextStyle(color: AppColors.light, fontSize: 40),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    widget.playerName,
                    style: TextStyle(color: AppColors.primary, fontSize: 40),
                  ),
                  const Gap(20),
                  HomeMainBtn(title: 'العودة', onTap: widget.onBack),
                  const Gap(20),
                  HomeOutlineBtn(
                    title: 'إعادة الجولة',
                    onTap: widget.onRestart,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
