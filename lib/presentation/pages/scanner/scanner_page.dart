import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hub_dom/core/config/routes/routes_path.dart';
import 'package:hub_dom/core/constants/colors/app_colors.dart';
import 'package:hub_dom/core/constants/strings/assets_manager.dart';
import 'package:hub_dom/presentation/pages/scanner/widgets/scanner_bg_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerCustom extends StatefulWidget {
  const MobileScannerCustom({super.key});

  @override
  State<MobileScannerCustom> createState() => _MobileScannerCustomState();
}

class _MobileScannerCustomState extends State<MobileScannerCustom> {
  final MobileScannerController _controller = MobileScannerController(
    autoStart: true,
  );
  bool _isTorchOn = false;
  bool _isHandlingScan = false;

  void _handleBarcode(BarcodeCapture capture) async {
    if (_isHandlingScan) return; // guard
    if (capture.barcodes.isEmpty) return;

    final barcode = capture.barcodes.first;
    if (barcode.rawValue == null) return;

    // print("✅ Scanned: ${barcode.rawValue}");
    _isHandlingScan = true;

    // stop scanner to save resources
    await _controller.stop();

    if (mounted) {
      context.replace(AppRoutes.newEmployeeApp);

      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (context) => AlertDialog(
      //     title: const Text("QR Code"),
      //     content: Text(barcode.rawValue!),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //           _isHandlingScan = false; // unlock scanning
      //           _controller.start(); // restart scanner
      //         },
      //         child: const Text("Scan Again"),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  void _toggleFlash() {
    _controller.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cutOutSize = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
        'Назад',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          /// Camera preview
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: _handleBarcode,
          ),

          /// Overlay
          IgnorePointer(
            ignoring: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: ScannerOverlayPainter(cutOutSize: cutOutSize),
                );
              },
            ),
          ),

          /// Subtitle
          Positioned(
            top: kToolbarHeight + 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                const Text(
                  "Отсканируйте QR-код",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 16),
                const Text(
                  "Наведите камеру на QR-код на стене для начала осмотра",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          /// Flashlight button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: _toggleFlash,
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isTorchOn ? AppColors.gray : AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(IconAssets.torch),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
