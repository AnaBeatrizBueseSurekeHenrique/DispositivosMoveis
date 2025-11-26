import 'package:flutter/material.dart';

class MyColorCircle extends StatelessWidget {
  MyColorCircle({super.key, required this.color});
  String color;
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle_rounded,
      color: color == "Amarelo"
          ? const Color.fromARGB(255, 255, 218, 126)
          : color == "Azul"
          ? const Color.fromARGB(255, 107, 164, 243)
          : color == "Branco"
          ? Colors.white
          : color == "Verde"
          ? Color.fromARGB(255, 186, 223, 219)
          : color == "Laranja"
          ? Color.fromARGB(255, 253, 183, 135)
          : color == "Rosa"
          ? const Color.fromARGB(255, 255, 164, 241)
          : const Color.fromARGB(255, 248, 130, 122),
      shadows: [
        Shadow(
          color: Color.fromARGB(255, 252, 249, 234),
          blurRadius: 8.0,
          offset: Offset(0, 0),
        ),
        Shadow(
          color: Color.fromARGB(255, 252, 249, 234),
          blurRadius: 8.0,
          offset: Offset(0, 0),
        ),
        Shadow(
          color: Color.fromARGB(255, 252, 249, 234),
          blurRadius: 8.0,
          offset: Offset(0, 0),
        ),
        Shadow(
          color: Color.fromARGB(255, 252, 249, 234),
          blurRadius: 8.0,
          offset: Offset(0, 0),
        ),
      ],
    );
  }
}
