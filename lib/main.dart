import 'package:artfolio_app/pages/edit_profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:artfolio_app/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ArtfolioApp());
}

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
      routes: {
        '/editProfile': (context) => const EditProfilePage(),
      },
    );
  }
}
