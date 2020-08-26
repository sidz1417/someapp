import 'package:flutter/material.dart';
import 'package:someapp/services/AuthService.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authTrigger =
        context.select((AuthService authService) => authService.authTrigger);
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _passwordTextController =
        TextEditingController();
    return Center(
      child: FutureBuilder(
        future: (_authTrigger)
            ? context
                .select((AuthService authService) => authService.authenticate())
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else if (snapshot.hasError && _authTrigger)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${snapshot.error}'),
                ),
              );
            });
          return LoginScreenContents(
            formKey: _formKey,
            passwordTextController: _passwordTextController,
          );
        },
      ),
    );
  }
}

class LoginScreenContents extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordTextController;
  LoginScreenContents({
    @required this.formKey,
    @required this.passwordTextController,
  });

  final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    final _authMode =
        context.select((AuthService authService) => authService.authMode);
    return Form(
      key: formKey,
      child: FocusScope(
        node: focusScopeNode,
        child: Container(
          height: 400,
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmailTextField(),
              SomePadding(),
              PasswordTextField(
                passwordTextController: passwordTextController,
              ),
              SomePadding(),
              (_authMode == AuthMode.SIGNUP)
                  ? PasswordConfirmTextField(
                      passwordTextController: passwordTextController)
                  : Container(),
              SomePadding(),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  '${_authMode == AuthMode.SIGNIN ? 'Sign In' : 'Sign Up'}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _submitForm(context),
              ),
              SomePadding(),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  '${_authMode == AuthMode.SIGNIN ? 'Switch to Sign Up' : 'Switch to Sign In'}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  (_authMode == AuthMode.SIGNIN)
                      ? context.read<AuthService>().setAuthMode =
                          AuthMode.SIGNUP
                      : context.read<AuthService>().setAuthMode =
                          AuthMode.SIGNIN;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    context.read<AuthService>().triggerAuth = true;
    formKey.currentState.reset();
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
            borderSide: BorderSide(color: Theme.of(context).accentColor)),
        labelText: "Enter E-mail",
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
      ),
      keyboardType: TextInputType.emailAddress,
      // ignore: missing_return
      validator: (String email) {
        if (email.isEmpty) return 'Email cannot be blank';
      },
      onSaved: (String email) {
        context.read<AuthService>().setEmail = email;
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordTextController;
  PasswordTextField({@required this.passwordTextController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor)),
        labelText: "Enter Password",
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
      ),
      obscureText: true,
      onSaved: (String password) {
        context.read<AuthService>().setPassword = password;
      },
      controller: passwordTextController,
      // ignore: missing_return
      validator: (String password) {
        if (password.isEmpty || password.length < 6)
          return "Minimum password length is 6";
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}

class PasswordConfirmTextField extends StatelessWidget {
  final TextEditingController passwordTextController;
  PasswordConfirmTextField({@required this.passwordTextController});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor)),
        labelText: "Confirm password",
        labelStyle: TextStyle(color: Theme.of(context).accentColor),
      ),
      obscureText: true,
      // ignore: missing_return
      validator: (String password) {
        if (passwordTextController.text != password)
          return 'Passwords do not match';
      },
      textInputAction: TextInputAction.next,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}
