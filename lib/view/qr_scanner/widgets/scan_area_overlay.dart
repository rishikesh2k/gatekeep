import 'package:flutter/material.dart';
import 'package:gatekeep/utils/app_colors.dart';

class ScanAreaOverlay extends StatelessWidget {
  final Rect scanWindow;

  const ScanAreaOverlay({super.key, required this.scanWindow});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
                ),
                Positioned.fromRect(
                  rect: scanWindow,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fromRect(
            rect: scanWindow,
            child: CustomPaint(painter: CornerPainter()),
          ),
        ],
      ),
    );
  }
}

// Draws the four gold corners around the scan area.
class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const length = 34.0;
    final w = size.width;
    final h = size.height;

    canvas.drawPath(Path()..moveTo(0, length)..lineTo(0, 0)..lineTo(length, 0), paint);
    canvas.drawPath(Path()..moveTo(w - length, 0)..lineTo(w, 0)..lineTo(w, length), paint);
    canvas.drawPath(Path()..moveTo(0, h - length)..lineTo(0, h)..lineTo(length, h), paint);
    canvas.drawPath(Path()..moveTo(w - length, h)..lineTo(w, h)..lineTo(w, h - length), paint);
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) => false;
}
