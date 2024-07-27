import 'package:flutter/material.dart';

class RingPainter extends CustomPainter {
  final double externalRadius;
  final double internalRadius;
  final Color ringColor;
  final Color innerColor;

  RingPainter({
    required this.externalRadius,
    required this.internalRadius,
    this.ringColor = Colors.blue,
    this.innerColor = Colors.white,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.fill;

    // Draw the outer circle
    canvas.drawCircle(size.center(Offset.zero), externalRadius, paint);

    // Draw the inner circle (cut out the middle)
    paint.color = innerColor; // Change color for the inner circle
    canvas.drawCircle(size.center(Offset.zero), internalRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redraw whenever values change
  }
}

class Ring extends StatelessWidget {
  final double externalRadius;
  final double internalRadius;

  const Ring({
    super.key,
    required this.externalRadius,
    required this.internalRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      // size: const Size(300, 300),
      painter: RingPainter(
        externalRadius: externalRadius,
        internalRadius: internalRadius,
      ),
    );
  }
}
