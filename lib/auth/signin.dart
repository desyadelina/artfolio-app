// ignore_for_file: prefer_const_constructors

import 'package:artfolio_app/components/button.dart';
import 'package:artfolio_app/components/input.dart';
import 'package:artfolio_app/components/topbar.dart';
import 'package:artfolio_app/pages/discover.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: screenSize.width,
                height: screenSize.height,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Color(0xFF040207)),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: screenSize.width,
                        height: screenSize.height * 0.61,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/bg-signin.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenSize.width * 0.10,
                      top: screenSize.height * 0.55,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    Positioned(
                      left: screenSize.width * 0.10,
                      top: screenSize.height * 0.60,
                      child: const Text(
                        'Please sign in to continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenSize.height * 0.66,
                      left: screenSize.width * 0.10,
                      child: CustomInput(
                        placeholder: 'E-mail address',
                        icon: Icons.mail_outline_rounded,
                        controller: TextEditingController(),
                        width: screenSize.width * 0.84,
                        height: screenSize.height * 0.06,
                      ),
                    ),
                    Positioned(
                      top: screenSize.height * 0.75,
                      left: screenSize.width * 0.10,
                      child: CustomInput(
                        placeholder: 'Password',
                        icon: Icons.lock_outline_rounded,
                        controller: TextEditingController(),
                        width: screenSize.width * 0.84,
                        height: screenSize.height * 0.06,
                      ),
                    ),
                    Positioned(
                      top: screenSize.height * 0.85,
                      left: screenSize.width * 0.10,
                      child: CustomButton(
                        width: screenSize.width * 0.84,
                        height: screenSize.height * 0.06,
                        buttonText: 'Sign In',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiscoverPage()),
                          );
                        },
                      ),
                    ),
                    // Positioned(
                    //   top: screenSize.height * 0.90,
                    //   child: CheckboxListTile(
                    //     onChanged: (value) {},
                    //     value: null,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          // Positioned(
          //   top: 31,
          //   left: 18,
          //   right: 18,
          //   child: MyTopBar(
          //     isSignIn: true,
          //   ),
          // ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SignInPage(),
  ));
}
