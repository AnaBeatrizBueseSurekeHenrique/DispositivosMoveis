import 'package:auth_apk/view/components/my_button.dart';
import 'package:auth_apk/view/components/my_textfield.dart';
import 'package:auth_apk/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void showWaiting() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(message));
      },
    );
  }

  void registerUser() async {
    showWaiting();
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userNameController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        Navigator.pop(context);
        showAlert("As senhas não conferem!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e.code);
      if (e.code == 'email-already-in-use') {
        showAlert("Já existe um usuário com este e-mail!");
      }
      if (e.code == 'weak-password') {
        showAlert('A senha precisa ter no minimo 6 caracteres');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                Text(
                  "Crie seu cadastro!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                MyTextfield(
                  controller: userNameController,
                  hintText: "Email",
                  obscureText: false,
                ),
                SizedBox(height: 15),
                MyTextfield(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),
                SizedBox(height: 15),
                MyTextfield(
                  controller: confirmPasswordController,
                  hintText: "Confirmação de Senha",
                  obscureText: true,
                ),

                SizedBox(height: 15),

                SizedBox(height: 25),
                MyButton(onTap: registerUser, text: "Cadastrar"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
