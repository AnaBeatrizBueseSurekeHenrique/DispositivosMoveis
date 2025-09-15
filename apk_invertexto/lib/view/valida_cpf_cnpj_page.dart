import 'package:apk_invertexto/service/invertexto_service.dart';
import 'package:flutter/material.dart';

class ValidaCpfCnpj extends StatefulWidget {
  const ValidaCpfCnpj({super.key});

  @override
  State<ValidaCpfCnpj> createState() => _ValidaCpfCnpjState();
}

class _ValidaCpfCnpjState extends State<ValidaCpfCnpj> {
  String? campo;
  String? resultado;
  final apiService = InvertextoService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imgs/logo.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: const Color.fromARGB(255, 255, 246, 220),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                //Não costuma deixar botão
                labelText: "Digite um CPF ou CNPJ: ",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (value) {
                setState(() {
                  campo = value;
                });
              },
            ),
            Expanded(
              child: FutureBuilder(
                future: apiService.validarCEPCNPJ(campo), //alvo
                builder: (context, snapshot) {
                  //não entendi Perguntar
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            //documentação diz para usar sempre a cor Theme do projeto, usando primary e tudo mais??
                            Colors.white,
                          ),
                        ),
                      );
                    default:
                      if (snapshot.hasError) {
                        if (campo?.isNotEmpty == true) {
                          return SizedBox(
                            height: 10,
                            width: 150,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                                Text(
                                  "Erro!! Algo deu errado!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return exibeResultado(context, snapshot);
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget exibeResultado(BuildContext context, AsyncSnapshot snapshot) {
    String resultado = '';
    if (snapshot.data["formatted"] != null) {
      resultado += snapshot.data["formatted"] + ": ";
    }
    if (snapshot.data["valid"] == true) {
      resultado += "É válido";
    } else {
      resultado += "É inválido";
    }
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        resultado,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
