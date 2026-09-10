import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const TripNestApp());

class TripNestApp extends StatelessWidget {
  const TripNestApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TripNest',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: coral),
      scaffoldBackgroundColor: const Color(0xfff8f9fa),
      fontFamily: 'Arial',
      useMaterial3: true,
    ),
    home: const SplashScreen(),
  );
}
