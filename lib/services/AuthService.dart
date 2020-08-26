import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

enum AuthMode { SIGNIN, SIGNUP }

class AuthService extends ChangeNotifier {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String email;
  set setEmail(String email) => this.email = email;

  String password;
  set setPassword(String password) => this.password = password;

  AuthMode authMode = AuthMode.SIGNIN;
  set setAuthMode(AuthMode authMode) {
    this.authMode = authMode;
    notifyListeners();
  }

  bool authTrigger = false;
  set triggerAuth(bool authTrigger) {
    this.authTrigger = authTrigger;
    notifyListeners();
  }

  Future<void> authenticate() async {
    authTrigger = false;
    try {
      switch (authMode) {
        case AuthMode.SIGNIN:
          return await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password);
        case AuthMode.SIGNUP:
          return await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message);
    }
  }

  Stream<String> authStateChanges() =>
      _firebaseAuth.authStateChanges().map((User user) => user?.uid);

  void signOut() {
    _firebaseAuth.signOut();
  }
}
