import 'package:flutter/material.dart';
import 'package:gatekeep/helper/app_message.dart';
import 'package:gatekeep/helper/shared_prefs.dart';
import 'package:gatekeep/locator.dart';
import 'package:gatekeep/router.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/utils/app_constants.dart';
import 'package:gatekeep/utils/app_routes.dart';
import 'package:gatekeep/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();
  setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: AppMessage.messengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: AppRoutes.splashPage,
    );
  }
}
