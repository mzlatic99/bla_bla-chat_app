import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kLogInButtonColor = Color(0xFFF6663C);
const kRegisterButtonColor = Color(0xFFDEA493);
const kTitleTextColor = Color(0xFF60483A);
const kLogoColor = Color(0xFFD06E4F);
const kScaffoldColor = Color(0xFFF4E4DC);
const kChatTextColor = Color(0xFF130A09);
const kContainerTopShadowColor = Color(0xFFCD856D);
const kBubbleColor = Color(0xFF508475);
const kMainColor = Color(0xFF673AB7);
const kSecundaryBubble = Color(0xFF0097A7);

const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(24.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(24.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(24.0)),
  ),
);

const kMessageContainerDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(24)),
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(24.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(24.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.all(Radius.circular(24.0)),
  ),
);
