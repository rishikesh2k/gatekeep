import 'package:flutter/material.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/utils/app_routes.dart';
import 'package:gatekeep/view/home/home_page.dart';
import 'package:gatekeep/view/splash/splash_page.dart';
import 'package:gatekeep/view/visitor_details/visitor_details_page.dart';
import 'package:gatekeep/view/visitor_form/visitor_form_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashPage:
        return MaterialPageRoute(builder: (context) => const SplashPage(), settings: settings);
      case AppRoutes.homePage:
        return MaterialPageRoute(builder: (context) => const HomePage(), settings: settings);
      case AppRoutes.visitorFormPage:
        // No argument = register mode, a Visitor = edit mode.
        final visitor = settings.arguments as Visitor?;
        return MaterialPageRoute(builder: (context) => VisitorFormPage(visitor: visitor), settings: settings);
      case AppRoutes.visitorDetailsPage:
        final visitorId = settings.arguments as String? ?? '';
        return MaterialPageRoute(builder: (context) => VisitorDetailsPage(visitorId: visitorId), settings: settings);
      default:
        return MaterialPageRoute(builder: (context) => const HomePage(), settings: settings);
    }
  }
}
