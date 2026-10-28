import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/utils/app_dimensions.dart';

class LocalDataBanner extends StatelessWidget {
  const LocalDataBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Icon(Icons.cloud_off_outlined, size: 18, color: AppColors.primaryDark),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Mock API not connected. Showing data saved on this phone.',
              style: TextStyle(color: AppColors.dark, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
