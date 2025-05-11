import 'dart:math' as math;
import 'package:flutter/material.dart';

class AiSphereWidget extends StatefulWidget {
  final bool isUserSpeaking;
  final bool isAiSpeaking;
  final double baseSize;

  const AiSphereWidget({
    super.key,
    required this.isUserSpeaking,
    required this.isAiSpeaking,
    this.baseSize = 100.0,
  });

  @override
  State<AiSphereWidget> createState() => _AiSphereWidgetState();
}

class _AiSphereWidgetState extends State<AiSphereWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationXController;
  late AnimationController _rotationYController;
  late AnimationController _rotationZController;
  late AnimationController _sizeController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    // Rotation controllers for 3D effect
    _rotationXController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _rotationYController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _rotationZController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Size animation controller
    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _sizeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _sizeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AiSphereWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation states based on speaking status
    if (widget.isUserSpeaking && !oldWidget.isUserSpeaking) {
      _sizeController.forward();
      _rotationXController.animateTo(1.0, duration: const Duration(seconds: 4));
      _rotationYController.animateTo(1.0, duration: const Duration(seconds: 4));
      _rotationZController.animateTo(1.0, duration: const Duration(seconds: 4));
    } else if (!widget.isUserSpeaking && oldWidget.isUserSpeaking) {
      _sizeController.reverse();
      _rotationXController.repeat(period: const Duration(seconds: 8));
      _rotationYController.repeat(period: const Duration(seconds: 10));
      _rotationZController.repeat(period: const Duration(seconds: 12));
    }

    // Adjust rotation speed when AI is speaking
    if (widget.isAiSpeaking && !oldWidget.isAiSpeaking) {
      _sizeController.reverse();
      _rotationXController.repeat(period: const Duration(seconds: 4));
      _rotationYController.repeat(period: const Duration(seconds: 5));
      _rotationZController.repeat(period: const Duration(seconds: 6));
    } else if (!widget.isAiSpeaking && oldWidget.isAiSpeaking) {
      _rotationXController.repeat(period: const Duration(seconds: 8));
      _rotationYController.repeat(period: const Duration(seconds: 10));
      _rotationZController.repeat(period: const Duration(seconds: 12));
    }
  }

  @override
  void dispose() {
    _rotationXController.dispose();
    _rotationYController.dispose();
    _rotationZController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationXController,
        _rotationYController,
        _rotationZController,
        _sizeController,
      ]),
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(_rotationXController.value * 2 * math.pi)
            ..rotateY(_rotationYController.value * 2 * math.pi)
            ..rotateZ(_rotationZController.value * 2 * math.pi)
            ..scale(_getSphereSize()),
          child: _buildSphere(),
        );
      },
    );
  }

  double _getSphereSize() {
    if (widget.isUserSpeaking) {
      return _sizeAnimation.value;
    } else if (widget.isAiSpeaking) {
      return 0.8; // Smaller when AI is speaking
    } else {
      return 1.0; // Default size
    }
  }

  Widget _buildSphere() {
    return Container(
      width: widget.baseSize,
      height: widget.baseSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 230), // 0.9 * 255 = 230
            Colors.blue.withValues(alpha: 178), // 0.7 * 255 = 178
            Colors.pink.withValues(alpha: 178), // 0.7 * 255 = 178
          ],
          stops: const [0.2, 0.5, 0.9],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 128), // 0.5 * 255 = 128
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(
        painter: SpherePainter(),
      ),
    );
  }
}

class SpherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create a base sphere with a soft white glow
    final basePaint = Paint()
      ..color = Colors.white.withValues(alpha: 204) // 0.8 * 255 = 204
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, radius * 0.95, basePaint);

    // Create the main sphere with blue-pink gradient
    final mainPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.withValues(alpha: 178), // 0.7 * 255 = 178
          Colors.purple.withValues(alpha: 153), // 0.6 * 255 = 153
          Colors.pink.withValues(alpha: 178), // 0.7 * 255 = 178
        ],
        stops: const [0.2, 0.5, 0.8],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.85, mainPaint);

    // Add a translucent overlay to create depth
    final overlayPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 153), // 0.6 * 255 = 153
          Colors.white.withValues(alpha: 0),
        ],
        stops: const [0.0, 1.0],
        center: const Alignment(-0.3, -0.3),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.85, overlayPaint);

    // Add highlight to create glass-like effect
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 102) // 0.4 * 255 = 102
      ..style = PaintingStyle.fill;

    final highlightPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
          width: radius * 0.4,
          height: radius * 0.4,
        ),
      );

    canvas.drawPath(highlightPath, highlightPaint);

    // Add a smaller secondary highlight
    final smallHighlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 153) // 0.6 * 255 = 153
      ..style = PaintingStyle.fill;

    final smallHighlightPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(center.dx - radius * 0.4, center.dy - radius * 0.4),
          width: radius * 0.15,
          height: radius * 0.15,
        ),
      );

    canvas.drawPath(smallHighlightPath, smallHighlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
