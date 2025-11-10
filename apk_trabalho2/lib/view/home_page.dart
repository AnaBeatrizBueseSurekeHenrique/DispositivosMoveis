import 'dart:io';

import 'package:apk_trabalho2/database/helper/flower_helper.dart';
import 'package:apk_trabalho2/database/model/flower_model.dart';
import 'package:apk_trabalho2/view/components/my_TextButton.dart';
import 'package:apk_trabalho2/view/components/my_bottomSheet.dart';
import 'package:apk_trabalho2/view/components/my_iconbutton.dart';
import 'package:apk_trabalho2/view/components/my_textfield.dart';
import 'package:apk_trabalho2/view/flower_edit_page.dart';
import 'package:apk_trabalho2/view/flower_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum OrderNameOptions { orderAz, orderZa }

enum ColorOptions {
  corAmarela,
  corVermelha,
  corAzul,
  corBranca,
  corVerde,
  corLaranja,
  corRosa,
}

enum TypeOptions { tipoFlor, tipoDaninha, tipoTempeiro }

enum OrderPriceOptions { orderExpensive, orderCheap }

class _HomePageState extends State<HomePage> {
  FlowerHelper helper = FlowerHelper();
  List<Flower> flowers = [];
  List<Flower> curentFlowers = [];
  List<Flower> searchFlowers = [];
  List<OrderPriceOptions> ordens = [
    OrderPriceOptions.orderCheap,
    OrderPriceOptions.orderExpensive,
  ];
  List<ColorOptions> currentColorFilters = [];
  List<bool> colors = [false, false, false, false, false, false, false];

  List<TypeOptions> currentTypeFilters = [];
  List<bool> types = [false, false, false];
  final _searchController = TextEditingController();
  bool pesquisa = false;
  @override
  void initState() {
    super.initState();
    helper.getAllFlowers().then((list) {
      setState(() {
        flowers = list;
        curentFlowers = flowers;
        searchFlowers = flowers;
      });
    });
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
        child: GridView.builder(
          itemCount: curentFlowers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 8.4 / 11,
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
      onTap: () {
        _seeFlower(curentFlowers[index]);
      },
      // onTap: () => _showFlowerPage(flower: flowers[index]),
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
              curentFlowers[index].name,

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
                        image:
                            curentFlowers[index].picture != null &&
                                curentFlowers[index].picture != ""
                            ? FileImage(File(curentFlowers[index].picture!))
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
                          "R\$ " + curentFlowers[index].price.toString(),
                          style: GoogleFonts.abel(
                            textStyle: TextStyle(
                              color: Color.fromARGB(255, 252, 249, 234),
                              fontSize: 15,
                            ),
                          ),
                        ),

                        Divider(color: Color.fromARGB(255, 252, 249, 234)),
                        Text(
                          curentFlowers[index].scientificName,
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
                          curentFlowers[index].meaning.toString(),
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

  void _seeFlower(Flower flower) async {
    final flores = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlowerPage(flower: flower)),
    );
    setState(() {
      helper.getAllFlowers().then((list) {
        setState(() {
          flowers = list;
          curentFlowers = flowers;
          searchFlowers = flowers;
        });
      });
    });
  }

