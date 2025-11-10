import 'package:flutter/material.dart';

class MyTextbutton extends StatelessWidget {
  MyTextbutton({super.key, required this.onPressed, required this.text});
  Function()? onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.black)),
    );
  }
}
