import 'package:fitness_tracker/app/theme/app_theme.dart';
import 'package:fitness_tracker/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartNews Nepal',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
