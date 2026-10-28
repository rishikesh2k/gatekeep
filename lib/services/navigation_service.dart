import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static Future<Object?> navigateTo(String routeName, {Object? arguments}) async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return null;
    return navigator.pushNamed(routeName, arguments: arguments);
  }

  static void navigateReplacementTo(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void goBack({Object? data}) {
    navigatorKey.currentState?.pop(data);
  }
}
