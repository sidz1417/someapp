import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthMode { SIGNIN, SIGNUP }

FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

final emailProvider = StateProvider((ref) => '');
final passwordProvider = StateProvider((ref) => '');
final authModeProvider = StateProvider((ref) => AuthMode.SIGNIN);
final authTriggerProvider = StateProvider((ref) => false);

final authFutureProvider = FutureProvider<void>(
  (ref) async {
    final email = ref.watch(emailProvider).state;
    final password = ref.watch(passwordProvider).state;
    final authMode = ref.watch(authModeProvider).state;
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
    } finally {
      ref.watch(authTriggerProvider).state = false;
    }
  },
);

final authStateStream = StreamProvider<String>(
  (ref) => _firebaseAuth.authStateChanges().map((User user) => user?.uid),
);

void signOut() {
  _firebaseAuth.signOut();
}
