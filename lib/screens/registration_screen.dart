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
        progressIndicator: CircularProgressIndicator(),
        color: kTitleTextColor,
        opacity: 0.3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset(
                      'images/logo.png',
                      color: kLogoColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 42.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter you email'),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: Text(message,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                    )),
              ),
              SizedBox(
                height: 24.0,
              ),
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
