import 'package:dejapew/common/sound_manager/sound_keys.dart';
import 'package:dejapew/common/sound_manager/sound_manager.dart';
import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String text;
  final Function()? onMain;
  final Function()? onSub;
  final String mainTitle;
  final String subTitle;
  const AppDialog({
    super.key,
    required this.title,
    required this.text,
    this.onMain,
    this.onSub,
    required this.mainTitle,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 25, color: AppColors.light),
      ),
      content: Text(
        text,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 18, color: AppColors.light),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            SoundManager.playSound(SoundKeys.click);
            if (onSub != null) {
              onSub!();
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(subTitle, style: TextStyle(fontSize: 18)),
        ),
        ElevatedButton(
          onPressed: () async {
            SoundManager.playSound(SoundKeys.click);
            if (onMain != null) {
              onMain!();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(mainTitle, style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
