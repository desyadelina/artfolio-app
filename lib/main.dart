// import 'package:artfolio_app/screens/getStarted.dart';
import 'package:flutter/material.dart';
import 'package:artfolio_app/screens/splashScreen.dart';
// import 'package:artfolio_app/auth/signin.dart';

void main() => runApp(const ArtfolioApp());

class ArtfolioApp extends StatelessWidget {
  const ArtfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artfolio',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFFF5307),
        scaffoldBackgroundColor: const Color(0xFF040207),
      ),
      home: const SplashScreen(),
    );
  }
}