  void _showEditPage({Flower? flower}) async {
    final updatedFlower = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FlowereditPage(flower: flower)),
    );
    if (updatedFlower != null) {
      setState(() {
        helper.getAllFlowers().then((list) {
          setState(() {
            flowers = list;
            curentFlowers = flowers;
            searchFlowers = flowers;
          });
        });
      });
    }
  }

  void _createMenus(List<Widget> itens) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MyBottomsheet(itens: itens),
    );
  }

  void _orderByPriceMenu() {
    _createMenus([
      Text("Ordenar por ordem"),
      MyTextbutton(
        onPressed: () {
          Navigator.pop(context);
          _orderPrice(OrderPriceOptions.orderCheap);
        },
        text: "Do barato ao mais caro",
      ),
      MyTextbutton(
        onPressed: () {
          Navigator.pop(context);
          _orderPrice(OrderPriceOptions.orderExpensive);
        },
        text: "Do caro ao mais barato",
      ),
    ]);
  }

  List<Widget> barraInicial() {
    if (!pesquisa) {
      setState(() {});

      return [
        MyIconbutton(
          icon: Icons.house,
          onTap: () {
            setState(() {
              curentFlowers = flowers;
              searchFlowers = flowers;
            });
          },
        ),
        SizedBox(width: 20),

        MyIconbutton(icon: Icons.paid, onTap: () => _orderByPriceMenu()),
        SizedBox(width: 20),

        MyIconbutton(icon: Icons.palette, onTap: () => filtrarCores()),
        SizedBox(width: 20),
        MyIconbutton(
          icon: Icons.sort_by_alpha,
          onTap: () => _orderByAlphaMenu(),
        ),
        SizedBox(width: 20),
        MyIconbutton(icon: Icons.local_florist, onTap: () => filtrarTypes()),
        SizedBox(width: 20),

        MyIconbutton(
          icon: Icons.search,
          onTap: () {
            pesquisa = !pesquisa;
            barraInicial();
          },
        ),
        SizedBox(width: 30),
      ];
    } else {
      setState(() {});

      return [
        MyTextfield(
          onChanged: (value) => {},
          maxSize: 24,
          controller: _searchController,
          hintText: "Pesquise o nome",
          type: TextInputType.text,
          sizeContainer: 350,
          maxLines: 1,
          onSubmmited: (value) {
            pesquisar(value);
          },
          color: Color.fromARGB(255, 255, 164, 164),
        ),
        IconButton(
          onPressed: () {
            pesquisa = !pesquisa;
            barraInicial();
          },
          icon: Icon(
            Icons.filter_alt,
            color: Color.fromARGB(255, 252, 249, 234),
          ),
        ),
      ];
    }
  }

  void pesquisar(String value) {
    setState(() {
      curentFlowers = [];
      flowers.forEach((flor) {
        if (flor.name.toLowerCase().contains(value.toLowerCase())) {
          curentFlowers.add(flor);
        }
      });
      searchFlowers = curentFlowers;
    });
  }

  void filtrarCores() {
    _createMenus([
      CheckboxListTile(
        title: Text("Amarelo"),
        value: colors[0],
        onChanged: (newValue) {
          setState(() {
            colors[0] = newValue!;
            if (colors[0]) {
              currentColorFilters.add(ColorOptions.corAmarela);
            } else {
              currentColorFilters.remove(ColorOptions.corAmarela);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        activeColor: const Color.fromARGB(255, 255, 218, 126),
        checkColor: Color.fromARGB(255, 252, 249, 234),
      ),
      CheckboxListTile(
        title: Text("Azul"),
        value: colors[1],
        onChanged: (newValue) {
          setState(() {
            colors[1] = newValue!;
            if (colors[1]) {
              currentColorFilters.add(ColorOptions.corAzul);
            } else {
              currentColorFilters.remove(ColorOptions.corAzul);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        activeColor: const Color.fromARGB(255, 107, 164, 243),
        checkColor: Color.fromARGB(255, 252, 249, 234),
      ),
      CheckboxListTile(
        title: Text("Vermelho"),
        value: colors[2],
        onChanged: (newValue) {
          setState(() {
            colors[2] = newValue!;
            if (colors[2]) {
              currentColorFilters.add(ColorOptions.corVermelha);
            } else {
              currentColorFilters.remove(ColorOptions.corVermelha);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        activeColor: const Color.fromARGB(255, 248, 130, 122),
        checkColor: Color.fromARGB(255, 252, 249, 234),
      ),
      CheckboxListTile(
        title: Text("Branco"),
        value: colors[3],
        onChanged: (newValue) {
          setState(() {
            colors[3] = newValue!;
            if (colors[3]) {
              currentColorFilters.add(ColorOptions.corBranca);
            } else {
              currentColorFilters.remove(ColorOptions.corBranca);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        activeColor: Colors.white,
        checkColor: Color.fromARGB(255, 252, 249, 234),
      ),
      CheckboxListTile(
        title: Text("Verde"),
        value: colors[4],
        onChanged: (newValue) {
          setState(() {
            colors[4] = newValue!;
            if (colors[4]) {
              currentColorFilters.add(ColorOptions.corVerde);
            } else {
              currentColorFilters.remove(ColorOptions.corVerde);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        activeColor: Color.fromARGB(255, 186, 223, 219),
        checkColor: Color.fromARGB(255, 252, 249, 234),
      ),
      CheckboxListTile(
        title: Text("Laranja"),
        value: colors[5],
        onChanged: (newValue) {
          setState(() {
            colors[5] = newValue!;
            if (colors[5]) {
              currentColorFilters.add(ColorOptions.corLaranja);
            } else {
              currentColorFilters.remove(ColorOptions.corLaranja);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        activeColor: Color.fromARGB(255, 253, 183, 135),
        checkColor: Color.fromARGB(255, 252, 249, 234),
      ),
      CheckboxListTile(
        title: Text("Rosa"),
        value: colors[6],
        onChanged: (newValue) {
          setState(() {
            colors[6] = newValue!;
            if (colors[6]) {
              currentColorFilters.add(ColorOptions.corRosa);
            } else {
              currentColorFilters.remove(ColorOptions.corRosa);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        activeColor: const Color.fromARGB(255, 255, 164, 241),
        checkColor: Color.fromARGB(255, 252, 249, 234),
      ),
    ]);
  }

  void filtrarTypes() {
    _createMenus([
      CheckboxListTile(
        title: Text("Flor"),
        value: types[0],
        onChanged: (newValue) {
          setState(() {
            types[0] = newValue!;
            if (types[0]) {
              currentTypeFilters.add(TypeOptions.tipoFlor);
            } else {
              currentTypeFilters.remove(TypeOptions.tipoFlor);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        checkColor: Colors.white,
      ),
      CheckboxListTile(
        title: Text("Erva Daninha"),
        value: types[1],
        onChanged: (newValue) {
          setState(() {
            types[1] = newValue!;
            if (types[1]) {
              currentTypeFilters.add(TypeOptions.tipoDaninha);
            } else {
              currentTypeFilters.remove(TypeOptions.tipoDaninha);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        checkColor: Colors.white,
      ),
      CheckboxListTile(
        title: Text("Tempeiro"),
        value: types[2],
        onChanged: (newValue) {
          setState(() {
            types[2] = newValue!;
            if (types[2]) {
              currentTypeFilters.add(TypeOptions.tipoTempeiro);
            } else {
              currentTypeFilters.remove(TypeOptions.tipoTempeiro);
            }
            filtros();
            Navigator.pop(context);
          });
        },
        checkColor: Colors.white,
      ),
    ]);
  }

  void _orderByAlphaMenu() {
    _createMenus([
      Text("Ordernar por ordem: "),
      MyTextbutton(
        onPressed: () {
          Navigator.pop(context);
          _orderName(OrderNameOptions.orderAz);
        },
        text: "AZ",
      ),
      MyTextbutton(
        onPressed: () {
          Navigator.pop(context);
          _orderName(OrderNameOptions.orderZa);
        },
        text: "ZA",
      ),
    ]);
  }

  void filtros() {
    setState(() {
      List<Flower> aux = searchFlowers;
      curentFlowers = searchFlowers;
      if (currentColorFilters.isNotEmpty) {
        curentFlowers = [];

        currentColorFilters.forEach((result) {
          switch (result) {
            case ColorOptions.corAmarela:
              curentFlowers += aux
                  .where((flor) => flor.color == "Amarelo")
                  .toList();
              break;
            case ColorOptions.corAzul:
              curentFlowers += aux
                  .where((flor) => flor.color == "Azul")
                  .toList();
              break;
            case ColorOptions.corVermelha:
              curentFlowers += aux
                  .where((flor) => flor.color == "Vermelho")
                  .toList();
              break;
            case ColorOptions.corBranca:
              curentFlowers += aux
                  .where((flor) => flor.color == "Branco")
                  .toList();
              break;
            case ColorOptions.corVerde:
              curentFlowers += aux
                  .where((flor) => flor.color == "Verde")
                  .toList();
              break;
            case ColorOptions.corLaranja:
              curentFlowers += aux
                  .where((flor) => flor.color == "Laranja")
                  .toList();
              break;
            case ColorOptions.corRosa:
              curentFlowers += aux
                  .where((flor) => flor.color == "Rosa")
                  .toList();
              break;
          }
        });
      }
      aux = curentFlowers;
      if (currentTypeFilters.isNotEmpty) {
        curentFlowers = [];
        currentTypeFilters.forEach((result) {
          switch (result) {
            case TypeOptions.tipoFlor:
              curentFlowers += aux
                  .where((flor) => flor.type == "Flor")
                  .toList();
              break;
            case TypeOptions.tipoDaninha:
              curentFlowers += aux
                  .where((flor) => flor.type == "Erva Daninha")
                  .toList();
              break;
            case TypeOptions.tipoTempeiro:
              curentFlowers += aux
                  .where((flor) => flor.type == "Tempeiros")
                  .toList();
              break;
          }
        });
      }
    });
  }

  void _orderPrice(OrderPriceOptions result) {
    curentFlowers = searchFlowers;
    switch (result) {
      case OrderPriceOptions.orderCheap:
        curentFlowers.sort((a, b) {
          return a.price.compareTo(b.price);
        });
        break;
      case OrderPriceOptions.orderExpensive:
        curentFlowers.sort((a, b) {
          return b.price.compareTo(a.price);
        });
        break;
    }
    setState(() {});
  }

  void _orderName(OrderNameOptions result) {
    curentFlowers = searchFlowers;
    switch (result) {
      case OrderNameOptions.orderAz:
        curentFlowers.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });

        break;
      case OrderNameOptions.orderZa:
        curentFlowers.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
