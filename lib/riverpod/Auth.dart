import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthMode { SIGNIN, SIGNUP }

FirebaseAuth _firebaseAuth = FirebaseAuth.instance
  ..useEmulator('http://localhost:9099');

final emailProvider = StateProvider((ref) => '');
final passwordProvider = StateProvider((ref) => '');
final authModeProvider = StateProvider((ref) => AuthMode.SIGNIN);
final authTriggerProvider = StateProvider((ref) => false);

final authFutureProvider = FutureProvider.family<UserCredential?, BuildContext>(
  (ref, context) async {
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
      if (ref.watch(authTriggerProvider).state)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${e.message}'),
          ),
        );
    } finally {
      ref.watch(authTriggerProvider).state = false;
      ref.watch(authModeProvider).state = AuthMode.SIGNIN;
      ref.watch(emailProvider).state = '';
      ref.watch(passwordProvider).state = '';
    }
  },
);

final authStateStream = StreamProvider<User?>(
  (ref) => _firebaseAuth.authStateChanges(),
);

final isModeratorProvider = FutureProvider.autoDispose<bool>(
  (ref) async {
    final idTokenResult = await _firebaseAuth.currentUser?.getIdTokenResult();
    final isModerator = idTokenResult?.claims?['isModerator'];
    return (isModerator != null) ? isModerator : false;
  },
);

void signOut() {
  _firebaseAuth.signOut();
}
