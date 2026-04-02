import 'dart:math';
import 'package:flutter/material.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';

class RadarPainter extends CustomPainter {
  final double sweepAngle;
  final double userHeading;

  RadarPainter({required this.sweepAngle, required this.userHeading});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final ringPaint = Paint()
      ..color = AppTheme.primaryGold.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw rings
    canvas.drawCircle(center, radius, ringPaint);
    canvas.drawCircle(center, radius * 0.75, ringPaint);
    canvas.drawCircle(center, radius * 0.5, ringPaint);
    canvas.drawCircle(center, radius * 0.25, ringPaint);

    // Draw Sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          AppTheme.primaryGold.withValues(alpha: 0.2),
          AppTheme.primaryGold.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.2],
        transform: GradientRotation(sweepAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint);

    // Draw Crosshair
    final crossPaint = Paint()
      ..color = AppTheme.primaryGold.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), crossPaint);
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), crossPaint);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle || oldDelegate.userHeading != userHeading;
  }
}
