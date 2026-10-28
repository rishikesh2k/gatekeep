import 'package:flutter/material.dart';
import 'package:gatekeep/model/visitor.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/widgets/visitor_qr_code.dart';

class RegisteredDialog {
  static Future<void> show(Visitor visitor) async {
    final context = NavigationService.context;
    if (context == null) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Visitor Registered'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${visitor.name} has been registered successfully.'),
            const SizedBox(height: 16),
            VisitorQrCode(visitorId: visitor.id, size: 160),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('View Details'))],
      ),
    );
  }
}
