import 'dart:ui';
import 'package:blabla/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'registration_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:blabla/main_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                      margin: EdgeInsets.only(bottom: 9.0),
                      child: Image.asset(
                        'images/logo.png',
                        color: kLogoColor,
                      ),
                      height: 70.0,
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Container(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(
                          'Bla Bla',
                          textStyle: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: kTitleTextColor,
                              fontSize: 45.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                      isRepeatingAnimation: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            MainButton(
                color: Color(0xFF673AB7),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                label: 'Log In'),
            MainButton(
                color: kLogoColor,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                label: 'Register'),
          ],
        ),
      ),
    );
  }
}
