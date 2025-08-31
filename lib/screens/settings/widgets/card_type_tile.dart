import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardTypeTile extends StatelessWidget {
  final String name;
  final String path;
  final bool isActive;
  final Function()? onTap;
  const CardTypeTile({
    super.key,
    required this.name,
    required this.path,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.darklight,
            width: 3,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Image.asset(path, height: 30, width: 30),
              Gap(10),
              Text(
                name,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.darklight,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
