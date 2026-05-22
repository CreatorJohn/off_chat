import 'dart:math';
import 'package:flutter/material.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:off_chat/src/features/location/presentation/radar_controller.dart';

class RadarPainter extends CustomPainter {
  final double sweepAngle;
  final double userHeading;
  final List<RadarDevice> devices;

  RadarPainter({
    required this.sweepAngle,
    required this.userHeading,
    required this.devices,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final ringPaint = Paint()
      ..color = AppTheme.primaryGold.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw rings
    final distances = [10.0, 20.0, 30.0, 40.0, 50.0];
    const double maxDist = 50.0;
    for (final d in distances) {
      final r = _getScaledRadius(d, maxDist, radius);
      canvas.drawCircle(center, r, ringPaint);
    }

    // Draw Sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          AppTheme.primaryGold.withValues(alpha: 0.0),
          AppTheme.primaryGold.withValues(alpha: 0.2),
        ],
        stops: const [0.75, 1.0],
        transform: GradientRotation(sweepAngle),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint);

    // Draw Crosshair
    final crossPaint = Paint()
      ..color = AppTheme.primaryGold.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx, center.dy - radius), Offset(center.dx, center.dy + radius), crossPaint);
    canvas.drawLine(Offset(center.dx - radius, center.dy), Offset(center.dx + radius, center.dy), crossPaint);

    // Draw Device Nodes with Logarithmic Scaling
    for (final device in devices) {
      _drawDeviceNode(canvas, center, radius, device);
    }
  }

  void _drawDeviceNode(Canvas canvas, Offset center, double maxRadius, RadarDevice device) {
    const double maxDist = 50.0; // meters
    final d = device.distance.clamp(0.0, maxDist);
    final scaledDistance = _getScaledRadius(d, maxDist, maxRadius);

    // Calculate bearing relative to user heading
    final double relativeBearing = (device.bearing - userHeading + 360) % 360;
    final double angleRad = (relativeBearing - 90) * pi / 180;

    final nodePos = Offset(
      center.dx + scaledDistance * cos(angleRad),
      center.dy + scaledDistance * sin(angleRad),
    );

    // Draw Blip
    final blipPaint = Paint()
      ..color = AppTheme.primaryGold
      ..style = PaintingStyle.fill;
    
    // Outer Glow
    canvas.drawCircle(
      nodePos, 
      8, 
      Paint()..color = AppTheme.primaryGold.withValues(alpha: 0.2)
    );
    
    // Core
    canvas.drawCircle(nodePos, 4, blipPaint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: device.model.name ?? "Unknown",
        style: const TextStyle(
          color: AppTheme.onSurfaceVariant,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(nodePos.dx - textPainter.width / 2, nodePos.dy + 8)
    );
  }

  double _getScaledRadius(double distance, double maxDistance, double maxVisualRadius) {
    // Logarithmic scaling formula from thesis:
    // d_scaled = radius * log(1 + d * k) / log(1 + d_max * k)
    const double k = 0.5; // steepness coefficient
    return maxVisualRadius * (log(1 + distance * k) / log(1 + maxDistance * k));
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle || 
           oldDelegate.userHeading != userHeading ||
           oldDelegate.devices != devices;
  }
}
