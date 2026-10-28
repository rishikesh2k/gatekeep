import 'package:gatekeep/helper/app_message.dart';
import 'package:gatekeep/helper/qr_helper.dart';
import 'package:gatekeep/provider/base_provider.dart';
import 'package:gatekeep/services/api_exception.dart';
import 'package:gatekeep/services/navigation_service.dart';
import 'package:gatekeep/utils/app_routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerProvider extends BaseProvider {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    formats: [BarcodeFormat.qrCode],
  );

  // onDetect fires for every frame, so only one scan is handled at a time.
  bool isProcessing = false;
  String? lastError;

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isProcessing || capture.barcodes.isEmpty) return;
    isProcessing = true;
    lastError = null;
    customNotify();

    final visitorId = QrHelper.readVisitorId(capture.barcodes.first.rawValue);
    if (visitorId == null) {
      await showScanError('Invalid QR code. This is not a visitor pass.');
      return;
    }

    try {
      store.save(await api.getVisitor(visitorId));
      if (isDisposed) return;

      await controller.stop();
      await NavigationService.navigateTo(AppRoutes.visitorDetailsPage, arguments: visitorId);

      // Back from details: get ready for the next visitor.
      if (isDisposed) return;
      isProcessing = false;
      customNotify();
      await controller.start();
    } on ApiException catch (e) {
      await showScanError(e.isNotFound ? 'No visitor found for this QR code.' : e.message);
    }
  }

  Future<void> showScanError(String message) async {
    if (isDisposed) return;
    lastError = message;
    customNotify();
    AppMessage.error(message);
    await Future.delayed(const Duration(seconds: 2));
    if (isDisposed) return;
    isProcessing = false;
    customNotify();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
