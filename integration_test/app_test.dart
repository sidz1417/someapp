import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:someapp/main.dart';
import 'package:someapp/riverpod/Auth.dart' as test_auth;
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:someapp/utils/SignOutButton.dart';

// firebase emulators:start --only auth,functions,firestore --import=test/testData

// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d 23199AD8-F942-4956-9C8C-47E5DE45E6B1
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d macos
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d web-server --browser-name=chrome
// f drive --target=integration_test/app_test.dart --driver=integration_driver/integration_test.dart -d web-server --browser-name=safari

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth tests', () {
    tearDown(() {
      test_auth.signOut();
    });

    testWidgets("Login screen showed for unauthenticated user",
        (WidgetTester tester) async {
      await initialize(tester);

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    }, skip: false);

    testWidgets("Auth flow for valid user", (WidgetTester tester) async {
      await initialize(tester);

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);

      await tester.enterText(find.byType(EmailTextField), 'user@email.com');
      await tester.enterText(find.byType(PasswordTextField), '11111111');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(find.byType(SignOutButton));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    }, skip: false);
  }, skip: false);
}

Future<void> initialize(WidgetTester tester) async {
  await Firebase.initializeApp();
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
}
