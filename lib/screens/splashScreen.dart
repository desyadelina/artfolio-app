// ignore_for_file: library_private_types_in_public_api, file_names

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
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedArtfolioText(),
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedStackTransition(),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF040207),
      duration: 5000,
      nextScreen: const GetStarted(),
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
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _sizeAnimation = Tween<double>(
      begin: 1.0,
      end: 50.0,
    ).animate(_sizeController);

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      _controller.reverse();
      Future.delayed(const Duration(milliseconds: 1500), () {
        _sizeController.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.5, 0.0),
            end: const Offset(0.2, 0.0),
          ).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.ease,
          )),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _sizeController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _sizeAnimation.value,
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFFF5307),
                        shape: CircleBorder(),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                child: Image.asset('assets/images/logo-white.png',
                    width: 31, height: 27),
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

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
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
    return FadeTransition(
      opacity: _controller,
      child: const Text(
        'Artfolio',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
