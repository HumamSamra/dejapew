import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfetteAnimation extends StatelessWidget {
  final AnimationController controller;
  const ConfetteAnimation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.topCenter,
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Lottie.asset(
            controller: controller,
            'assets/lottie/confette.json',
            repeat: false,
            onLoaded: (composition) {
              controller.duration = composition.duration;
            },
          ),
        ),
      ),
    );
  }
}
