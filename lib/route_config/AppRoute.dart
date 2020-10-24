class AppRoute {
  bool isLoggedIn;
  final bool isUnknown;

  AppRoute.login()
      : isLoggedIn = false,
        isUnknown = false;

  AppRoute.home()
      : isLoggedIn = true,
        isUnknown = false;

  AppRoute.unknown() : isUnknown = true;
}
