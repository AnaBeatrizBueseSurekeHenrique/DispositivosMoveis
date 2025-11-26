import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  void signUserIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  void register(String password, String email) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
