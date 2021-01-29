import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthMode { SIGNIN, SIGNUP }

final emailProvider = StateProvider((ref) => '');
final passwordProvider = StateProvider((ref) => '');
final authModeProvider = StateProvider((ref) => AuthMode.SIGNIN);
final authTriggerProvider = StateProvider((ref) => false);

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authStateChangesProvider =
    StreamProvider((ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final authMethodProvider = FutureProvider.autoDispose(
  // ignore: missing_return
  (ref) async {
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    final email = ref.read(emailProvider).state;
    final password = ref.read(passwordProvider).state;
    final authMode = ref.read(authModeProvider).state;
    try {
      switch (authMode) {
        case AuthMode.SIGNIN:
          return await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password);
        case AuthMode.SIGNUP:
          return await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password);
      }
    } on FirebaseAuthException catch (e) {
      return e;
    } finally {
      ref.read(authTriggerProvider).state = false;
      ref.read(authModeProvider).state = AuthMode.SIGNIN;
      ref.read(emailProvider).state = '';
      ref.read(passwordProvider).state = '';
    }
  },
);

final isModeratorProvider = FutureProvider.autoDispose<bool>(
  (ref) async {
    final firebaseAuth = ref.watch(firebaseAuthProvider);

    final idTokenResult = await firebaseAuth.currentUser.getIdTokenResult();
    final isModerator = idTokenResult.claims['isModerator'];
    return (isModerator != null) ? isModerator : false;
  },
);
