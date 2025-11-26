import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  MyIconButton({super.key, required this.icon, required this.onTap});
  final IconData icon;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        color: Color.fromARGB(255, 255, 189, 189),

        child: Icon(icon, color: Color.fromARGB(255, 252, 249, 234)),
      ),
    );
  }
}
