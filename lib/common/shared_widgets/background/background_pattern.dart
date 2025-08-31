import 'package:dejapew/common/enums/bg_pattern_type.dart';
import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class BackgroundPattern extends StatelessWidget {
  final List<Widget> children;
  final BgPatternType pattern;
  const BackgroundPattern({
    super.key,
    this.children = const [],
    required this.pattern,
  });

  @override
  Widget build(BuildContext context) {
    final patternPath =
        'assets/svg_patterns/${pattern.name.replaceAll('_', '-')}.svg';
    return Center(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Color.fromRGBO(234, 231, 235, .07),
                  BlendMode.srcIn,
                ),
                image: Svg(patternPath),
                repeat: ImageRepeat.repeat,
                fit: BoxFit.none,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
