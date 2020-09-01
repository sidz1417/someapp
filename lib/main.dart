import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:someapp/riverpod/Auth.dart';
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseInit =
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About',
            onPressed: () => showAboutDialog(
              context: context,
              applicationVersion: '1.0.0',
              applicationLegalese: 'A sample application for firebase services',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Consumer(
            builder: (_, watch, __) {
              return watch(firebaseInit).when(
                data: (_) {
                  final currentUser = watch(authStateStream);
                  return currentUser.when(
                    data: (user) =>
                        (user != null) ? HomeScreen() : LoginScreen(),
                    loading: () => CircularProgressIndicator(),
                    error: (err, stack) => Text('Error in getting user : $err'),
                  );
                },
                loading: () => CircularProgressIndicator(),
                error: (err, stack) =>
                    Text('Error in initializing Firebase : $err'),
              );
            },
          ),
        ),
      ),
    );
  }
}
