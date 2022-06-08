import 'package:blabla/constants.dart';
import 'package:blabla/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool _saving = false;
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      body: LoadingOverlay(
        isLoading: _saving,
        progressIndicator: const CircularProgressIndicator(),
        color: kTitleTextColor,
        opacity: 0.3,
        child: Padding(
          padding: kOverallPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: kHeroTag,
                  child: SizedBox(
                    height: kHeroHeightInLogAndReg,
                    child: Image.asset(
                      'images/logo.png',
                      color: kLogoColor,
                    ),
                  ),
                ),
              ),
              kSpaceHeroAndInput,
              Padding(
                padding: kTextFieldPadding,
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      kTextFieldDecoration.copyWith(hintText: kEmailHintText),
                ),
              ),
              kSpaceBetweenTextFields,
              Padding(
                padding: kTextFieldPadding,
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: kPasswordHintText),
                ),
              ),
              Padding(
                padding: kTextMessagePadding,
                child: Text(message, style: kTextMessageStyle),
              ),
              kSpaceTextFieldButton,
              MainButton(
                  color: kLogoColor,
                  onPressed: () async {
                    setState(() {
                      _saving = true;
                    });
                    try {
                      final newUser =
                          await _mAuth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            ChatScreen.id, (Route<dynamic> route) => false);
                      }
                      setState(() {
                        _saving = false;
                        message = '';
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        setState(() {
                          message = 'The password provided is too weak.';
                          _saving = false;
                        });
                      } else if (e.code == 'email-already-in-use') {
                        setState(() {
                          message =
                              'The account already exists for that email.';
                          _saving = false;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  label: 'Register'),
            ],
          ),
        ),
      ),
    );
  }
}
