import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextfield extends StatelessWidget {
  MyTextfield({
    super.key,
    required this.onChanged,
    required this.maxSize,
    required this.controller,
    this.labelText,
    required this.type,
    required this.sizeContainer,
    required this.maxLines,
    required this.color,
    this.onSubmmited,
    this.hintText,
    this.mask,
    this.obscureText,
  });
  ValueChanged onChanged;
  int maxSize;
  TextEditingController controller;
  String? labelText;
  TextInputType type;
  double sizeContainer;
  int maxLines;
  Color color;
  ValueChanged? onSubmmited;
  String? hintText;
  TextInputFormatter? mask;
  bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeContainer,
      color: Color.fromARGB(255, 255, 189, 189),

      child: TextField(
        maxLines: maxLines,
        controller: controller,
        style: GoogleFonts.aBeeZee(color: Color.fromARGB(255, 252, 249, 234)),
        inputFormatters: mask == null
            ? [LengthLimitingTextInputFormatter(maxSize)]
            : [LengthLimitingTextInputFormatter(maxSize), mask!],
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color.fromARGB(255, 54, 44, 49)),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color,
              width: 3.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        onChanged: onChanged,
        keyboardType: type,
        onSubmitted: onSubmmited,
        obscureText: obscureText ?? false,
      ),
    );
  }
}
