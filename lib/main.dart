import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      colorScheme: ColorScheme.fromSeed(seedColor: azureBlue),
      scaffoldBackgroundColor: iceBg,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.light().textTheme,
      ),
      useMaterial3: true,
    ),
    home: const SplashScreen(),
  );
}

