import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';
import 'auth_gate.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateToRegister(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // 1. Topographic map contour lines background
          Positioned.fill(
            child: CustomPaint(
              painter: TopographicMapPainter(),
            ),
          ),

          // 2. Logo in the upper section
          Positioned(
            top: topPadding + 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.people_alt,
                    size: 50,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          // 3. White wave container covering bottom half
          Positioned.fill(
            child: ClipPath(
              clipper: const BottomWaveClipper(),
              child: Container(
                color: Colors.white,
              ),
            ),
          ),

          // 4. Content inside the white section (matching mockup layout)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  30.0,
                  0,
                  28.0,
                  screenHeight > 700 ? 32.0 : 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E2022),
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Find Your Flock. Share the Journey.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connect with verified travel companions, build collaborative itineraries, and explore the world with TripNest.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Action button row matching mockup ("Sign Up to page >")
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => _navigateToRegister(context),
                        borderRadius: BorderRadius.circular(30),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 4.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Sign Up to page',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E2022),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// S-curved clipper matching the reference mockup
class BottomWaveClipper extends CustomClipper<Path> {
  const BottomWaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    // Starts on the left edge at 53% screen height
    path.moveTo(0, size.height * 0.53);

    // Smooth cubic curve dipping down across the middle
    path.cubicTo(
      size.width * 0.20,
      size.height * 0.49, // Crest on the left
      size.width * 0.48,
      size.height * 0.65, // Slope through center
      size.width * 0.82,
      size.height * 0.67, // Trough towards the right
    );

    // Softly levels out to the right edge
    path.quadraticBezierTo(
      size.width * 0.93,
      size.height * 0.675,
      size.width,
      size.height * 0.65,
    );

    // Complete the lower card
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Custom painter for the topographical contour elevation lines
class TopographicMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Draw contour lines for several terrain peak centers
    final peaks = [
      _Peak(Offset(size.width * 0.50, size.height * 0.15), 18, 200, 16, 0.4),
      _Peak(Offset(size.width * 0.90, size.height * 0.32), 16, 170, 16, 1.2),
      _Peak(Offset(size.width * 0.10, size.height * 0.38), 16, 150, 16, 2.5),
      _Peak(Offset(size.width * 0.80, size.height * 0.48), 14, 140, 16, 3.8),
    ];

    for (final peak in peaks) {
      for (double r = peak.minRadius; r <= peak.maxRadius; r += peak.step) {
        final path = Path();
        const int segments = 72;
        for (int i = 0; i <= segments; i++) {
          final theta = i * (2 * math.pi / segments);
          final wobble = 1.0 +
              0.12 * math.sin(2 * theta + peak.seed) +
              0.08 * math.cos(3 * theta + peak.seed * 1.4) +
              0.05 * math.sin(5 * theta - peak.seed);
          final rad = r * wobble;
          final x = peak.center.dx + rad * math.cos(theta);
          final y = peak.center.dy + rad * 0.85 * math.sin(theta);
          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        canvas.drawPath(path, linePaint);
      }
    }

    // Additional flowing contour ridges across canvas
    for (double yBase = 20; yBase <= size.height * 0.65; yBase += 22) {
      final path = Path();
      bool first = true;
      for (double x = -30; x <= size.width + 30; x += 8) {
        final nx = x / size.width;
        final y = yBase +
            14 * math.sin(nx * math.pi * 2.3 + yBase * 0.02) +
            9 * math.cos(nx * math.pi * 3.7 - yBase * 0.04);
        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Peak {
  final Offset center;
  final double minRadius;
  final double maxRadius;
  final double step;
  final double seed;

  const _Peak(
    this.center,
    this.minRadius,
    this.maxRadius,
    this.step,
    this.seed,
  );
}
