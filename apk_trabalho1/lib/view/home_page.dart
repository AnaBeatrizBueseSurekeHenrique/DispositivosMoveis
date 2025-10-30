import 'dart:math';

import 'package:apk_trabalho1/service/perenual_service.dart';
import 'package:apk_trabalho1/view/plant_page.dart';
import 'package:apk_trabalho1/view/plantas_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
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
      ),
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: Text(
              "Páginas",
              style: GoogleFonts.abyssinicaSil(
                textStyle: TextStyle(
                  color: const Color.fromARGB(255, 71, 166, 122),
                  letterSpacing: .5,
                  fontSize: 35.0,
                ),
              ),
            ),
          ),
          quadradoPagina(
            "Ver Plantas",
            "assets/imgs/plantas.JPG",
            context,
            PlantasPage(),
          ),
          quadradoPagina(
            "Planta Aleatória",
            "assets/imgs/doencas.jpg",
            context,
            PlantPage(id: 0),
          ),
        ],
      ),
    );
  }

  Widget quadradoPagina(
    String nomePagina,
    String imagem,
    BuildContext context,
    StatefulWidget pagina,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10.0),
      child: GestureDetector(
        child: Container(
          width: 390.0,
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagem),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: const Color.fromARGB(255, 45, 46, 46)),
          ),
          child: Align(
            child: Padding(
              padding: EdgeInsetsGeometry.all(20.0),

              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  color: const Color.fromARGB(102, 255, 255, 255),
                  child: Align(
                    alignment: Alignment
                        .center, // Align however you like (i.e .centerRight, centerLeft)
                    child: Text(
                      nomePagina,
                      style: GoogleFonts.abel(
                        textStyle: TextStyle(
                          color: const Color.fromARGB(255, 31, 61, 32),
                          letterSpacing: .5,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pagina),
        ),

        /** T,*/
      ),
    );
  }
}
