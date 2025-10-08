import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CuidadosPage extends StatefulWidget {
  const CuidadosPage({super.key});

  @override
  State<CuidadosPage> createState() => _CuidadosPageState();
}

class _CuidadosPageState extends State<CuidadosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 71, 166, 122),
        title: Text(
          "Plantas",
          style: GoogleFonts.aBeeZee(
            textStyle: TextStyle(
              color: const Color.fromARGB(255, 242, 251, 255),
              letterSpacing: .5,
            ),
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            onPressed: () => print("busca!"),
            icon: Icon(Icons.search),
            color: const Color.fromARGB(255, 242, 251, 255),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
    );
  }
}
