import 'dart:io';

import 'package:apk_trabalho2/database/helper/flower_helper.dart';
import 'package:apk_trabalho2/database/model/flower_model.dart';
import 'package:apk_trabalho2/view/components/my_iconbutton.dart';
import 'package:apk_trabalho2/view/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

enum Cores { azul, vermelho, amarelo, verde }

class FlowerPage extends StatefulWidget {
  final Flower? flower;
  const FlowerPage({super.key, this.flower});

  @override
  State<FlowerPage> createState() => _FlowerPageState();
}

class _FlowerPageState extends State<FlowerPage> {
  List<String> _cores = ['Azul', 'Vermelho', 'Amarelo'];
  List<String> _tipos = ["Flor", 'Erva Daninha', 'Tempeiros'];
  Flower? _editFlower;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _meaningController = TextEditingController();
  final _imgController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _typeController = TextEditingController();
  final FlowerHelper _helper = FlowerHelper();

  @override
  void initState() {
    super.initState();
    if (widget.flower == null) {
      _editFlower = Flower(
        name: "",
        scientificName: '',
        price: 0,
        color: 'Azul',
        type: 'Flor',
        meaning: '',
      );
    } else {
      _editFlower = widget.flower;
      _nameController.text = _editFlower?.name ?? "";
      _scientificNameController.text = _editFlower?.scientificName ?? "";
      _priceController.text = _editFlower?.price.toString() ?? "";
      _meaningController.text = _editFlower?.meaning ?? "";
      _typeController.text = _editFlower?.type ?? "";
      _imgController.text = _editFlower?.picture ?? "";
    }
  }

  void casa() {
    print(("Casa"));
  }

  void pesquisa() {
    print("Pesquisa!");
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _editFlower?.picture = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 164, 164),
        actions: [
          MyIconbutton(icon: Icons.house, onTap: casa),
          MyIconbutton(icon: Icons.search, onTap: pesquisa),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveFlower();
        },
        backgroundColor: Color.fromARGB(255, 186, 223, 219),
        child: Icon(Icons.save, color: Color.fromARGB(255, 252, 249, 234)),
      ),
      backgroundColor: Color.fromARGB(255, 252, 249, 234),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          spacing: 10,
          children: <Widget>[
            MyTextfield(
              controller: _nameController,
              sizeContainer: 300,
              maxSize: 25,
              labelText: "Nome",
              type: TextInputType.none,
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editFlower?.name = text;
                });
              },
              maxLines: 1,
            ),

            GestureDetector(
              onTap: () => _selectImage(),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 255, 189, 189),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          _editFlower?.picture != null &&
                              _editFlower!.picture!.isNotEmpty
                          ? FileImage(File(_editFlower!.picture!))
                          : AssetImage("assets/imgs/flower.png")
                                as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            MyTextfield(
              sizeContainer: 300,
              controller: _priceController,
              maxSize: 8,
              labelText: "Preço",
              type: TextInputType.numberWithOptions(decimal: true),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editFlower?.price = double.parse((text));
                });
              },
              maxLines: 1,
            ),
            MyTextfield(
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editFlower?.scientificName = text;
                });
              },
              maxSize: 400,
              controller: _scientificNameController,
              labelText: "Nome Cientifico",
              type: TextInputType.none,
              sizeContainer: 400,
              maxLines: 1,
            ),
            MyTextfield(
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editFlower?.meaning = text;
                });
              },
              maxSize: 200,
              controller: _meaningController,
              labelText: "Significado",
              type: TextInputType.multiline,
              sizeContainer: 400,
              maxLines: 5,
            ),
            Container(
              width: 400,
              color: Color.fromARGB(255, 255, 189, 189),
              child: Column(
                spacing: 10,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "Selecione a cor",
                        style: TextStyle(
                          color: Color.fromARGB(255, 252, 249, 234),
                        ),
                      ),
                      Container(
                        height: 40,
                        color: Color.fromARGB(255, 252, 249, 234),

                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 255, 164, 164),
                              width: 3,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: DropdownButton(
                            value: _editFlower!.color,
                            items: _cores.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue!.isNotEmpty) {
                                  _editFlower?.color = newValue;
                                }
                              });
                            },
                            dropdownColor: Color.fromARGB(255, 252, 249, 234),

                            icon: Icon(
                              Icons.circle,
                              color: _editFlower!.color == "Amarelo"
                                  ? Colors.yellow
                                  : _editFlower!.color == "Azul"
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                            elevation: 16,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 164, 164),
                            ),
                            alignment: Alignment.center,
                            underline: Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "Selecione o tipo",
                        style: TextStyle(
                          color: Color.fromARGB(255, 252, 249, 234),
                        ),
                      ),
                      Container(
                        height: 40,
                        color: Color.fromARGB(255, 252, 249, 234),

                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 255, 164, 164),
                              width: 3,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: DropdownButton(
                            value: _editFlower!.type,
                            items: _tipos.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue!.isNotEmpty) {
                                  _editFlower?.type = newValue;
                                }
                              });
                            },
                            dropdownColor: Color.fromARGB(255, 252, 249, 234),

                            elevation: 16,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 164, 164),
                            ),
                            alignment: Alignment.center,
                            underline: Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveFlower() async {
    if (_editFlower?.picture == "") {
      _editFlower?.picture = null;
    }
    if (_editFlower?.name != null && _editFlower!.name!.isNotEmpty) {
      if (_editFlower?.scientificName != null &&
          _editFlower!.scientificName!.isNotEmpty) {
        if (_editFlower?.id != null) {
          await _helper.updateFlower(_editFlower!);
        } else {
          await _helper.saveFlower(_editFlower!);
        }
        Navigator.pop(context, _editFlower);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("O nome cientifico é obrigatorio!")),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("O nome é obrigatorio!")));
    }
  }
}
