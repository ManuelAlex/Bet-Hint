import 'package:bet_hint/widghets/text_widghet.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {Key? key,
      required this.fct,
      required this.buttomText,
      this.primary = Colors.white38})
      : super(key: key);
  final Function fct;
  final String buttomText;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
          ),
          onPressed: () {
            fct();
          },
          child:
              TextWidget(text: buttomText, color: Colors.white, textSize: 18)),
    );
  }
}
