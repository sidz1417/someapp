import 'package:flutter/material.dart';
import 'package:someapp/riverpod/Auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () => signOut(),
        child: Text('Sign Out'),
      ),
    );
  }
}
