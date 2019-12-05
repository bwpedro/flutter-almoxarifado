import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<AuthResult> signInWithEmailAndPassword(String email, String senha);
  Future<AuthResult> createUserWithEmailAndPassword(String email, String senha);
  Future<String> currentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AuthResult> signInWithEmailAndPassword(
      String email, String senha) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: senha);
    return user;
  }

  Future<AuthResult> createUserWithEmailAndPassword(
      String email, String senha) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: senha);
    return user;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.providerData[0].email;
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
