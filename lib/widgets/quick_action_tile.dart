import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/utils/app_dimensions.dart';

class QuickActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;

  const QuickActionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: highlighted ? AppColors.primary : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: highlighted ? AppColors.white.withValues(alpha: 0.3) : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Icon(icon, color: highlighted ? AppColors.dark : AppColors.primaryDark),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: highlighted ? AppColors.dark : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
