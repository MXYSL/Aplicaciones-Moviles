import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FoodLabApp());
}

class FoodLabApp extends StatelessWidget {
  const FoodLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodLab',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
