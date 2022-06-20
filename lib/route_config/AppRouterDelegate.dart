import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:someapp/riverpod/Auth.dart';
import 'package:someapp/route_config/AppRoute.dart';
import 'package:someapp/screens/HomeScreen.dart';
import 'package:someapp/screens/LoginScreen.dart';
import 'package:someapp/screens/UnknownScreen.dart';
import 'package:someapp/utils/AboutDialogButton.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  bool _isLoggedIn = false, _show404 = false;

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  AppRoute get currentConfiguration {
    if (_show404) return AppRoute.unknown();
    if (_isLoggedIn) return AppRoute.home();
    return AppRoute.login();
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    if (configuration.isUnknown) {
      _show404 = true;
      return;
    }
    _isLoggedIn = configuration.isLoggedIn;
    _show404 = false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ref, _) {
        return ref.watch(authStateStream).when(
              data: (user) {
                _isLoggedIn = user != null;
                return Navigator(
                  pages: [
                    if (_show404)
                      MaterialPage(child: UnknownScreen())
                    else if (_isLoggedIn)
                      MaterialPage(child: HomeScreen())
                    else if (!_isLoggedIn)
                      MaterialPage(
                        child: Scaffold(
                          appBar: AppBar(
                            title: Text('Flutter App'),
                            centerTitle: true,
                            leading: AboutDialogButton(),
                          ),
                          body: LoginScreen(),
                        ),
                      )
                  ],
                  onPopPage: (route, result) {
                    if (!route.didPop(result)) return false;
                    return true;
                  },
                );
              },
              loading: () => Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Scaffold(
                  body: Center(child: Text('Error getting user $err'))),
            );
      },
    );
  }
}
