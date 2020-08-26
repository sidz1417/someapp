import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:someapp/services/AuthService.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cursorColor: Colors.red,
      ),
      home: MultiProvider(
        providers: [
          StreamProvider<String>(
            create: (_) => AuthService().authStateChanges(),
          ),
          ChangeNotifierProvider(
            create: (_) => AuthService(),
          ),
        ],
        child: MyApp(),
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
        child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error in initializing firebase : ${snapshot.error}',
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer(
                builder: (_, String currentUser, __) {
                  return (currentUser != null) ? HomeScreen() : LoginScreen();
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
