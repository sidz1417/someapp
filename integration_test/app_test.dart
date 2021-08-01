import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:someapp/riverpod/Auth.dart' as test_auth;
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:someapp/utils/SignOutButton.dart';
import 'test_utils.dart';

//start emulators with testdata
// firebase emulators:start --only auth,functions,firestore --import=test/testData

//Pixel 3a testing (arm64 emulator)
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d emulator-5554

//iphone 12 pro max testing
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d 23199AD8-F942-4956-9C8C-47E5DE45E6B1

//macos testing
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d macos

//chrome testing
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d web-server --browser-name=chrome --no-headless

//safari testing
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d web-server --browser-name=safari

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  bool skipTests = false;

  group('Auth tests', () {
    tearDown(() {
      test_auth.signOut();
    });

    testWidgets("Login screen showed for unauthenticated user",
        (WidgetTester tester) async {
      await initialize(tester);

      isLoginScreen();
    }, skip: skipTests);

    testWidgets("Auth flow for valid user", (WidgetTester tester) async {
      await initialize(tester);

      isLoginScreen();

      await signInAsUser(tester);

      expect(find.byType(LoginScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(find.byType(SignOutButton));
      await tester.pumpAndSettle();

      isLoginScreen();
    }, skip: skipTests);

    testWidgets('Moderator has moderator buttons', (WidgetTester tester) async {
      await initialize(tester);

      await signInAsModerator(tester);

      expect(find.byType(AddCategoryButton), findsOneWidget);
      expect(find.byType(RemoveCategoryButton), findsOneWidget);
    }, skip: skipTests);

    testWidgets('User does not have moderator buttons',
        (WidgetTester tester) async {
      await initialize(tester);

      await signInAsUser(tester);

      expect(find.byType(AddCategoryButton), findsNothing);
      expect(find.byType(RemoveCategoryButton), findsNothing);
    }, skip: skipTests);

    testWidgets('Snackbar is shown for wrong auth info', (tester) async {
      await initialize(tester);

      await tester.enterText(find.byType(EmailTextField), 'user@email.com');
      await tester.enterText(find.byType(PasswordTextField), '111111111');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      isLoginScreen();
    }, skip: skipTests);
  }, skip: skipTests);

  group('Db tests', () {
    tearDown(() async {
      test_auth.signOut();
      await clearFirestoreData();
    });

    testWidgets('User can upvote', (tester) async {
      await initialize(tester);

      await signInAsUser(tester);

      await tapTile(tester, pollName: 'jazz');
      await tapTile(tester, pollName: 'jazz');
      await tapTile(tester, pollName: 'jazz');

      expect(tester.widgetList(find.byType(CategoryItem)), [
        isA<CategoryItem>()
            .having((s) => s.pollName, 'jazz pollname', 'jazz')
            .having((s) => s.voteCount, 'jazz votecount', 3),
        isA<CategoryItem>()
            .having((s) => s.pollName, 'rock pollname', 'rock')
            .having((s) => s.voteCount, 'rock votecount', 0)
      ]);
    }, skip: skipTests);

    testWidgets('Moderator can add & remove polls', (tester) async {
      await initialize(tester);

      await signInAsModerator(tester);

      await addCategory(tester, pollName: 'hiphop');
      await addCategory(tester, pollName: 'blues');
      await addCategory(tester, pollName: 'rock');
      await addCategory(tester, pollName: 'carnatic');
      await removeCategory(tester, pollName: 'rock');
      await removeCategory(tester, pollName: 'carnatic');
      await removeCategory(tester, pollName: 'blues');

      expect(tester.widgetList(find.byType(CategoryItem)), [
        isA<CategoryItem>()
            .having((s) => s.pollName, 'hiphop pollname', 'hiphop')
            .having((s) => s.voteCount, 'hiphop votecount', 0),
      ]);
    }, skip: skipTests);

    testWidgets('Moderator cannot add existing category - Show Snackbar',
        (tester) async {
      await initialize(tester);

      await signInAsModerator(tester);

      await addCategory(tester, pollName: 'blues');
      await addCategory(tester, pollName: 'rock');
      await addCategory(tester, pollName: 'rock');

      expect(find.byType(SnackBar), findsOneWidget);
      expect(tester.widgetList(find.byType(CategoryItem)), [
        isA<CategoryItem>()
            .having((s) => s.pollName, 'blues pollname', 'blues')
            .having((s) => s.voteCount, 'blues votecount', 0),
        isA<CategoryItem>()
            .having((s) => s.pollName, 'rock pollname', 'rock')
            .having((s) => s.voteCount, 'rock votecount', 0),
      ]);
    }, skip: skipTests);
    testWidgets('Moderator cannot remove non-existent category - Show Snackbar',
        (tester) async {
      await initialize(tester);

      await signInAsModerator(tester);

      await addCategory(tester, pollName: 'blues');
      await addCategory(tester, pollName: 'rock');
      await addCategory(tester, pollName: 'hiphop');
      await removeCategory(tester, pollName: 'hiphop');
      await removeCategory(tester, pollName: 'something');

      expect(find.byType(SnackBar), findsOneWidget);
      expect(tester.widgetList(find.byType(CategoryItem)), [
        isA<CategoryItem>()
            .having((s) => s.pollName, 'blues pollname', 'blues')
            .having((s) => s.voteCount, 'blues votecount', 0),
        isA<CategoryItem>()
            .having((s) => s.pollName, 'rock pollname', 'rock')
            .having((s) => s.voteCount, 'rock votecount', 0),
      ]);
    }, skip: skipTests);
  }, skip: skipTests);
}
