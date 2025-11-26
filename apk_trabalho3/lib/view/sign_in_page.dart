import 'package:apk_trabalho3/service/login_service.dart';
import 'package:apk_trabalho3/view/components/my_text_button.dart';
import 'package:apk_trabalho3/view/components/my_textfield.dart';
import 'package:apk_trabalho3/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final repeatPasswordController = TextEditingController();
  final login_services = LoginService();
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

  void register() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 255, 189, 189),
          ),
        );
      },
    );
    if (repeatPasswordController.text == "") {
      Navigator.pop(context);
      showAlert("Repita a senha!");
    } else {
      try {
        if (passwordController.text == repeatPasswordController.text) {
          login_services.register(
            passwordController.text,
            usernameController.text,
          );
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          showAlert("Senhas não conferem!");
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          Navigator.pop(context);
          showAlert("Já existe um usuário com esse email!");
        } else {
          if (e.code == "weak-password") {
            Navigator.pop(context);
            showAlert("A senha precisa ter no minimo 6 caracteres!");
          } else {
            if (e.code == "network-request-failed") {
              showAlert("Sem conexão com a internet!");
            } else {
              if (e.code == "invalid-email") {
                showAlert("Formato do email está incorreto!");
              }
            }
          }
        }
      } on Exception catch (e) {
        Navigator.pop(context);
        showAlert("Erro inesperado ocorreu!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 242, 227),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 415,
              height: 125,
              alignment: Alignment.center,
              color: Color.fromARGB(255, 255, 164, 164),
              child: Text(
                "Cadastro",
                style: GoogleFonts.abel(
                  textStyle: TextStyle(
                    fontSize: 50,
                    color: Color.fromARGB(255, 248, 242, 227),
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),

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

              alignment: Alignment.topLeft,
              child: Text(
                "Repita a senha",
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
              controller: repeatPasswordController,
              type: TextInputType.text,
              sizeContainer: 300,
              maxLines: 1,
              color: Color.fromARGB(255, 255, 164, 164),
              hintText: "Repitir Senha",
              obscureText: true,
            ),
            SizedBox(height: 40),
            Container(
              width: 300,
              color: Color.fromARGB(255, 186, 223, 219),
              child: MyTextButton(
                onPressed: () {
                  print(usernameController.text);
                  register();
                },
                text: "Cadastrar",
              ),
            ),
            Container(
              width: 300,
              alignment: Alignment.topLeft,
              child: MyTextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: "Já tem uma conta? Faça login aqui!",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
