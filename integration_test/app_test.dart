import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:someapp/main.dart';
import 'package:someapp/riverpod/Auth.dart';
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:someapp/utils/SignOutButton.dart';

import 'fake_auth_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth tests : ', () {
    testWidgets('Full valid user signin flow', (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(ProviderScope(
        overrides: [
          firebaseAuthProvider
              .overrideWithProvider(Provider((ref) => FakeAuthService()))
        ],
        child: MyApp(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.enterText(
          find.byType(EmailTextField), 'rightuser@email.com');
      await tester.enterText(find.byType(PasswordTextField), '111111111');
      await tester.tap(find.byKey(Key('AuthButton')));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      await tester.tap(find.byType(SignOutButton));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    }, skip: false);

    testWidgets('Invalid user signin - shows Snackbar with correct text',
        (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(ProviderScope(
        overrides: [
          firebaseAuthProvider
              .overrideWithProvider(Provider((ref) => FakeAuthService()))
        ],
        child: MyApp(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.enterText(
          find.byType(EmailTextField), 'wronguser@email.com');
      await tester.enterText(find.byType(PasswordTextField), '111111111');
      await tester.tap(find.byKey(Key('AuthButton')));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Some auth error message'), findsOneWidget);
    }, skip: false);

    testWidgets('Full valid user signup flow', (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(ProviderScope(
        overrides: [
          firebaseAuthProvider
              .overrideWithProvider(Provider((ref) => FakeAuthService()))
        ],
        child: MyApp(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.tap(find.byKey(Key('AuthToggleButton')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(EmailTextField), 'rightuser@email.com');
      await tester.enterText(find.byType(PasswordTextField), '111111111');
      await tester.enterText(
          find.byType(PasswordConfirmTextField), '111111111');
      await tester.tap(find.byKey(Key('AuthButton')));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      await tester.tap(find.byType(SignOutButton));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    }, skip: false);

    testWidgets('Invalid user signup - shows Snackbar with correct text',
        (tester) async {
      await Firebase.initializeApp();
      await tester.pumpWidget(ProviderScope(
        overrides: [
          firebaseAuthProvider
              .overrideWithProvider(Provider((ref) => FakeAuthService()))
        ],
        child: MyApp(),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.tap(find.byKey(Key('AuthToggleButton')));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byType(EmailTextField), 'wronguser@email.com');
      await tester.enterText(find.byType(PasswordTextField), '111111111');
      await tester.enterText(
          find.byType(PasswordConfirmTextField), '111111111');
      await tester.tap(find.byKey(Key('AuthButton')));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Some auth error message'), findsOneWidget);
    }, skip: false);
  }, skip: false);

  group('Db tests : ', () {
    testWidgets('List of categories load correctly', (tester) async {});
  });
}

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   group('Auth tests : ', () {
//     testWidgets('Full valid user signin flow', (tester) async {
//       await Firebase.initializeApp();
//       await tester.pumpWidget(ProviderScope(
//         overrides: [
//           firebaseAuthProvider
//               .overrideWithProvider(Provider((ref) => FakeAuthService()))
//         ],
//         child: MyApp(),
//       ));
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//       await tester.enterText(
//           find.byType(EmailTextField), 'rightuser@email.com');
//       await tester.enterText(find.byType(PasswordTextField), '111111111');
//       await tester.tap(find.byKey(Key('AuthButton')));
//       await tester.pumpAndSettle();
//       expect(find.byType(HomeScreen), findsOneWidget);
//       await tester.tap(find.byType(SignOutButton));
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//     }, skip: false);

//     testWidgets('Invalid user signin - shows Snackbar with correct text',
//         (tester) async {
//       await Firebase.initializeApp();
//       await tester.pumpWidget(ProviderScope(
//         overrides: [
//           firebaseAuthProvider
//               .overrideWithProvider(Provider((ref) => FakeAuthService()))
//         ],
//         child: MyApp(),
//       ));
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//       await tester.enterText(
//           find.byType(EmailTextField), 'wronguser@email.com');
//       await tester.enterText(find.byType(PasswordTextField), '111111111');
//       await tester.tap(find.byKey(Key('AuthButton')));
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//       await tester.pumpAndSettle();
//       expect(find.byType(SnackBar), findsOneWidget);
//       expect(find.text('Some auth error message'), findsOneWidget);
//     }, skip: false);

//     testWidgets('Full valid user signup flow', (tester) async {
//       await Firebase.initializeApp();
//       await tester.pumpWidget(ProviderScope(
//         overrides: [
//           firebaseAuthProvider
//               .overrideWithProvider(Provider((ref) => FakeAuthService()))
//         ],
//         child: MyApp(),
//       ));
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//       await tester.tap(find.byKey(Key('AuthToggleButton')));
//       await tester.pumpAndSettle();
//       await tester.enterText(
//           find.byType(EmailTextField), 'rightuser@email.com');
//       await tester.enterText(find.byType(PasswordTextField), '111111111');
//       await tester.enterText(
//           find.byType(PasswordConfirmTextField), '111111111');
//       await tester.tap(find.byKey(Key('AuthButton')));
//       await tester.pumpAndSettle();
//       expect(find.byType(HomeScreen), findsOneWidget);
//       await tester.tap(find.byType(SignOutButton));
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//     }, skip: false);

//     testWidgets('Invalid user signup - shows Snackbar with correct text',
//         (tester) async {
//       await Firebase.initializeApp();
//       await tester.pumpWidget(ProviderScope(
//         overrides: [
//           firebaseAuthProvider
//               .overrideWithProvider(Provider((ref) => FakeAuthService()))
//         ],
//         child: MyApp(),
//       ));
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//       await tester.tap(find.byKey(Key('AuthToggleButton')));
//       await tester.pumpAndSettle();
//       await tester.enterText(
//           find.byType(EmailTextField), 'wronguser@email.com');
//       await tester.enterText(find.byType(PasswordTextField), '111111111');
//       await tester.enterText(
//           find.byType(PasswordConfirmTextField), '111111111');
//       await tester.tap(find.byKey(Key('AuthButton')));
//       await tester.pumpAndSettle();
//       expect(find.byType(LoginScreen), findsOneWidget);
//       await tester.pumpAndSettle();
//       expect(find.byType(SnackBar), findsOneWidget);
//       expect(find.text('Some auth error message'), findsOneWidget);
//     }, skip: false);
//   }, skip: false);

//   group('Db tests : ', () {
//     testWidgets('List of categories load correctly', (tester) async {});
//   });
// }
