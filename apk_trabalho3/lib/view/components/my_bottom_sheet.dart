import 'package:flutter/material.dart';

class MyBottomSheet extends StatelessWidget {
  MyBottomSheet({super.key, required this.itens});
  List<Widget> itens;
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: itens),
        );
      },
    );
  }
}
