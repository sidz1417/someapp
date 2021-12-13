import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/riverpod/Auth.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _passwordTextController =
        TextEditingController();
    return Center(
      child: (watch(authTriggerProvider).state)
          ? watch(authFutureProvider(context)).when(
              data: (_) => LoginScreenContents(
                formKey: _formKey,
                passwordTextController: _passwordTextController,
              ),
              loading: () => CircularProgressIndicator(),
              error: (_, __) => LoginScreenContents(
                formKey: _formKey,
                passwordTextController: _passwordTextController,
              ),
            )
          : LoginScreenContents(
              formKey: _formKey,
              passwordTextController: _passwordTextController,
            ),
    );
  }
}

class LoginScreenContents extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordTextController;

  LoginScreenContents({
    required this.formKey,
    required this.passwordTextController,
  });

  final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: FocusScope(
        node: focusScopeNode,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmailTextField(),
                SomePadding(),
                PasswordTextField(
                  passwordTextController: passwordTextController,
                ),
                SomePadding(),
                Consumer(
                  builder: (_, watch, __) =>
                      (watch(authModeProvider).state == AuthMode.SIGNUP)
                          ? PasswordConfirmTextField(
                              passwordTextController: passwordTextController)
                          : Container(),
                ),
                SomePadding(),
                Consumer(
                  builder: (context, watch, _) => ElevatedButton(
                    child: Text(
                      '${watch(authModeProvider).state == AuthMode.SIGNIN ? 'Sign In' : 'Sign Up'}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (!formKey.currentState!.validate()) return;
                      formKey.currentState!.save();
                      context.read(authTriggerProvider).state = true;
                      formKey.currentState!.reset();
                    },
                  ),
                ),
                SomePadding(),
                Consumer(
                  builder: (context, watch, _) {
                    final authMode = watch(authModeProvider).state;
                    return ElevatedButton(
                      child: Text(
                        '${authMode == AuthMode.SIGNIN ? 'Switch to Sign Up' : 'Switch to Sign In'}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        (authMode == AuthMode.SIGNIN)
                            ? context.read(authModeProvider).state =
                                AuthMode.SIGNUP
                            : context.read(authModeProvider).state =
                                AuthMode.SIGNIN;
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SomePadding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
    );
  }
}

class EmailTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary)),
        labelText: "Enter E-mail",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (email) {
        if (email != null && email.isEmpty) return 'Email cannot be blank';
      },
      onSaved: (String? email) {
        if (email != null) context.read(emailProvider).state = email;
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordTextController;

  PasswordTextField({required this.passwordTextController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary)),
        labelText: "Enter Password",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      obscureText: true,
      onSaved: (String? password) {
        if (password != null) context.read(passwordProvider).state = password;
      },
      controller: passwordTextController,
      validator: (String? password) {
        if (password == null || password.length < 6)
          return "Minimum password length is 6";
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class PasswordConfirmTextField extends StatelessWidget {
  final TextEditingController passwordTextController;

  PasswordConfirmTextField({required this.passwordTextController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.secondary)),
        labelText: "Confirm password",
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      obscureText: true,
      validator: (String? password) {
        if (passwordTextController.text != password)
          return 'Passwords do not match';
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}
