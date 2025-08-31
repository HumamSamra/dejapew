import 'package:dejapew/common/sound_manager/sound_keys.dart';
import 'package:dejapew/common/sound_manager/sound_manager.dart';
import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTopbar extends StatelessWidget {
  final bool autoImplyLeading;
  final IconData? leading;
  final IconData? trailing;
  final Function()? trailingOnTap;
  final Function()? leadingOnTap;
  final String? title;
  const AppTopbar({
    super.key,
    this.autoImplyLeading = true,
    this.leadingOnTap,
    this.trailingOnTap,
    this.leading,
    this.trailing,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          if (leading != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: leadingOnTap == null
                        ? null
                        : () async {
                            SoundManager.playSound(SoundKeys.click);
                            leadingOnTap!();
                          },
                    color: AppColors.light,
                    disabledColor: AppColors.gray,
                    icon: Icon(leading),
                  ),
                ],
              ),
            )
          else if (autoImplyLeading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      SoundManager.playSound(SoundKeys.click);
                      Navigator.pop(context);
                    },
                    color: AppColors.light,
                    disabledColor: AppColors.gray,
                    icon: Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title!,
                    style: TextStyle(color: AppColors.light, fontSize: 25),
                  ),
                ],
              ),
            ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: trailingOnTap == null
                        ? null
                        : () async {
                            SoundManager.playSound(SoundKeys.click);
                            trailingOnTap!();
                          },
                    disabledColor: AppColors.gray,
                    color: AppColors.light,
                    icon: Icon(trailing),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
