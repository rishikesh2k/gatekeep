import 'package:flutter/material.dart';
import 'package:gatekeep/provider/qr_scanner_provider.dart';
import 'package:gatekeep/utils/app_colors.dart';
import 'package:gatekeep/view/base_selector.dart';
import 'package:gatekeep/view/base_view.dart';
import 'package:gatekeep/view/qr_scanner/widgets/scan_area_overlay.dart';
import 'package:gatekeep/widgets/empty_state_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<QrScannerProvider>(
      builder: (context) {
        final provider = context.read<QrScannerProvider>();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Scan Visitor QR'),
            actions: [
              IconButton(icon: const Icon(Icons.flash_on), tooltip: 'Torch', onPressed: provider.controller.toggleTorch),
              IconButton(
                icon: const Icon(Icons.cameraswitch_outlined),
                tooltip: 'Switch camera',
                onPressed: provider.controller.switchCamera,
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final boxSize = constraints.maxWidth * 0.7;
              final scanWindow = Rect.fromCenter(
                center: constraints.biggest.center(Offset.zero),
                width: boxSize,
                height: boxSize,
              );

              return Stack(
                children: [
                  MobileScanner(
                    controller: provider.controller,
                    scanWindow: scanWindow,
                    onDetect: provider.onDetect,
                    errorBuilder: (context, error) => CameraErrorView(error: error),
                  ),
                  ScanAreaOverlay(scanWindow: scanWindow),
                  const Positioned(left: 16, right: 16, bottom: 24, child: ScanStatusBox()),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class ScanStatusBox extends StatelessWidget {
  const ScanStatusBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSelector<QrScannerProvider, (bool, String?)>(
      selector: (m) => (m.isProcessing, m.lastError),
      builder: (context, value) {
        final (isProcessing, lastError) = value;
        String text = 'Place the visitor QR code inside the box';
        Color color = AppColors.dark.withValues(alpha: 0.85);
        Widget leading = const Icon(Icons.qr_code_2, color: AppColors.primary);

        if (lastError != null) {
          text = lastError;
          color = AppColors.danger;
          leading = const Icon(Icons.error_outline, color: Colors.white);
        } else if (isProcessing) {
          text = 'Checking visitor...';
          leading = const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          );
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
            ],
          ),
        );
      },
    );
  }
}

class CameraErrorView extends StatelessWidget {
  final MobileScannerException error;

  const CameraErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
      return const EmptyStateWidget(
        icon: Icons.no_photography_outlined,
        title: 'Camera permission denied',
        message: 'Please allow camera access from the app settings to scan visitor QR codes.',
      );
    }
    return EmptyStateWidget(
      icon: Icons.videocam_off_outlined,
      title: 'Camera not available',
      message: error.errorDetails?.message ?? 'Unable to start the camera.',
    );
  }
}
