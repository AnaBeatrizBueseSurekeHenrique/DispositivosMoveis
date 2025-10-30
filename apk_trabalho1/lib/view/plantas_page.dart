import 'package:apk_trabalho1/service/perenual_service.dart';
import 'package:apk_trabalho1/view/plant_page.dart';
import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantasPage extends StatefulWidget {
  const PlantasPage({super.key});

  @override
  State<PlantasPage> createState() => _PlantasPageState();
}

class _PlantasPageState extends State<PlantasPage> {
  String _search = "";
  int _page = 1;
  bool _loadingMore = false;
  bool _isSearching = false;
  List _picturesData = [];
  bool _hasPictures = false;
  int _maxpage = 0;
  int _total = 1;
  final PerenualService perenualService = PerenualService();
  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  void _loadPlants() async {
    setState(() {
      _loadingMore = true;
    });
    var newPlants = await perenualService.getPlantsByName(_search, _page);
    setState(() {
      _maxpage = newPlants["last_page"];
      _total = newPlants["total"];
      _loadingMore = false;
      _picturesData.addAll(newPlants["data"]);
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
      ),
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 225, 255, 210),
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(color: Color.fromARGB(255, 0, 140, 95)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 19, 19, 51),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 223, 215, 231),
                  ),
                ),
              ),

              style: TextStyle(color: Colors.black, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  _search = value;
                  _page = 1;
                  _picturesData.clear();
                  _isSearching = true;
                });
                _loadPlants();
              },
            ),
          ),
          Expanded(
            child:
                (_picturesData.isEmpty && !_loadingMore && _isSearching) ||
                    _picturesData.length <= 0
                ? _total == 0
                      ? semPlantas()
                      : loadingIndicator()
                : createPlantTable(),
          ),
        ],
      ),
    );
  }

  Widget semPlantas() {
    return Text("Não existem plantas com esse nome!");
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

  Widget createPlantTable() {
    return Padding(
      padding: EdgeInsetsGeometry.all(10.0),
      child: ListView.builder(
        itemCount: _picturesData.length + 1,
        itemBuilder: (context, int index) {
          if (index < _picturesData.length) {
            var picture = _picturesData[index];
            var id = picture["id"];
            var pictureURL;
            var pictureName = picture["common_name"].toString().toCapitalCase();
            var otherNames = "";
            var aux = (picture["other_name"] as List).length;

            if (aux > 0) {
              otherNames = "Também conhecida como: |";
            }
            for (var i = 0; i < aux; i++) {
              otherNames +=
                  "${picture["other_name"][i].toString().toCapitalCase()}|";
            }
            var scientificName = "";
            try {
              scientificName = picture["scientific_name"][0]
                  .toString()
                  .toCapitalCase();
            } on RangeError catch (e) {
              scientificName = "";
            }
            try {
              pictureURL = picture["default_image"]["regular_url"];
            } on NoSuchMethodError catch (e) {
              pictureURL =
                  'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';
            }

            pictureURL ??=
                'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';

            return campoPlanta(
              pictureName,
              pictureURL,
              scientificName,
              otherNames,
              id,
            );
          } else {
            return botoesFimPagina();
          }
        },
      ),
    );
  }

  Widget campoPlanta(
    String pictureName,
    String pictureURL,
    String scientificName,
    String otherNames,
    int id,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlantPage(id: id)),
          );
        },
        child: Container(
          color: const Color.fromARGB(255, 170, 205, 188),
          child: Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: Row(
              spacing: 16.0,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color.fromARGB(255, 223, 215, 231),
                      width: 2,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(pictureURL),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        pictureName,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      Divider(
                        height: 10,
                        thickness: 1,
                        color: const Color.fromARGB(255, 139, 177, 172),
                        indent: 16,
                        endIndent: 16,
                      ),
                      verificaNomeCientifico(scientificName),
                      Text(
                        otherNames,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget verificaNomeCientifico(String name) {
    if (name != "") {
      return Column(
        children: [
          Text(
            name,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          Divider(
            height: 10,
            thickness: 1,
            color: const Color.fromARGB(255, 139, 177, 172),
            indent: 60,
            endIndent: 60,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget botoesFimPagina() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: <Widget>[
        verificaFlechaBack(),
        Text("Page $_page / $_maxpage"),
        verificaFlechaFoward(),
      ],
    );
  }

  Widget verificaFlechaBack() {
    if (_page > 1) {
      return GestureDetector(
        onTap: !_loadingMore
            ? () {
                setState(() {
                  _loadingMore = true;

                  _page -= 1;
                  _picturesData.clear();
                });
                _loadPlants();
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
    if (_page < _maxpage) {
      return GestureDetector(
        onTap: !_loadingMore
            ? () {
                setState(() {
                  _loadingMore = true;

                  _page += 1;
                  _picturesData.clear();
                });
                _loadPlants();
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
