import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ModeBtn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const ModeBtn({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

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
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            Spacer(),
            Text(title, style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
