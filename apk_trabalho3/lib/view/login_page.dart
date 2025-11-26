import 'package:apk_trabalho3/service/login_service.dart';
import 'package:apk_trabalho3/view/components/my_text_button.dart';
import 'package:apk_trabalho3/view/components/my_textfield.dart';
import 'package:apk_trabalho3/view/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  void showAlert(String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 248, 242, 227),
          title: Text(
            mensagem,
            style: GoogleFonts.aBeeZee(
              color: const Color.fromARGB(184, 38, 38, 40),
            ),
          ),
        );
      },
    );
  }

  final passwordController = TextEditingController();
  final loginService = LoginService();
  void logIn() {
    try {
      loginService.signUserIn(usernameController.text, passwordController.text);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-credential') {
        Navigator.pop(context);
        showAlert("Usuário ou Senha Incorretos!");
      } else {
        if (e.code == "network-request-failed") {
          showAlert("Sem conexão com a internet!");
        } else {
          if (e.code == "invalid-email") {
            showAlert("Formato do email está incorreto!");
          }
        }
      }
    } on Exception catch (e) {
      Navigator.pop(context);
      showAlert("Erro inesperado ocorreu!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 164, 164),
        toolbarHeight: 1,
      ),
      backgroundColor: Color.fromARGB(255, 248, 242, 227),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 415,
              height: 125,
              color: Color.fromARGB(255, 255, 164, 164),
              child: Icon(
                Icons.local_florist_outlined,
                color: Color.fromARGB(255, 248, 242, 227),
                size: 120,
              ),
            ),
            Container(
              height: 500,
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.abel(
                      textStyle: TextStyle(
                        fontSize: 50,
                        color: Color.fromARGB(255, 255, 164, 164),
                      ),
                    ),
                  ),
                  Container(
                    width: 300,

                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email",
                      style: GoogleFonts.abel(
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 255, 164, 164),
                        ),
                      ),
                    ),
                  ),
                  MyTextfield(
                    onChanged: (text) {},
                    maxSize: 40,
                    controller: usernameController,
                    type: TextInputType.emailAddress,
                    sizeContainer: 300,
                    maxLines: 1,
                    color: Color.fromARGB(255, 255, 164, 164),
                    hintText: "Email",
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,

                    alignment: Alignment.topLeft,
                    child: Text(
                      "Senha",
                      style: GoogleFonts.abel(
                        textStyle: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 255, 164, 164),
                        ),
                      ),
                    ),
                  ),
                  MyTextfield(
                    onChanged: (text) {},
                    maxSize: 40,
                    controller: passwordController,
                    type: TextInputType.text,
                    sizeContainer: 300,
                    maxLines: 1,
                    color: Color.fromARGB(255, 255, 164, 164),
                    hintText: "Senha",
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    color: Color.fromARGB(255, 186, 223, 219),
                    child: MyTextButton(
                      onPressed: () {
                        logIn();
                      },
                      text: "Entrar",
                    ),
                  ),
                  Container(
                    width: 300,
                    alignment: Alignment.topLeft,
                    child: MyTextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      text: "Cadastre-se aqui!",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
