import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:someapp/main.dart';
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:http/http.dart' as http;

Future<void> removeCategory(WidgetTester tester,
    {required String pollName}) async {
  await tester.tap(find.byType(RemoveCategoryButton));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(Key('RemoveCategoryText')), pollName);
  await tester.tap(find.text('Remove'));
  await tester.pumpAndSettle();
}

Future<void> addCategory(WidgetTester tester, {required pollName}) async {
  await tester.tap(find.byType(AddCategoryButton));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(Key('AddCategoryText')), pollName);
  await tester.tap(find.text('Add'));
  await tester.pumpAndSettle();
}

Future<void> tapTile(WidgetTester tester, {required pollName}) async {
  await tester.tap(find.text(pollName));
  await tester.pumpAndSettle();
}

Future<void> signInAsModerator(WidgetTester tester) async {
  await tester.enterText(find.byType(EmailTextField), 'moduser@email.com');
  await tester.enterText(find.byType(PasswordTextField), '11111111');
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
}

Future<void> signInAsUser(WidgetTester tester) async {
  await tester.enterText(find.byType(EmailTextField), 'user@email.com');
  await tester.enterText(find.byType(PasswordTextField), '11111111');
  await tester.tap(find.text('Sign In'));
  await tester.pumpAndSettle();
}

Future<void> initialize(WidgetTester tester) async {
  await Firebase.initializeApp();
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
}

Future<void> clearFirestoreData() async {
  const DELETE_URL =
      "http://localhost:8080/emulator/v1/projects/testproject2-1ed80/databases/(default)/documents";
  await http.delete(Uri.parse(DELETE_URL));
}

void isLoginScreen() {
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(find.byType(HomeScreen), findsNothing);
}
