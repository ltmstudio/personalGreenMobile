import 'package:flutter/material.dart';

class ScannerOverlayPainter extends CustomPainter {
  final double cutOutSize;

  ScannerOverlayPainter({required this.cutOutSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;

    final cutOutRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: cutOutSize,
      height: cutOutSize,
    );

    final background = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final hole = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutOutRect, const Radius.circular(12)),
      );

    canvas.drawPath(
      Path.combine(PathOperation.difference, background, hole),
      paint,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const borderLength = 30.0;

    canvas.drawLine(
      cutOutRect.topLeft,
      cutOutRect.topLeft + const Offset(borderLength, 0),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.topLeft,
      cutOutRect.topLeft + const Offset(0, borderLength),
      borderPaint,
    );

    canvas.drawLine(
      cutOutRect.topRight,
      cutOutRect.topRight - const Offset(borderLength, 0),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.topRight,
      cutOutRect.topRight + const Offset(0, borderLength),
      borderPaint,
    );

    canvas.drawLine(
      cutOutRect.bottomLeft,
      cutOutRect.bottomLeft + const Offset(borderLength, 0),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.bottomLeft,
      cutOutRect.bottomLeft - const Offset(0, borderLength),
      borderPaint,
    );

    canvas.drawLine(
      cutOutRect.bottomRight,
      cutOutRect.bottomRight - const Offset(borderLength, 0),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.bottomRight,
      cutOutRect.bottomRight - const Offset(0, borderLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
