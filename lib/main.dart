// import 'package:artfolio_app/screens/getStarted.dart';
import 'package:flutter/material.dart';
import 'package:artfolio_app/screens/splashScreen.dart';
// import 'package:artfolio_app/auth/signin.dart';

void main() => runApp(ArtfolioApp());

class ArtfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artfolio',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 18, 32, 47),
      ),
      home: const SplashScreen(),
    );
  }
}
