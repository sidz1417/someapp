import 'package:flutter/material.dart';
import 'package:someapp/route_config/AppRoute.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    final pathSegments = uri.pathSegments;
    if (pathSegments.length == 0) return AppRoute.home();
    if (pathSegments.length == 1) {
      if (pathSegments[0] == 'login') return AppRoute.home();
      return AppRoute.unknown();
    }
    return AppRoute.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    if (configuration.isUnknown)
      return RouteInformation(location: '/404');
    if (!configuration.isLoggedIn) return RouteInformation(location: '/login');
    return RouteInformation(location: '/');
  }
}
