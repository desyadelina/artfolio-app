// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:artfolio_app/screens/getStarted.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedArtfolioText(),
            AnimatedStackTransition(),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF040207),
      nextScreen: const GetStarted(),
      duration: 3000,
    );
  }
}

class AnimatedStackTransition extends StatefulWidget {
  const AnimatedStackTransition({Key? key}) : super(key: key);

  @override
  _AnimatedStackTransitionState createState() =>
      _AnimatedStackTransitionState();
}

class _AnimatedStackTransitionState extends State<AnimatedStackTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Forward animation
    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    // Reverse animation
    Future.delayed(const Duration(milliseconds: 3000), () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.3, 0.0),
          ).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          )),
          child: Stack(
            alignment: Alignment.center,
            children: [

              Container(
                width: 55,
                height: 55,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFF5307),
                  shape: CircleBorder(),
                ),
              ),
              Positioned(
                child: Image.asset('assets/images/white.png'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AnimatedArtfolioText extends StatefulWidget {
  const AnimatedArtfolioText({Key? key}) : super(key: key);

  @override
  _AnimatedArtfolioTextState createState() => _AnimatedArtfolioTextState();
}

class _AnimatedArtfolioTextState extends State<AnimatedArtfolioText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    Future.delayed(const Duration(milliseconds: 5), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Text(
        'Artfolio',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
