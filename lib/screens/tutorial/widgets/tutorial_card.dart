import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TutorialCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String path;
  const TutorialCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.asset(path),
            ),
          ),
          Gap(10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.primary, fontSize: 40),
          ),
          Gap(10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.light, fontSize: 30),
          ),
        ],
      ),
    );
  }
}
