import 'dart:io';

import 'package:apk_trabalho3/model/flower_model.dart';
import 'package:apk_trabalho3/service/flower_service.dart';
import 'package:apk_trabalho3/view/components/my_bottom_sheet.dart';
import 'package:apk_trabalho3/view/components/my_color_circle.dart';
import 'package:apk_trabalho3/view/components/my_text_button.dart';
import 'package:apk_trabalho3/view/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FlowereditPage extends StatefulWidget {
  final Flower? flower;

  const FlowereditPage({super.key, this.flower});

  @override
  State<FlowereditPage> createState() => _FlowereditPageState();
}

class _FlowereditPageState extends State<FlowereditPage> {
  final List<String> _cores = [
    'Azul',
    'Vermelho',
    'Amarelo',
    'Branco',
    'Verde',
    'Laranja',
    'Rosa',
  ];
  final List<String> _tipos = ["Flor", 'Erva Daninha', 'Tempeiros'];
  Flower? _editFlower;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _meaningController = TextEditingController();
  final _imgController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final _typeController = TextEditingController();
  final FlowerService flowerService = FlowerService();
  final user = FirebaseAuth.instance.currentUser!;
  bool precoValido = true;

  Color corBorda = Color.fromARGB(255, 255, 164, 164);
  final priceMask = MaskTextInputFormatter(
    mask: 'R\$ ########',
    filter: {"#": RegExp(r'([0-9]|.)')},
  );

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
        userId: user.uid,
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
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 255, 164, 164)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveFlowerMenu();
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
              maxSize: 24,
              labelText: "Nome",
              type: TextInputType.text,
              color: Color.fromARGB(255, 255, 164, 164),
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
              maxSize: 10,
              labelText: "Preço",
              type: TextInputType.numberWithOptions(decimal: true),
              color: corBorda,
              mask: priceMask,
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  try {
                    _editFlower?.price = double.parse(
                      (text.substring(2, text.toString().length)),
                    );
                    corBorda = Color.fromARGB(255, 255, 164, 164);
                    precoValido = true;
                  } on FormatException catch (e) {
                    corBorda = Color.fromARGB(255, 248, 130, 122);
                    precoValido = false;
                  } on RangeError catch (e) {
                    corBorda = Color.fromARGB(255, 248, 130, 122);
                    precoValido = false;
                  }
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
              maxSize: 33,
              controller: _scientificNameController,
              color: Color.fromARGB(255, 255, 164, 164),
              labelText: "Nome Cientifico",
              type: TextInputType.text,
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
              color: Color.fromARGB(255, 255, 164, 164),
              maxSize: 311,
              controller: _meaningController,
              labelText: "Significado",
              type: TextInputType.multiline,
              sizeContainer: 400,
              maxLines: 6,
            ),
            Container(
              width: 400,
              color: Color.fromARGB(255, 255, 189, 189),
              child: Column(
                spacing: 10,
                children: [
                  SizedBox(height: 10),
                  dropDownButton(
                    "Selecione a cor: ",
                    123,
                    (_editFlower!.color),
                    _cores,
                    MyColorCircle(color: _editFlower!.color),
                    (String? newValue) {
                      setState(() {
                        if (newValue!.isNotEmpty) {
                          _editFlower!.color = newValue;
                        }
                      });
                    },
                  ),

                  dropDownButton(
                    "Selecione o tipo:",
                    123,
                    (_editFlower!.type),
                    _tipos,
                    null,
                    (String? newValue) {
                      setState(() {
                        if (newValue!.isNotEmpty) {
                          _editFlower!.type = newValue;
                        }
                      });
                    },
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

  Widget dropDownButton(
    String text,
    double width,
    String val,
    List<String> lista,
    Widget? icon,
    ValueChanged<String?>? onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: [
        Text(
          text,
          style: GoogleFonts.abel(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 252, 249, 234),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        Container(
          height: 40,
          width: width,
          color: Color.fromARGB(255, 252, 249, 234),

          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 255, 164, 164),
                width: 3,
                style: BorderStyle.solid,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(5),
              child: DropdownButton(
                isExpanded: true,
                value: val,
                items: lista.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: onChanged,
                dropdownColor: Color.fromARGB(255, 252, 249, 234),
                elevation: 16,
                style: TextStyle(color: Color.fromARGB(255, 255, 164, 164)),
                alignment: Alignment.center,
                underline: Container(),
                icon: icon,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveFlowerMenu() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => MyBottomSheet(
        itens: [
          Text("Gostaria de salvar esta flor?"),
          MyTextButton(
            onPressed: () {
              Navigator.pop(context);
              _saveFlower();
            },
            text: "Sim",
          ),
          MyTextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: "Não",
          ),
        ],
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
        if (precoValido) {
          if (_editFlower?.id != null) {
            await flowerService.update(_editFlower!);
          } else {
            await flowerService.create(_editFlower!);
          }
          Navigator.pop(context, _editFlower);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Insira um preço valido!")));
        }
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
