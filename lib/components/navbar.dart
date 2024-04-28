import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: const Color(0xFFFF5307),
      color: const Color(0xFF111114),
      animationDuration: const Duration(milliseconds: 400),
      height: 65,
      items: [
        SvgPicture.asset('assets/svg/home-angle.svg', height: 30, color: Colors.white),
        SvgPicture.asset('assets/svg/search.svg', height: 30, color: Colors.white),
        SvgPicture.asset('assets/svg/add.svg', height: 30, color: Colors.white),
        SvgPicture.asset('assets/svg/user-rounded.svg', height: 30, color: Colors.white),
      ],
      onTap: onTap, 
    );
  }
}