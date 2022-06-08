import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
const kHeroHight = 70.0;
const kHeroTag = 'logo';
const kTitleText = 'Bla Bla';
const kLogInButtonLabel = 'Log In';
const kRegisterButtonLabel = 'Register';
const kEmailHintText = 'Enter you email';
const kPasswordHintText = 'Enter your password';
const kTitleStyle = TextStyle(
  color: Color(0xFF60483A),
  fontSize: 45.0,
  fontWeight: FontWeight.w900,
);
const kSpaceBetweenTextFields = SizedBox(
  height: 8.0,
);
const kLogoSpace = SizedBox(
  width: 7.0,
);
const kSpaceTextFieldButton = SizedBox(
  height: 24.0,
);
const kWelcomeScreenHeroMargin = EdgeInsets.only(bottom: 9.0);
const kSpaceLogoAndButton = SizedBox(
  height: 60.0,
);
const kTextMessagePadding = EdgeInsets.fromLTRB(18, 8, 18, 0);
const kTextMessageStyle = TextStyle(
  fontSize: 10,
  color: Colors.red,
);
const kAppBarBackgroundColor = Colors.white;
const kOverallPadding = EdgeInsets.symmetric(horizontal: 16.0);
const kAnimationDuration = Duration(seconds: 1);
const kSendButtonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 14.0,
);
const kHeroHeightInLogAndReg = 200.0;
const kLogoPadding = EdgeInsets.all(12.0);
const kSpaceHeroAndInput = SizedBox(
  height: 42.0,
);
const kTextFieldPadding = EdgeInsets.symmetric(horizontal: 12.0);

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

const kCloseIcon = Icon(
  FontAwesomeIcons.xmark,
  color: kTitleTextColor,
);
const kChatTitleTextStyle = TextStyle(
    color: kTitleTextColor, fontWeight: FontWeight.w800, fontSize: 24);

const kMessageContainerMargin = EdgeInsets.fromLTRB(8, 8, 8, 8);
const kModalBottomSheetPadding = EdgeInsets.all(8.0);
const kAddAttachmentIcon = Icon(
  FontAwesomeIcons.plus,
  color: Colors.white,
);

//Chat screen constants
const kAttachmentPadding = EdgeInsets.all(8.0);
const kAttachmentIconsSize = 20.0;
const kAttachmentIconsColor = Colors.white;
const kListViewPadding = EdgeInsets.symmetric(horizontal: 8);
const kMessageBubblePadding = EdgeInsets.symmetric(vertical: 6.0);
const kSenderTextStyle = TextStyle(
  fontSize: 10,
  color: Color(0xFFD06E4F),
  fontWeight: FontWeight.bold,
);
const kMessagesPadding = EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
const kMessageTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);
const kFileIcon = Icon(
  FontAwesomeIcons.solidFile,
  color: Colors.white,
  size: 30.0,
);
const kFileTextSpace = SizedBox(
  width: 2.0,
);
const kFileMessageTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
);
const kFileMessageSizeStyle = TextStyle(
  fontSize: 10,
  color: Colors.white60,
);
const kMessageSpaceTime = SizedBox(
  width: 6.0,
);
const kMessageTextTimeStyle = TextStyle(
  fontSize: 10,
  color: Colors.white60,
);

//Main Button
const kMainButtonPadding = EdgeInsets.all(12.0);
const kMainButtonMinWidth = 200.0;
const kMainButtonHeight = 42.0;
const kMainButtonTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w700);
