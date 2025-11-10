import 'package:flutter/material.dart';

class MyDropdownbutton extends StatelessWidget {
  MyDropdownbutton({
    super.key,
    required this.itens,
    required this.onChanged,
    required this.icon,
    required this.label,
  });
  List<String> itens;
  ValueChanged<String?>? onChanged;
  IconData icon;
  var label;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 45,
      color: Color.fromARGB(255, 255, 189, 189),
      child: DropdownMenu(
        dropdownMenuEntries: itens.map<DropdownMenuEntry<String>>((
          String value,
        ) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
        showTrailingIcon: false,
        leadingIcon: Icon(icon),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: null,
          border: null,
          isCollapsed: true,
        ),
        menuStyle: MenuStyle(alignment: Alignment.center),
      ),
    );
  }
}
