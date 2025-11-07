import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextfield extends StatelessWidget {
  MyTextfield({
    super.key,
    required this.onChanged,
    required this.maxSize,
    required this.controller,
    required this.labelText,
    required this.type,
    required this.sizeContainer,
    required this.maxLines,
  });
  ValueChanged onChanged;
  int maxSize;
  TextEditingController controller;
  String labelText;
  TextInputType type;
  double sizeContainer;
  int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeContainer,
      color: Color.fromARGB(255, 255, 189, 189),

      child: TextField(
        maxLines: maxLines,
        controller: controller,
        inputFormatters: [LengthLimitingTextInputFormatter(maxSize)],
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 164, 164),
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 164, 164),
              width: 3.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        onChanged: onChanged,
        keyboardType: type,
      ),
    );
  }
}
