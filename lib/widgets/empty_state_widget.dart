import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final subtle = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(color: AppColors.primarySoft, shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(message!, textAlign: TextAlign.center, style: TextStyle(color: subtle)),
            ],
            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: 160,
                child: OutlinedButton(onPressed: onPressed, child: Text(buttonText!)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
