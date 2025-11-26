import 'dart:io';
import 'dart:math';

import 'package:apk_trabalho3/model/flower_model.dart';
import 'package:apk_trabalho3/service/flower_service.dart';
import 'package:apk_trabalho3/service/login_service.dart';
import 'package:apk_trabalho3/view/components/my_bottom_sheet.dart';
import 'package:apk_trabalho3/view/components/my_icon_button.dart';
import 'package:apk_trabalho3/view/components/my_text_button.dart';
import 'package:apk_trabalho3/view/components/my_textfield.dart';
import 'package:apk_trabalho3/view/flower_edit_page.dart';
import 'package:apk_trabalho3/view/flower_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum OrderNameOptions { orderAz, orderZa }

enum OrderPriceOptions { orderExpensive, orderCheap }

class _HomePageState extends State<HomePage> {
  FlowerService flowerService = FlowerService();
  List<OrderPriceOptions> ordens = [
    OrderPriceOptions.orderCheap,
    OrderPriceOptions.orderExpensive,
  ];
  final _searchController = TextEditingController();
  bool pesquisa = false;
  final user = FirebaseAuth.instance.currentUser!;
  Stream<QuerySnapshot<Object?>> currentStream = Stream.empty();
  String textoVazio = "Não há flores cadastradas!";
  final loginService = LoginService();

  @override
  void initState() {
    super.initState();
    currentStream = flowerService.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 164, 164),

        actions: barraInicial(),
      ),
      backgroundColor: Color.fromARGB(255, 248, 242, 227),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEditPage,
        backgroundColor: Color.fromARGB(255, 186, 223, 219),
        child: Icon(Icons.add, color: Color.fromARGB(255, 252, 249, 234)),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: currentStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Houve um erro ao carregar os dados!"));
            } else {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 189, 189),
                  ),
                );
              } else {
                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text(textoVazio));
                }
              }
            }
            List flowerList = snapshot.data!.docs;
            return GridView.builder(
              itemCount: flowerList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 8.4 / 11,
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                DocumentSnapshot document = flowerList[index];
                String docId = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String name = data['name'];
                String meaning = data['meaning'].toString();
                String picture = (data['picture'] ?? "");
                double price = data['price'].toDouble();
                String scientificName = data['scientificName'].toString();
                return _flowerCard(
                  context,
                  name,
                  docId,
                  picture,
                  price,
                  scientificName,
                  meaning,
                  data,
                );
              },
            );
          },
        ),
      ),
    );
  }

  List<Widget> barraInicial() {
    setState(() {});

    return [
      MyIconButton(
        icon: Icons.house,
        onTap: () {
          setState(() {
            textoVazio = "Não há flores cadastradas!";
            currentStream = flowerService.read();
          });
        },
      ),
      SizedBox(width: 20),

      MyIconButton(
        icon: Icons.person,
        onTap: () {
          setState(() {
            textoVazio = "Você ainda não cadastrou flores!";
            currentStream = flowerService.filterByMyUser(user.uid);
          });
        },
      ),
      SizedBox(width: 20),

      MyIconButton(
        icon: Icons.paid,
        onTap: () => {
          setState(() {
            textoVazio = "Não há flores cadastradas!";
          }),
          _orderByPriceMenu(),
        },
      ),

      SizedBox(width: 20),

      MyIconButton(
        icon: Icons.sort_by_alpha,
        onTap: () => {
          setState(() {
            textoVazio = "Não há flores cadastradas!";
          }),
          _orderByAlphaMenu(),
        },
      ),

      SizedBox(width: 30),
      MyIconButton(
        icon: Icons.logout,
        onTap: () {
          loginService.signUserOut();
        },
      ),
      SizedBox(width: 20),
    ];
  }

  void _createMenus(List<Widget> itens) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MyBottomSheet(itens: itens),
    );
  }

  void _orderByPriceMenu() {
    _createMenus([
      Text("Ordenar por ordem"),
      MyTextButton(
        onPressed: () {
          setState(() {
            currentStream = flowerService.readByAscendingPrice();
          });
          Navigator.pop(context);
        },
        text: "Do barato ao mais caro",
      ),
      MyTextButton(
        onPressed: () {
          setState(() {
            currentStream = flowerService.readByDescendingPrice();
          });
          Navigator.pop(context);
        },
        text: "Do caro ao mais barato",
      ),
    ]);
  }

  void _orderByAlphaMenu() {
    _createMenus([
      Text("Ordernar por ordem: "),
      MyTextButton(
        onPressed: () {
          setState(() {
            currentStream = flowerService.readByAlphabeticalOrderAZ();
          });
          Navigator.pop(context);
        },
        text: "AZ",
      ),
      MyTextButton(
        onPressed: () {
          setState(() {
            currentStream = flowerService.readByAlphabeticalOrderZA();
          });
          Navigator.pop(context);
        },
        text: "ZA",
      ),
    ]);
  }

  Widget _flowerCard(
    BuildContext context,
    String name,
    String id,
    String? picture,
    double price,
    String scientificName,
    String? meaning,
    Map<String, dynamic> data,
  ) {
    return GestureDetector(
      onTap: () {
        _seeFlower(
          name,
          id,
          picture,
          price,
          scientificName,
          meaning,
          data["color"],
          data["type"],
          data['userId'],
        );
      },
      child: Column(
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Color.fromARGB(255, 255, 164, 164)),
                left: BorderSide(color: Color.fromARGB(255, 255, 164, 164)),
                right: BorderSide(color: Color.fromARGB(255, 255, 164, 164)),
              ),
            ),
            child: Text(
              name,

              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 241, 152, 152),
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromARGB(255, 255, 189, 189),
            child: Padding(
              padding: EdgeInsetsGeometry.all(5),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: picture != null && picture != ""
                            ? FileImage(File(picture!))
                            : AssetImage("assets/imgs/flower.png")
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Color.fromARGB(255, 252, 249, 234),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    color: Color.fromARGB(255, 255, 189, 189),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "R\$ " + price.toString(),
                          style: GoogleFonts.abel(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 252, 249, 234),
                              fontSize: 15,
                            ),
                          ),
                        ),

                        Divider(color: Color.fromARGB(255, 252, 249, 234)),
                        Text(
                          scientificName,
                          style: GoogleFonts.adamina(
                            textStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color.fromARGB(255, 252, 249, 234),
                            ),
                          ),

                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Text(
                          meaning ?? "",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 252, 249, 234),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _seeFlower(
    String name,
    String id,
    String? picture,
    double price,
    String scientificName,
    String? meaning,
    String color,
    String type,
    String userId,
  ) async {
    final flores = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlowerPage(
          flower: Flower(
            name: name,
            scientificName: scientificName,
            price: price,
            color: color,
            type: type,
            meaning: meaning,
            picture: picture,
            id: id,
            userId: userId,
          ),
        ),
      ),
    );
  }

  void _showEditPage({Flower? flower}) async {
    final updatedFlower = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlowereditPage(flower: flower)),
    );
  }
}
