import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFF5307),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 80, 25, 25),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Build a portfolio that reflects your style ",
                      style: const TextStyle(
                        color: Color(0xFFDEDEDE),
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                      children: [
                        WidgetSpan(
                          baseline: TextBaseline.alphabetic,
                          alignment: PlaceholderAlignment.middle,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/nextScreen');
                            },
                            icon: const Icon(
                              FontAwesomeIcons.arrowRightLong,
                              color: Color(0xFFDEDEDE),
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/covergetstarted.png'), // Replace with your image path
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}