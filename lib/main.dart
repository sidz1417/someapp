import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:someapp/riverpod/Auth.dart';
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _firebaseInit =
    FutureProvider<FirebaseApp>((ref) => Firebase.initializeApp());

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cursorColor: Colors.red,
        ),
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(_firebaseInit).when(
      data: (_) => MainScreen(),
      loading: () => LoadingWidget(),
      error: (err, _) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('Error loading firebase : $err'),
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        centerTitle: true,
        leading: AboutDialogButton(),
        actions: [
          SignOutButton(),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Consumer(
              builder: (_, watch, __) => watch(authStateStream).when(
                  data: (user) => user != null ? HomeScreen() : LoginScreen(),
                  loading: () => CircularProgressIndicator(),
                  error: (err, _) => Text('Error getting user $err'))),
        ),
      ),
    );
  }
}

class AboutDialogButton extends StatelessWidget {
  const AboutDialogButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.info),
      tooltip: 'About',
      onPressed: () => showAboutDialog(
        context: context,
        applicationVersion: '1.0.0',
        applicationLegalese: 'A sample application for firebase services',
      ),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) => watch(authStateStream).when(
        data: (user) => user != null
            ? IconButton(
                tooltip: 'Sign out',
                icon: Icon(Icons.exit_to_app),
                onPressed: signOut,
              )
            : Container(),
        loading: () => Container(),
        error: (_, __) => Container(),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
