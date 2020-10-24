import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/riverpod/Auth.dart';

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
