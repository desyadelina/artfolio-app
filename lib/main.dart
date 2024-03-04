import 'package:flutter/material.dart';
import 'package:artfolio_app/screens/splashScreen.dart';

void main() => runApp(ArtfolioApp());

class ArtfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artfolio',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SplashScreen(),
    );
  }
}
