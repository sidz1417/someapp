import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/riverpod/Auth.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _passwordTextController =
        TextEditingController();
    return Center(
      child: (ref.watch(authTriggerProvider.state).state)
          ? ref.watch(authFutureProvider(context)).maybeWhen(
                loading: () => CircularProgressIndicator(),
                orElse: () => LoginScreenContents(
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

class LoginScreenContents extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordTextController;

  LoginScreenContents({
    required this.formKey,
    required this.passwordTextController,
  });

  final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  builder: (_, ref, __) =>
                      (ref.watch(authModeProvider.state).state ==
                              AuthMode.SIGNUP)
                          ? PasswordConfirmTextField(
                              passwordTextController: passwordTextController)
                          : Container(),
                ),
                SomePadding(),
                Consumer(
                  builder: (context, ref, _) => ElevatedButton(
                    child: Text(
                      '${ref.watch(authModeProvider.state).state == AuthMode.SIGNIN ? 'Sign In' : 'Sign Up'}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      if (!formKey.currentState!.validate()) return;
                      formKey.currentState!.save();
                      ref.watch(authTriggerProvider.notifier).state = true;
                      formKey.currentState!.reset();
                    },
                  ),
                ),
                SomePadding(),
                Consumer(
                  builder: (context, ref, _) {
                    final authMode = ref.watch(authModeProvider.state).state;
                    return ElevatedButton(
                      child: Text(
                        '${authMode == AuthMode.SIGNIN ? 'Switch to Sign Up' : 'Switch to Sign In'}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        (authMode == AuthMode.SIGNIN)
                            ? ref.watch(authModeProvider.notifier).state =
                                AuthMode.SIGNUP
                            : ref.watch(authModeProvider.notifier).state =
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

class EmailTextField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      // ignore: body_might_complete_normally_nullable
      validator: (email) {
        if (email != null && email.isEmpty) return 'Email cannot be blank';
      },
      onSaved: (String? email) {
        if (email != null) ref.watch(emailProvider.notifier).state = email;
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class PasswordTextField extends ConsumerWidget {
  final TextEditingController passwordTextController;

  PasswordTextField({required this.passwordTextController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        if (password != null)
          ref.watch(passwordProvider.notifier).state = password;
      },
      controller: passwordTextController,
      // ignore: body_might_complete_normally_nullable
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
      // ignore: body_might_complete_normally_nullable
      validator: (String? password) {
        if (passwordTextController.text != password)
          return 'Passwords do not match';
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}
