import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DifficultyBtn extends StatelessWidget {
  final String title;
  final int size;
  final Function()? onTap;
  const DifficultyBtn({
    super.key,
    required this.title,
    required this.size,
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
            Row(
              children: [
                for (int i = 0; i < size; i++)
                  Icon(
                    Icons.star_rate_rounded,
                    size: 35,
                    color: AppColors.light,
                  ),
              ],
            ),
            Spacer(),
            Text(title, style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
