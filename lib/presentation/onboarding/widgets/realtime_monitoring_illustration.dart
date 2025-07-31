import 'package:flutter/material.dart';
import 'dart:math' as math;

class RealtimeMonitoringIllustrationV2 extends StatelessWidget {
  const RealtimeMonitoringIllustrationV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gauge meters row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGaugeMeter(
                context,
                label: 'Voltage',
                unit: 'V',
                value: 0.75,
                color: Colors.green,
              ),
              _buildGaugeMeter(
                context,
                label: 'Current (A)',
                unit: 'A',
                value: 0.65,
                color: Colors.green,
                hasAlert: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Line chart
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: LineChartPainter(),
            ),
          ),
          const SizedBox(height: 16),
          // Power factor bars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Power Factor',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  _buildPowerFactorBar(
                    greenWidth: 0.6,
                    blueWidth: 0.3,
                    orangeWidth: 0.0,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Power Factor',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 4),
                  _buildPowerFactorBar(
                    greenWidth: 0.4,
                    blueWidth: 0.4,
                    orangeWidth: 0.2,
                    showAlert: true,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeMeter(
    BuildContext context, {
    required String label,
    required String unit,
    required double value,
    required Color color,
    bool hasAlert = false,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 80,
          child: CustomPaint(
            painter: GaugePainter(
              value: value,
              color: color,
              hasAlert: hasAlert,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPowerFactorBar({
    required double greenWidth,
    required double blueWidth,
    required double orangeWidth,
    bool showAlert = false,
  }) {
    return Column(
      children: [
        if (showAlert)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Alert',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Container(
          width: 80,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey[300],
          ),
          child: Row(
            children: [
              if (greenWidth > 0)
                Container(
                  width: 80 * greenWidth,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(6),
                      bottomLeft: const Radius.circular(6),
                      topRight: Radius.circular(greenWidth == 1.0 ? 6 : 0),
                      bottomRight: Radius.circular(greenWidth == 1.0 ? 6 : 0),
                    ),
                  ),
                ),
              if (blueWidth > 0)
                Container(
                  width: 80 * blueWidth,
                  height: 12,
                  color: Colors.blue,
                ),
              if (orangeWidth > 0)
                Container(
                  width: 80 * orangeWidth,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final bool hasAlert;

  GaugePainter({
    required this.value,
    required this.color,
    this.hasAlert = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.8);
    final radius = size.width * 0.4;

    // Draw background arc
    final backgroundPaint =
        Paint()
          ..color = Colors.grey[300]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      backgroundPaint,
    );

    // Draw value arc
    final valuePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;

    final sweepAngle = math.pi * 1.5 * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      sweepAngle,
      false,
      valuePaint,
    );

    // Draw alert section if needed
    if (hasAlert) {
      final alertPaint =
          Paint()
            ..color = Colors.orange
            ..style = PaintingStyle.stroke
            ..strokeWidth = 8
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        math.pi * 0.75 + math.pi * 1.2,
        math.pi * 0.3,
        false,
        alertPaint,
      );
    }

    // Draw needle
    final needlePaint =
        Paint()
          ..color = Colors.grey[800]!
          ..style = PaintingStyle.fill;

    final needleAngle = math.pi * 0.75 + sweepAngle;
    final needleEnd = Offset(
      center.dx + radius * 0.7 * math.cos(needleAngle),
      center.dy + radius * 0.7 * math.sin(needleAngle),
    );

    canvas.drawCircle(center, 6, needlePaint);

    final needlePath =
        Path()
          ..moveTo(center.dx - 3, center.dy)
          ..lineTo(center.dx + 3, center.dy)
          ..lineTo(needleEnd.dx, needleEnd.dy)
          ..close();

    canvas.drawPath(needlePath, needlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid lines
    final gridPaint =
        Paint()
          ..color = Colors.grey[300]!
          ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Data points
    final points = [
      const Offset(0.1, 0.7),
      const Offset(0.2, 0.5),
      const Offset(0.3, 0.6),
      const Offset(0.4, 0.4),
      const Offset(0.5, 0.5),
      const Offset(0.6, 0.3),
      const Offset(0.7, 0.4),
      const Offset(0.8, 0.2),
      const Offset(0.9, 0.15),
    ];

    // Draw filled area
    final fillPath = Path();
    fillPath.moveTo(0, size.height);

    for (final point in points) {
      fillPath.lineTo(point.dx * size.width, point.dy * size.height);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Gradient fill
    final fillPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[300]!, Colors.blue[100]!],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePaint =
        Paint()
          ..color = Colors.blue[600]!
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final linePath = Path();
    linePath.moveTo(
      points.first.dx * size.width,
      points.first.dy * size.height,
    );

    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx * size.width, point.dy * size.height);
    }

    canvas.drawPath(linePath, linePaint);

    // Draw points
    final pointPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final pointBorderPaint =
        Paint()
          ..color = Colors.blue[600]!
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    for (final point in points) {
      final center = Offset(point.dx * size.width, point.dy * size.height);
      canvas.drawCircle(center, 4, pointPaint);
      canvas.drawCircle(center, 4, pointBorderPaint);
    }

    // Draw dotted vertical lines from points
    final dottedPaint =
        Paint()
          ..color = Colors.blue[400]!
          ..strokeWidth = 1;

    for (final point in points) {
      final x = point.dx * size.width;
      final y = point.dy * size.height;

      // Draw dotted line
      for (double dy = y + 8; dy < size.height; dy += 6) {
        canvas.drawLine(Offset(x, dy), Offset(x, dy + 3), dottedPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
