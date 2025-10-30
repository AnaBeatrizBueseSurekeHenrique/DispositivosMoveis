import 'dart:math';

import 'package:apk_trabalho1/service/perenual_service.dart';
import 'package:apk_trabalho1/view/plantas_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class PlantPage extends StatefulWidget {
  final int id;
  const PlantPage({super.key, required this.id});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  int _currentId = 0;
  int _max_ids = 1000;
  final PerenualService perenualService = PerenualService();
  Map _plantData = {};
  bool _loadingMore = false;

  int generateRandomNumber(int min, int max) {
    return min + Random().nextInt((max + 1) - min);
  }

  @override
  void initState() {
    _currentId = widget.id;

    super.initState();
    _checkValue();
    if (_currentId == 0) {
      _currentId = generateRandomNumber(0, _max_ids);
    }
    _loadPlant();
  }

  void _checkValue() async {
    var plantsData = await perenualService.getPlantsByName(" ", 1);
    _max_ids = plantsData["total"];
  }

  void _loadPlant() async {
    setState(() {
      _loadingMore = true;
    });
    var plant = await perenualService.getPlantById(_currentId);

    setState(() {
      _loadingMore = false;
      _plantData.addAll(plant);
    });
  }

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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlantasPage()),
            ),
            icon: Icon(Icons.search),
            color: const Color.fromARGB(255, 242, 251, 255),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
      body: _plantData.isEmpty ? loadingIndicator() : createPlant(),
    );
  }

  Widget createPlant() {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Column(
        spacing: 10.0,
        children: [
          Center(
            child: Container(
              width: 400,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(receberImagem()),
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 170, 205, 188),
            child: Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      _plantData["common_name"],
                      style: GoogleFonts.timmana(
                        textStyle: TextStyle(
                          color: const Color.fromARGB(255, 242, 251, 255),
                          letterSpacing: .5,
                          fontSize: 26.0,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 1,
                    color: const Color.fromARGB(255, 242, 255, 249),
                    indent: 5,
                    endIndent: 5,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      _plantData["scientific_name"][0],
                      style: GoogleFonts.arima(
                        color: const Color.fromARGB(255, 248, 255, 252),
                      ),
                    ),
                  ),
                  Text(
                    _plantData["description"],
                    style: TextStyle(color: const Color.fromARGB(255, 9, 9, 9)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_florist_rounded,
                        color: const Color.fromARGB(255, 34, 53, 42),
                      ),
                      verifica("flowers"),
                      SizedBox(width: 10),
                      Icon(
                        Icons.local_restaurant,
                        color: const Color.fromARGB(255, 34, 53, 42),
                      ),
                      verifica("edible_leaf"),
                      SizedBox(width: 10),
                      Icon(
                        Icons.house,
                        color: const Color.fromARGB(255, 34, 53, 42),
                      ),
                      verifica("indoor"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          botoesFimPagina(),
        ],
      ),
    );
  }

  Widget verifica(String item) {
    if (_plantData[item]) {
      return Icon(Icons.check, color: const Color.fromARGB(255, 81, 148, 156));
    } else {
      return Icon(Icons.close, color: Colors.redAccent);
    }
  }

  Widget loadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          const Color.fromARGB(255, 71, 166, 122),
        ),
        strokeWidth: 5.0,
      ),
    );
  }

  String receberImagem() {
    var img;
    try {
      img = _plantData["default_image"]["regular_url"];
    } on NoSuchMethodError catch (e) {
      img =
          'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';
    }
    print(_max_ids);
    img ??=
        'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';
    return img;
  }

  Widget botoesFimPagina() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: <Widget>[verificaFlechaBack(), verificaFlechaFoward()],
    );
  }

  Widget verificaFlechaBack() {
    if (_currentId > 1) {
      return GestureDetector(
        onTap: !_loadingMore
            ? () {
                setState(() {
                  _loadingMore = true;

                  _currentId -= 1;
                  _plantData.clear();
                });
                _loadPlant();
              }
            : null,
        child: Container(
          color: const Color.fromARGB(255, 71, 166, 122),
          child: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 242, 251, 255),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget verificaFlechaFoward() {
    if (_currentId < _max_ids) {
      return GestureDetector(
        onTap: !_loadingMore
            ? () {
                setState(() {
                  _loadingMore = true;

                  _currentId += 1;
                  _plantData.clear();
                });
                _loadPlant();
              }
            : null,

        child: Container(
          color: const Color.fromARGB(255, 71, 166, 122),
          child: Icon(
            Icons.arrow_forward,
            color: const Color.fromARGB(255, 242, 251, 255),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
