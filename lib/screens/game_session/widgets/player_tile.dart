import 'package:dejapew/common/theme/app_colors.dart';
import 'package:dejapew/common/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PlayerTile extends StatelessWidget {
  final String playerName;
  final int score;
  final bool playerTurn;
  final Duration? remaining;
  const PlayerTile({
    super.key,
    required this.playerName,
    required this.score,
    required this.playerTurn,
    this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        title: Row(
          children: [
            Text(
              playerName,
              maxLines: 1,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 30, color: AppColors.light),
            ),
            Gap(10),
            if (remaining != null)
              Text(
                '(${Utils.formatTime(remaining!)})',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22,
                  color: remaining!.inSeconds < 10
                      ? AppColors.primary
                      : AppColors.light,
                ),
                textDirection: TextDirection.rtl,
              ),
          ],
        ),
        subtitle: Text(
          'النقاط : $score',
          style: TextStyle(fontSize: 20, color: AppColors.darklight),
        ),
        trailing: Text(
          playerTurn ? '(دورك)' : '(انتظر دورك)',
          style: TextStyle(
            color: playerTurn ? AppColors.primary : AppColors.gray,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
