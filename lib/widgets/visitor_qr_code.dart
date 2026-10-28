import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// White background so it can still be scanned in dark mode.
class VisitorQrCode extends StatelessWidget {
  final String visitorId;
  final double size;

  const VisitorQrCode({super.key, required this.visitorId, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: SizedBox(
            width: size,
            height: size,
            child: QrImageView(data: visitorId, size: size, backgroundColor: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(visitorId, style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2)),
      ],
    );
  }
}
