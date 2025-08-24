import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeMainBtn extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const HomeMainBtn({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.light,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.gray,
          padding: EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(title, style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
