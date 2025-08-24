import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final AppBar? appBar;
  const AppScaffold({
    super.key,
    this.useSafeArea = false,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return useSafeArea
        ? SafeArea(
            child: Scaffold(appBar: appBar, body: child),
          )
        : Scaffold(appBar: appBar, body: child);
  }
}
