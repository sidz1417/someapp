import 'package:flutter/material.dart';
import 'package:someapp/services/AuthService.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () => context.read<AuthService>().signOut(),
        child: Text('Sign Out'),
      ),
    );
  }
}
