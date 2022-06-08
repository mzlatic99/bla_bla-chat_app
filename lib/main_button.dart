import 'package:blabla/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainButton extends StatelessWidget {
  MainButton(
      {required this.color, required this.onPressed, required this.label});
  final Color color;
  final Function() onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kMainButtonPadding,
      child: Material(
        elevation: 4.0,
        color: color,
        borderRadius: BorderRadius.circular(24.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: kMainButtonMinWidth,
          height: kMainButtonHeight,
          child: Text(
            label,
            style: GoogleFonts.nunito(
              textStyle: kMainButtonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
