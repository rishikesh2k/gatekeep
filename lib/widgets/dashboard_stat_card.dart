import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.white),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 2,
            style: TextStyle(fontSize: 12, height: 1.25, color: AppColors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}
