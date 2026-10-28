import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';

class VisitorAvatar extends StatelessWidget {
  final String name;
  final double size;
  final bool onDark;

  const VisitorAvatar({super.key, required this.name, this.size = 44, this.onDark = false});

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: onDark ? AppColors.primary : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: onDark ? AppColors.dark : AppColors.primaryDark,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
