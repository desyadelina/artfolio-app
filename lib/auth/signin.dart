// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api, use_build_context_synchronously
import 'package:artfolio_app/components/button.dart';
import 'package:artfolio_app/components/input.dart';
import 'package:artfolio_app/components/appbar.dart';
import 'package:artfolio_app/components/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:artfolio_app/services/auth_service.dart'; 

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xDEDEDEDE),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Image.asset('assets/images/logo-white.png', width: 31, height: 27),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: screenSize.width,
                    height: screenSize.height,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(color: Color(0xFF040207)),
                    child: Form(
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 66,
                            child: Container(
                              width: screenSize.width,
                              height: screenSize.height * 0.51,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/bg-signin.png"),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: screenSize.width * 0.10,
                            top: screenSize.height * 0.57,
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
                            top: screenSize.height * 0.62,
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
                              iconColor: const Color(0xFFFF5307),
                              controller: _email,
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
                              iconColor: const Color(0xFFFF5307),
                              controller: _password,
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
                              onPressed: () async {
                                User? user = await _authService.signInWithEmailAndPassword(
                                  _email.text,
                                  _password.text,
                                );
                                if (user != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Index(),
                                    ),
                                  );
                                } else {
                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to sign in. Please check your email and password.')),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
