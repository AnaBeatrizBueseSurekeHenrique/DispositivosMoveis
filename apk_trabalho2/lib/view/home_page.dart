import 'dart:io';

import 'package:apk_trabalho2/database/helper/flower_helper.dart';
import 'package:apk_trabalho2/database/model/flower_model.dart';
import 'package:apk_trabalho2/view/components/my_iconbutton.dart';
import 'package:apk_trabalho2/view/flower_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

void pesquisar() async {
  print("Pesquisar");
}

void filtro() async {
  print("Filtro!");
}

void organizar() {
  print("Pesquisar!");
}

void tipo() {
  print('Tipo!');
}

void cor() {
  print("Cor!");
}

class _HomePageState extends State<HomePage> {
  FlowerHelper helper = FlowerHelper();
  List<Flower> flowers = [];

  void preco() {
    print("Preço!");
    print(flowers);
  }

  @override
  void initState() {
    super.initState();
    helper.getAllFlowers().then((list) {
      setState(() {
        flowers = list;
        print(flowers);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 164, 164),

        actions: [
          MyIconbutton(icon: Icons.filter_alt, onTap: filtro),
          MyIconbutton(icon: Icons.paid, onTap: preco),
          MyIconbutton(icon: Icons.palette, onTap: cor),
          MyIconbutton(icon: Icons.sort_by_alpha, onTap: organizar),
          MyIconbutton(icon: Icons.local_florist, onTap: tipo),
          MyIconbutton(icon: Icons.search, onTap: pesquisar),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 252, 249, 234),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFlowerPage,
        backgroundColor: Color.fromARGB(255, 186, 223, 219),
        child: Icon(Icons.add, color: Color.fromARGB(255, 252, 249, 234)),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: GridView.builder(
          itemCount: flowers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 14 / 20,
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemBuilder: (context, index) {
            return _flowerCard(context, index);
          },
        ),
      ),
    );
  }

  Widget _flowerCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => print(flowers[index].picture),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Color.fromARGB(255, 255, 164, 164)),
                left: BorderSide(color: Color.fromARGB(255, 255, 164, 164)),
                right: BorderSide(color: Color.fromARGB(255, 255, 164, 164)),
              ),
            ),
            child: Text(flowers[index].name),
          ),

          Container(
            color: Color.fromARGB(255, 255, 189, 189),
            child: Column(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          flowers[index].picture != null &&
                              flowers[index].picture != ""
                          ? FileImage(File(flowers[index].picture!))
                          : AssetImage("assets/imgs/flower.png")
                                as ImageProvider,
                    ),
                  ),
                ),
                Container(
                  color: Color.fromARGB(255, 255, 189, 189),
                  child: Column(
                    children: [
                      Text(
                        "R\$ " + flowers[index].price.toString(),
                        style: TextStyle(),
                      ),

                      Divider(color: Color.fromARGB(255, 252, 249, 234)),
                      Text(
                        flowers[index].scientificName,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text(flowers[index].meaning.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFlowerPage({Flower? flower}) async {
    final updatedFlower = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlowerPage(flower: flower)),
    );
    if (updatedFlower != null) {
      setState(() {
        helper.getAllFlowers().then((list) {
          setState(() {
            flowers = list;
          });
        });
      });
    }
  }
}
