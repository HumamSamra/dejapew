import 'package:dejapew/common/theme/app_theme.dart';
import 'package:dejapew/screens/homepage/home.imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Deja-Pew',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
