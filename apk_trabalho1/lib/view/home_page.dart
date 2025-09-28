import 'package:apk_trabalho1/service/perenual_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    _loadPictures();
  }

  void _loadPictures() async {
    setState(() {
      _loadingMore = true;
    });
    var newPictures = await perenualService.getPlantsByName(_search, _page);
    setState(() {
      _loadingMore = false;
      _picturesData.addAll(newPictures["data"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 251, 255),
        title: Text(
          "Perenual",
          style: GoogleFonts.aBeeZee(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 0, 140, 95),
              letterSpacing: .5,
            ),
          ),
        ),
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
                _loadPictures();
              },
            ),
          ),
          Expanded(
            child: _picturesData.isEmpty && !_loadingMore && _isSearching
                ? gifLoadingIndiator()
                : createGifTable(),
          ),
        ],
      ),
    );
  }

  Widget gifLoadingIndiator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          const Color.fromARGB(255, 0, 0, 0),
        ),
        strokeWidth: 5.0,
      ),
    );
  }

  Widget createGifTable() {
    bool hasmorePictures = _picturesData.length < 30;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _picturesData.length + 1,
      padding: EdgeInsets.all(10.0),
      itemBuilder: (context, index) {
        if (index < 30) {
          var picture = _picturesData[index];
          var pictureURL;
          var pictureName = picture["common_name"];
          try {
            pictureURL = picture["default_image"]["regular_url"];
          } on Exception catch (exception) {
            pictureURL =
                'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';
          } catch (error) {
            pictureURL =
                'https://upload.wikimedia.org/wikipedia/commons/6/6c/Arabic_Question_Mark_%28RTL%29.gif?20080603193111';
          }

          return GestureDetector(
            child: Row(
              children: [
                Image.network(pictureURL, height: 200.0, fit: BoxFit.cover),
                Text(pictureName, style: TextStyle(color: Colors.amber)),
              ],
            ),
            /*child: Image.network(pictureURL, height: 300.0, fit: BoxFit.cover)*/
            onTap: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GifPage(gif)),
              );*/
              print(picture);
            },
          );
        } else {
          return GestureDetector(
            onTap: !_loadingMore
                ? () {
                    setState(() {
                      _loadingMore = true;
                      _page++;
                    });
                    _loadPictures();
                  }
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: Colors.white, size: 70.0),
                Text(
                  "Carregar mais...",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
