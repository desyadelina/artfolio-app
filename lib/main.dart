import 'package:flutter/material.dart';
import 'package:artfolio_app/screens/splashScreen.dart';

void main() => runApp(const ArtfolioApp());

class ArtfolioApp extends StatelessWidget {
  const ArtfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artfolio',
      theme: ThemeData(
<<<<<<< HEAD
        colorSchemeSeed: const Color(0xFFFF5307),
=======
>>>>>>> 4534411ee3780bd6f3cd4f5a296a6298d9dba341
        scaffoldBackgroundColor: const Color(0xFF040207),
      ),
      home: const SplashScreen(),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 4534411ee3780bd6f3cd4f5a296a6298d9dba341
