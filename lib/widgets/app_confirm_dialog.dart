import 'package:flutter/material.dart';
import 'package:gatekeep/services/navigation_service.dart';

class AppConfirmDialog {
  static Future<bool> show({required String title, required String message, String confirmText = 'Delete'}) async {
    final context = NavigationService.context;
    if (context == null) return false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
