import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xFFCBE5FD),
      body: Stack(
        children: [
          // 1. Scenic Landscape Background Photo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.68,
            child: Image.network(
              'https://images.unsplash.com/photo-1528127269322-539801943592?w=1200&q=80',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF64B5F6),
              ),
            ),
          ),

          // 2. Soft Gradient Overlay from top sky
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF90CAFA),
                    Color(0xFFC7D5FD),
                    Color(0x00C7D5FD),
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // 3. Topographic map contour lines background (subtle & clean)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.45,
            child: CustomPaint(
              painter: TopographicMapPainter(),
            ),
          ),

          // 4. Centered Logo Badge in the upper section
          Positioned(
            top: mediaQuery.padding.top + 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.10),
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
                    Icons.groups_rounded,
                    size: 44,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
          ),

          // 5. Floating Frosted Card (Top-Right, shifted towards center): "A BRIGHTER JOURNEY TOGETHER"
          Positioned(
            top: mediaQuery.padding.top + 150,
            right: 56,
            child: _buildFrostedPill(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'A BRIGHTER',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Color(0xFF334155),
                        ),
                      ),
                      Text(
                        'JOURNEY',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Color(0xFF334155),
                        ),
                      ),
                      Text(
                        'TOGETHER',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 6. Floating Frosted Card (Mid-Left over photo, shifted towards center): "MORE THAN A TRIP"
          Positioned(
            top: mediaQuery.padding.top + 270,
            left: 56,
            child: _buildFrostedPill(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.landscape_rounded,
                    size: 17,
                    color: Color(0xFF334155),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'MORE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Color(0xFF334155),
                        ),
                      ),
                      Text(
                        'THAN A TRIP',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 9. White Wave organic container sweeping across bottom half
          Positioned.fill(
            child: ClipPath(
              clipper: const BottomWaveClipper(),
              child: Container(
                color: Colors.white,
              ),
            ),
          ),

          // 10. Content inside the white bottom section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  32.0,
                  0,
                  32.0,
                  screenHeight > 700 ? 36.0 : 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -1.2,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Find Your Flock. Share the Journey.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E3A8A),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Connect with verified travel companions, build collaborative itineraries, and explore the world with TripNest.',
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: const Color(0xFF475569),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Bottom Row: "GOOD TRAVELLERS..." (left) + "Sign up to page >" (right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Left sub-caption
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 1.5,
                              color: const Color(0xFFCBD5E1),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'GOOD',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const Text(
                              'TRAVELLERS',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const Text(
                              'GO FURTHER',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),

                        // Right CTA button: "Sign up to page" + circular arrow icon
                        InkWell(
                          onTap: () => _navigateToRegister(context),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 6.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Sign up to page',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F172A),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0F172A).withValues(alpha: 0.3),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildFrostedPill({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1.0,
            ),
          ),
          child: child,
        ),
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
    // Starts on left edge at 52% height
    path.moveTo(0, size.height * 0.52);

    // Smooth organic wave dipping down through center right
    path.cubicTo(
      size.width * 0.28,
      size.height * 0.48, // Crest on the left
      size.width * 0.65,
      size.height * 0.64, // Dip down through the middle
      size.width * 0.90,
      size.height * 0.64, // Smooth trough on right
    );

    // Curve back up slightly at the rightmost edge
    path.quadraticBezierTo(
      size.width * 0.97,
      size.height * 0.64,
      size.width,
      size.height * 0.62,
    );

    // Complete the lower white card shape
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
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1
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

