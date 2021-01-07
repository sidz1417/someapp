import 'package:flutter/material.dart';
import 'package:someapp/route_config/AppRoute.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    if (uri.pathSegments.length == 0) return AppRoute.home();
    return AppRoute.unknown();
    // if (routeInformation.location == null) return AppRoute.home();
    // return AppRoute.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    if (configuration.isUnknown) return RouteInformation(location: '/404');
    return RouteInformation(location: '/');
  }
}
