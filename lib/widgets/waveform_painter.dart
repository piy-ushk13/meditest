import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final int barCount;
  final Color color;
  final double heightScale;

  WaveformPainter({
    required this.amplitudes,
    this.barCount = 12, // Number of bars
    this.color = Colors.white,
    this.heightScale = 6.0, // Height scaling factor
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    final barWidth = size.width / (barCount * 2.0); // Width of each bar
    final spacing = barWidth; // Spacing between bars
    final centerY = size.height / 2;
    final maxHeight = size.height * heightScale;

    // Ensure the bars are always visible, even when there's no input
    double defaultHeight = 0.1 * maxHeight; // Minimal height when there's no input

    for (int i = 0; i < barCount; i++) {
      int idx = amplitudes.length - barCount + i;
      double amp = 0.0;

      // If there's input, update the height of the bars based on amplitude
      if (idx >= 0 && idx < amplitudes.length) {
        amp = amplitudes[idx].clamp(0.0, 1.0);
      }

      // Set the height to either the default value or the amplitude-based value
      double barHeight = amp * maxHeight > defaultHeight ? amp * maxHeight : defaultHeight;

      final x = i * (barWidth + spacing);

      // Draw the bars with dynamic height and centered positioning
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + barWidth / 2, centerY),
            width: barWidth,
            height: barHeight,
          ),
          const Radius.circular(6),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter old) {
    return old.amplitudes != amplitudes;
  }
}
