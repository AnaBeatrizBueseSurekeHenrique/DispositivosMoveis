import 'package:apk_trabalho1/service/perenual_service.dart';
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
        actions: <Widget>[
          IconButton(
            onPressed: () => print("busca!"),
            icon: Icon(Icons.search),
            color: const Color.fromARGB(255, 242, 251, 255),
          ),
        ],
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
            child: _picturesData.isEmpty && !_loadingMore && _isSearching
                ? gifLoadingIndicator()
                : createPlantTable(),
          ),
        ],
      ),
    );
  }

  Widget gifLoadingIndicator() {
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
        itemCount: _picturesData.length,
        itemBuilder: (context, int index) {
          if (_picturesData.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color.fromARGB(255, 71, 166, 122),
                ),
                strokeWidth: 5.0,
              ),
            );
          } else {
            var picture = _picturesData[index];
            var pictureURL;
            var pictureName = picture["common_name"];
            var scienticName = picture["scientific_name"][0];
            try {
              pictureURL = picture["default_image"]["regular_url"];
            } on Exception catch (exception) {
              pictureURL =
                  'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';
            } catch (error) {
              pictureURL =
                  'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';
            }
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 5.0),
              child: GestureDetector(
                child: Container(
                  color: const Color.fromARGB(255, 170, 205, 188),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(10.0),
                    child: Row(
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
                        Column(
                          children: [
                            Text(
                              pictureName,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Text(
                              scienticName,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
