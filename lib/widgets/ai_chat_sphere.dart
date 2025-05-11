import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AiChatSphere extends StatefulWidget {
  /// Whether the user is currently speaking
  final bool isUserSpeaking;

  /// Audio level from the user's microphone (0.0 to 1.0)
  final double audioLevel;

  /// Whether the AI is currently speaking
  final bool isAiSpeaking;

  /// Size of the sphere in pixels
  final double size;

  /// Optional callback when the sphere is tapped
  final VoidCallback? onTap;

  const AiChatSphere({
    super.key,
    required this.isUserSpeaking,
    this.audioLevel = 0.0,
    required this.isAiSpeaking,
    this.size = 200.0,
    this.onTap,
  });

  @override
  State<AiChatSphere> createState() => _AiChatSphereState();
}

class _AiChatSphereState extends State<AiChatSphere>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _scaleController;
  late AnimationController _rotationXController;
  late AnimationController _rotationYController;
  late AnimationController _rotationZController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _scaleAnimation;

  // Sphere properties
  double _currentScale = 1.0;

  // Colors
  final Color _baseColor = Colors.white;
  final Color _accentColor1 = Colors.blue;
  final Color _accentColor2 = Colors.pink;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotationXController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );

    _rotationYController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _rotationZController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Setup scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    // Start rotation animations
    _rotationXController.repeat();
    _rotationYController.repeat();
    _rotationZController.repeat();
  }

  @override
  void didUpdateWidget(AiChatSphere oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle state changes
    if (widget.isUserSpeaking && !oldWidget.isUserSpeaking) {
      _scaleController.forward();
      _rotationXController.stop();
      _rotationYController.repeat(period: const Duration(seconds: 12));
      _rotationZController.stop();
    } else if (!widget.isUserSpeaking && oldWidget.isUserSpeaking) {
      _scaleController.reverse();
      _resetRotations();
    }

    if (widget.isAiSpeaking && !oldWidget.isAiSpeaking) {
      _scaleController.reverse();
      _rotationXController.repeat(period: const Duration(seconds: 18));
      _rotationYController.repeat(period: const Duration(seconds: 10));
      _rotationZController.repeat(period: const Duration(seconds: 24));
    } else if (!widget.isAiSpeaking && oldWidget.isAiSpeaking) {
      _resetRotations();
    }

    // Force update
    setState(() {
      _updateSphereProperties();
    });
  }

  void _resetRotations() {
    _rotationXController.repeat(period: const Duration(seconds: 18));
    _rotationYController.repeat(period: const Duration(seconds: 12));
    _rotationZController.repeat(period: const Duration(seconds: 24));
  }

  void _updateSphereProperties() {
    // Update scale based on state
    if (widget.isUserSpeaking) {
      // Base scale from animation plus modulation from audio level
      _currentScale = _scaleAnimation.value + (widget.audioLevel * 0.1);
    } else if (widget.isAiSpeaking) {
      // Smaller scale with subtle pulsing
      _currentScale = 0.7 + (_pulseController.value * 0.1);
    } else {
      // Default scale with subtle breathing effect
      _currentScale =
          1.0 + (math.sin(_rotationYController.value * math.pi * 2) * 0.02);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationXController.dispose();
    _rotationYController.dispose();
    _rotationZController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationXController,
          _rotationYController,
          _rotationZController,
          _scaleController,
          _pulseController,
        ]),
        builder: (context, child) {
          // Calculate rotation angles based on state
          double rotX = 0.0;
          double rotY = 0.0;
          double rotZ = 0.0;

          if (widget.isUserSpeaking) {
            // Rotate only around Y axis when user is speaking
            rotY = _rotationYController.value * math.pi * 2;
          } else if (widget.isAiSpeaking) {
            // Rotate around all axes when AI is speaking
            rotX = _rotationXController.value * math.pi * 2;
            rotY = _rotationYController.value * math.pi * 2;
            rotZ = _rotationZController.value * math.pi * 2;
          } else {
            // Default slow rotation
            rotX = _rotationXController.value * math.pi * 2;
            rotY = _rotationYController.value * math.pi * 2;
            rotZ = _rotationZController.value * math.pi * 2;
          }

          // Update scale
          _updateSphereProperties();

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateX(rotX)
                  ..rotateY(rotY)
                  ..rotateZ(rotZ)
                  ..scale(_currentScale),
            child: CustomPaint(
              painter: Sphere3DPainter(
                baseColor: _baseColor,
                accentColor1: _accentColor1,
                accentColor2: _accentColor2,
                rotationX: rotX,
                rotationY: rotY,
                rotationZ: rotZ,
              ),
              size: Size(widget.size, widget.size),
            ),
          );
        },
      ),
    );
  }
}

