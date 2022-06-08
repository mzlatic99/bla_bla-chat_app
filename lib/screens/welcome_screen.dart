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
    controller = AnimationController(vsync: this, duration: kAnimationDuration);
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
        padding: kOverallPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: kLogoPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Hero(
                    tag: kHeroTag,
                    child: Container(
                      margin: kWelcomeScreenHeroMargin,
                      child: Image.asset(
                        'images/logo.png',
                        color: kLogoColor,
                      ),
                      height: kHeroHight,
                      alignment: Alignment.bottomLeft,
                    ),
                  ),
                  kLogoSpace,
                  AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(
                        kTitleText,
                        textStyle: GoogleFonts.nunito(textStyle: kTitleStyle),
                      ),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ],
              ),
            ),
            kSpaceHeroAndInput,
            MainButton(
                color: kMainColor,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                label: kLogInButtonLabel),
            MainButton(
                color: kLogoColor,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                label: kRegisterButtonLabel),
          ],
        ),
      ),
    );
  }
}
