import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCustomAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  String message = "";

  Future<String> createUserWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "$email", password: "$password");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        message = "The password provided is too weak";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        message = "The account already exists for that email";
      }
    } catch (e) {
      print(e);
    }
    return message;
  }
}
