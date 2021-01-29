import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth_platform_interface/src/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class FakeAuthService implements FirebaseAuth {
  FakeAuthService({
    this.startupTime = const Duration(milliseconds: 250),
    this.responseTime = const Duration(seconds: 2),
  }) {
    Future<void>.delayed(responseTime).then((_) {
      _add(null);
    });
  }
  final Duration startupTime;
  final Duration responseTime;

  @override
  FirebaseApp app;

  @override
  Future<void> applyActionCode(String code) {
    throw UnimplementedError();
  }

  final _authStateChangesController = StreamController<User>();
  void _add(User user) {
    _currentUser = user;
    _authStateChangesController.add(user);
  }

  @override
  Stream<User> authStateChanges() => _authStateChangesController.stream;

  @override
  Future<ActionCodeInfo> checkActionCode(String code) {
    throw UnimplementedError();
  }

  @override
  Future<void> confirmPasswordReset({String code, String newPassword}) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {String email, String password}) async {
    await Future.delayed(responseTime);
    if (email == 'rightuser@email.com') {
      final userCredential = _mockUserCredential(
          email: email,
          password: password,
          uid: Random(12).nextInt(12384).toString());
      _add(userCredential.user);
      return userCredential;
    }
    throw FirebaseAuthException(
      code: 'AUTH_ERROR',
      message: 'Some auth error message',
    );
  }

  User _currentUser;
  @override
  User get currentUser => _currentUser;

  UserCredential _mockUserCredential(
      {@required String uid,
      @required String email,
      @required String password}) {
    final user = MockUser();
    when(user.uid).thenReturn(uid);
    when(user.email).thenReturn(email);
    final userCredential = MockUserCredential();
    when(userCredential.user).thenReturn(user);
    return userCredential;
  }

  @override
  Future<List<String>> fetchSignInMethodsForEmail(String email) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> getRedirectResult() {
    throw UnimplementedError();
  }

  @override
  Stream<User> idTokenChanges() {
    throw UnimplementedError();
  }

  @override
  bool isSignInWithEmailLink(String emailLink) {
    throw UnimplementedError();
  }

  @override
  String get languageCode => throw UnimplementedError();

  @override
  Map get pluginConstants => throw UnimplementedError();

  @override
  Future<void> sendPasswordResetEmail(
      {String email, ActionCodeSettings actionCodeSettings}) {
    throw UnimplementedError();
  }

  @override
  Future<void> sendSignInLinkToEmail(
      {String email, ActionCodeSettings actionCodeSettings}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setLanguageCode(String languageCode) {
    throw UnimplementedError();
  }

  @override
  Future<void> setPersistence(Persistence persistence) {
    throw UnimplementedError();
  }

  @override
  Future<void> setSettings(
      {bool appVerificationDisabledForTesting, String userAccessGroup}) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInAnonymously() {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithCustomToken(String token) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {String email, String password}) async {
    await Future.delayed(responseTime);
    if (email == 'rightuser@email.com') {
      final userCredential = _mockUserCredential(
          email: email,
          password: password,
          uid: Random(12).nextInt(12384).toString());
      _add(userCredential.user);
      return userCredential;
    }
    throw FirebaseAuthException(
      code: 'AUTH_ERROR',
      message: 'Some auth error message',
    );
  }

  @override
  Future<UserCredential> signInWithEmailLink({String email, String emailLink}) {
    throw UnimplementedError();
  }

  @override
  Future<ConfirmationResult> signInWithPhoneNumber(String phoneNumber,
      [RecaptchaVerifier verifier]) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInWithPopup(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithRedirect(AuthProvider provider) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    _add(null);
  }

  @override
  Stream<User> userChanges() {
    throw UnimplementedError();
  }

  @override
  Future<String> verifyPasswordResetCode(String code) {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyPhoneNumber(
      {String phoneNumber,
      verificationCompleted,
      verificationFailed,
      codeSent,
      codeAutoRetrievalTimeout,
      String autoRetrievedSmsCodeForTesting,
      Duration timeout = const Duration(seconds: 30),
      int forceResendingToken}) {
    throw UnimplementedError();
  }

  void dispose() {
    _authStateChangesController.close();
  }
}
