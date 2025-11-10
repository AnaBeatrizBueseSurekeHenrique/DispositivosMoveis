import 'package:apk_trabalho2/view/components/my_textButton.dart';
import 'package:flutter/material.dart';

class MyBottomsheet extends StatelessWidget {
  MyBottomsheet({super.key, required this.itens});
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
