import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/utils/app_constants.dart';
import 'package:gatekeep/utils/app_dimensions.dart';
import 'package:gatekeep/utils/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: 2), openHome);
  }

  void openHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SplashMark(),
            SizedBox(height: AppDimensions.medium),
            Text(
              AppConstants.appName,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashMark extends StatelessWidget {
  const _SplashMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.medium),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppDimensions.radius)),
      child: const Icon(Icons.shield_outlined, size: 40, color: AppColors.dark),
    );
  }
}
