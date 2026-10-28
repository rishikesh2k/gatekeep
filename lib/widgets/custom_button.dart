import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool outlined;
  final Color? color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.outlined = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final action = isLoading ? null : onPressed;

    Widget child = Text(text);
    if (isLoading) {
      final spinnerColor = outlined ? AppColors.primary : (color == null ? AppColors.dark : Colors.white);
      child = SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: spinnerColor),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon), const SizedBox(width: 8), Text(text)],
      );
    }

    if (outlined) {
      return OutlinedButton(onPressed: action, child: child);
    }
    return ElevatedButton(
      onPressed: action,
      style: color == null
          ? null
          : ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
      child: child,
    );
  }
}