class Sphere3DPainter extends CustomPainter {
  final Color baseColor;
  final Color accentColor1;
  final Color accentColor2;
  final double rotationX;
  final double rotationY;
  final double rotationZ;

  // 3D sphere parameters
  final int segments = 24; // Higher for smoother sphere
  final List<vector.Vector3> vertices = [];
  final List<int> indices = [];

  Sphere3DPainter({
    required this.baseColor,
    required this.accentColor1,
    required this.accentColor2,
    required this.rotationX,
    required this.rotationY,
    required this.rotationZ,
  }) {
    _generateSphereGeometry();
  }

  void _generateSphereGeometry() {
    // Clear previous data
    vertices.clear();
    indices.clear();

    // Generate sphere vertices
    for (int y = 0; y <= segments; y++) {
      final v = y / segments;
      final phi = v * math.pi;

      for (int x = 0; x <= segments; x++) {
        final u = x / segments;
        final theta = u * math.pi * 2;

        // Spherical to Cartesian coordinates
        final posX = math.cos(theta) * math.sin(phi);
        final posY = math.cos(phi);
        final posZ = math.sin(theta) * math.sin(phi);

        vertices.add(vector.Vector3(posX, posY, posZ));
      }
    }

    // Generate indices for triangles
    for (int y = 0; y < segments; y++) {
      for (int x = 0; x < segments; x++) {
        final a = (y * (segments + 1)) + x;
        final b = a + 1;
        final c = a + (segments + 1);
        final d = c + 1;

        // Two triangles per quad
        indices.addAll([a, b, c]);
        indices.addAll([b, d, c]);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create a base sphere with a soft white glow
    final basePaint =
        Paint()
          ..color = baseColor.withValues(
            alpha: 0.8,
          ) // Use double value for alpha
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, radius * 0.95, basePaint);

    // Setup 3D transformation matrices
    final modelMatrix =
        vector.Matrix4.identity()
          ..rotateX(rotationX)
          ..rotateY(rotationY)
          ..rotateZ(rotationZ);

    // Draw triangles
    for (int i = 0; i < indices.length; i += 3) {
      final a = vertices[indices[i]];
      final b = vertices[indices[i + 1]];
      final c = vertices[indices[i + 2]];

      // Transform vertices
      final aTransformed = modelMatrix.transformed3(a);
      final bTransformed = modelMatrix.transformed3(b);
      final cTransformed = modelMatrix.transformed3(c);

      // Calculate normal for lighting
      final ab = bTransformed - aTransformed;
      final ac = cTransformed - aTransformed;
      final normal = ab.cross(ac)..normalize();

      // Simple lighting calculation
      final lightDir = vector.Vector3(0.5, 0.5, 1.0)..normalize();
      double diffuse = normal.dot(lightDir);
      diffuse = diffuse.clamp(0.2, 1.0); // Add some ambient light

      // Skip triangles facing away from camera (backface culling)
      if (normal.z > 0) {
        // Project to 2D screen space
        final aScreen = Offset(
          center.dx + aTransformed.x * radius,
          center.dy + aTransformed.y * radius,
        );
        final bScreen = Offset(
          center.dx + bTransformed.x * radius,
          center.dy + bTransformed.y * radius,
        );
        final cScreen = Offset(
          center.dx + cTransformed.x * radius,
          center.dy + cTransformed.y * radius,
        );

        // Determine color based on position and lighting
        final t = (aTransformed.y + 1) / 2; // Normalize to 0-1
        final alpha = (0.7 * diffuse).clamp(0.0, 1.0);
        final color =
            Color.lerp(
              accentColor1.withValues(
                alpha: alpha,
              ), // Use withValues with double
              accentColor2.withValues(
                alpha: alpha,
              ), // Use withValues with double
              t,
            )!;

        // Draw triangle
        final path =
            Path()
              ..moveTo(aScreen.dx, aScreen.dy)
              ..lineTo(bScreen.dx, bScreen.dy)
              ..lineTo(cScreen.dx, cScreen.dy)
              ..close();

        canvas.drawPath(path, Paint()..color = color);
      }
    }

    // Add a translucent overlay to create depth
    final overlayPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.6), // Use double value for alpha
              Colors.white.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 1.0],
            center: const Alignment(-0.3, -0.3),
          ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.85, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant Sphere3DPainter oldDelegate) =>
      oldDelegate.rotationX != rotationX ||
      oldDelegate.rotationY != rotationY ||
      oldDelegate.rotationZ != rotationZ ||
      oldDelegate.baseColor != baseColor ||
      oldDelegate.accentColor1 != accentColor1 ||
      oldDelegate.accentColor2 != accentColor2;
}
