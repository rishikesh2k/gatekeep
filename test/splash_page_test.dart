import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatekeep/utils/app_constants.dart';
import 'package:gatekeep/utils/app_routes.dart';
import 'package:gatekeep/view/splash/splash_page.dart';

void main() {
  testWidgets('Splash shows GateKeep for 2 seconds, then opens home', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.homePage) {
            return MaterialPageRoute(builder: (context) => const Text('home'), settings: settings);
          }
          return MaterialPageRoute(builder: (context) => const SplashPage(), settings: settings);
        },
        initialRoute: AppRoutes.splashPage,
      ),
    );

    expect(find.text(AppConstants.appName), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('home'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(find.text(AppConstants.appName), findsNothing);
  });
}
