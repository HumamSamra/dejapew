import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeOutlineBtn extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const HomeOutlineBtn({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 6),
          side: BorderSide(color: AppColors.primary, width: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 30, color: AppColors.light),
        ),
      ),
    );
  }
}
