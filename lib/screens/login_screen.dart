import 'package:blabla/constants.dart';
import 'package:blabla/main_button.dart';
import 'package:blabla/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  late String email;
  late String password;
  String message = '';
  bool _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: kScaffoldColor,
      body: LoadingOverlay(
        isLoading: _saving,
        opacity: 0.3,
        progressIndicator: const CircularProgressIndicator(),
        color: kTitleTextColor,
        child: Padding(
          padding: kOverallPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                  color: kLogInButtonColor,
                  onPressed: () async {
                    setState(() {
                      _saving = true;
                    });
                    try {
                      final credential =
                          await _mAuth.signInWithEmailAndPassword(
                              email: email, password: password);
                      if (credential != null) {
                        Navigator.pushNamedAndRemoveUntil(context,
                            ChatScreen.id, (Route<dynamic> route) => false);
                      }
                      setState(() {
                        _saving = false;
                        message = '';
                        FocusScope.of(context).unfocus();
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        setState(() {
                          message = 'No user found for that email.';
                          _saving = false;
                          FocusScope.of(context).unfocus();
                        });
                      } else if (e.code == 'wrong-password') {
                        setState(() {
                          message = 'Wrong password provided for that user.';
                          _saving = false;
                          FocusScope.of(context).unfocus();
                        });
                      } else if (e.code == 'invalid-email') {
                        print(e);
                        setState(() {
                          _saving = false;
                          message = 'The email address is badly formatted.';
                          FocusScope.of(context).unfocus();
                        });
                      } else {
                        _saving = false;
                        message = 'Error';
                        FocusScope.of(context).unfocus();
                      }
                    }
                  },
                  label: 'Log In')
            ],
          ),
        ),
      ),
    );
  }
}
