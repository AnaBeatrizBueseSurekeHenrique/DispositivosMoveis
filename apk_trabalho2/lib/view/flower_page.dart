import 'dart:io';

import 'package:apk_trabalho2/database/helper/flower_helper.dart';
import 'package:apk_trabalho2/database/model/flower_model.dart';
import 'package:apk_trabalho2/view/components/my_bottomSheet.dart';
import 'package:apk_trabalho2/view/components/my_colorCircle.dart';
import 'package:apk_trabalho2/view/components/my_textButton.dart';
import 'package:apk_trabalho2/view/flower_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowerPage extends StatefulWidget {
  Flower flower;
  FlowerPage({super.key, required this.flower});

  @override
  State<FlowerPage> createState() => _FlowerPageState();
}

class _FlowerPageState extends State<FlowerPage> {
  FlowerHelper helper = FlowerHelper();
  List<Flower> flowers = [];

  @override
  void initState() {
    super.initState();
    helper.getAllFlowers().then((list) {
      setState(() {
        flowers = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 255, 164, 164)),
      floatingActionButton: FloatingActionButton(
        onPressed: (_editFlower),
        backgroundColor: Color.fromARGB(255, 186, 223, 219),
        child: Icon(Icons.edit, color: Color.fromARGB(255, 252, 249, 234)),
      ),
      backgroundColor: Color.fromARGB(255, 252, 249, 234),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Container(
                width: 250,
                color: Color.fromARGB(255, 255, 189, 189),
                child: Text(
                  widget.flower.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abrilFatface(
                    textStyle: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 252, 249, 234),
                    ),
                  ),
                ),
              ),
              Container(
                width: 250,
                height: 250,

                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          widget.flower.picture != null &&
                              widget.flower.picture != ""
                          ? FileImage(File(widget.flower!.picture!))
                          : AssetImage("assets/imgs/flower.png")
                                as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 189, 189),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 255, 189, 189),
                width: 250,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(5),
                  child: Text(
                    "R\$" + widget.flower.price.toString(),
                    style: GoogleFonts.aBeeZee(
                      textStyle: TextStyle(fontSize: 20),
                      color: Color.fromARGB(255, 252, 249, 234),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 350,
                color: Color.fromARGB(255, 255, 189, 189),
                child: Padding(
                  padding: EdgeInsetsGeometry.directional(
                    start: 10.0,
                    end: 10.0,
                    bottom: 10.0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 350,

                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 252, 249, 234),
                              width: 1,
                            ),
                            left: BorderSide(
                              color: Color.fromARGB(255, 252, 249, 234),
                              width: 1,
                            ),
                            right: BorderSide(
                              color: Color.fromARGB(255, 252, 249, 234),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(5.0),
                          child: Text(
                            widget.flower.scientificName,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.aBeeZee(
                              textStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color.fromARGB(255, 252, 249, 234),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Tipo: " + widget.flower.type,
                            style: GoogleFonts.abel(
                              textStyle: TextStyle(
                                color: Color.fromARGB(255, 252, 249, 234),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "Cor: ",
                                style: GoogleFonts.abel(
                                  textStyle: TextStyle(
                                    color: Color.fromARGB(255, 252, 249, 234),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              MyColorcircle(color: widget.flower.color),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 350,
                color: Color.fromARGB(255, 255, 189, 189),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Significado",
                          style: GoogleFonts.aBeeZee(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 252, 249, 234),
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      Divider(color: Color.fromARGB(255, 252, 249, 234)),
                      Text(
                        widget.flower?.meaning != null
                            ? widget.flower!.meaning!
                            : "Está flor ainda não tem significado :(",
                        style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                            color: Color.fromARGB(255, 252, 249, 234),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editFlower() {
    _createMenus([
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          _showEditPage();
        },
        child: Text("Editar flor"),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);

          _deleteFlowerMenu();
        },
        child: Text("Excluir flor", style: TextStyle(color: Colors.redAccent)),
      ),
    ]);
  }

  void _createMenus(List<Widget> itens) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MyBottomsheet(itens: itens),
    );
  }

  void _showEditPage() async {
    final updatedFlower = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlowereditPage(flower: widget.flower),
      ),
    );
    if (updatedFlower != null) {
      setState(() {
        helper.getAllFlowers().then((list) {
          setState(() {
            flowers = list;
            widget.flower = updatedFlower;
            print(flowers);
          });
        });
      });
    }
  }

  void _deleteFlowerMenu() {
    print(flowers.length);
    print(widget.flower.id);
    _createMenus([
      Text(
        "Deseja mesmo deletar esta flor?",
        style: TextStyle(color: Colors.redAccent, fontSize: 20),
      ),
      MyTextbutton(
        onPressed: () {
          if (widget.flower.id != null) {
            Navigator.pop(context);
            setState(() {
              flowers.removeAt(
                flowers.indexWhere((flor) => flor.id == widget.flower.id!),
              );
            });
            Navigator.pop(context, flowers);

            helper.deleteFlower(widget.flower.id!);
          }
        },
        text: "Sim",
      ),
      MyTextbutton(
        onPressed: () {
          Navigator.pop(context);
        },
        text: "Não",
      ),
    ]);
  }
}
