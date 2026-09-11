import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';

/// Interactive Travel ID Badge enclosed in a realistic clear plastic lanyard pouch
/// with top metal clip, zip-lock seal, and a multi-flip 3D card animation.
class TravelIdBadge extends StatefulWidget {
  final UserProfile profile;
  final String? displayName;
  final String? displayAge;
  final String? displayInstagram;
  final String? displayX;
  final String? profileImage;
  final VoidCallback? onPhotoTap;
  final bool animateFlipOnMount;
  final bool enableTapToFlip;

  const TravelIdBadge({
    super.key,
    required this.profile,
    this.displayName,
    this.displayAge,
    this.displayInstagram,
    this.displayX,
    this.profileImage,
    this.onPhotoTap,
    this.animateFlipOnMount = true,
    this.enableTapToFlip = true,
  });

  @override
  State<TravelIdBadge> createState() => _TravelIdBadgeState();
}

class _TravelIdBadgeState extends State<TravelIdBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    // 6 * pi = 3 full turns (several flips) before landing on front (angle 0)
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _flipAnimation = Tween<double>(
      begin: 6 * math.pi,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeOutCubic,
      ),
    );

    if (widget.animateFlipOnMount) {
      // Delay slightly for dramatic entry effect
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          _flipController.forward(from: 0.0);
        }
      });
    } else {
      _flipController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _triggerFlip() {
    if (!widget.enableTapToFlip) return;
    if (_flipController.isAnimating) return;

    _flipController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    // Resolve displayed values
    final name = (widget.displayName != null && widget.displayName!.trim().isNotEmpty)
        ? widget.displayName!.trim()
        : widget.profile.name;
    final age = (widget.displayAge != null && widget.displayAge!.trim().isNotEmpty)
        ? widget.displayAge!.trim()
        : (widget.profile.age > 0 ? widget.profile.age.toString() : '24');
    final ig = (widget.displayInstagram != null && widget.displayInstagram!.trim().isNotEmpty)
        ? widget.displayInstagram!.trim()
        : (widget.profile.instagram ?? '');
    final x = (widget.displayX != null && widget.displayX!.trim().isNotEmpty)
        ? widget.displayX!.trim()
        : (widget.profile.xHandle ?? '');
    final photo = (widget.profileImage != null && widget.profileImage!.trim().isNotEmpty)
        ? widget.profileImage!
        : (widget.profile.avatarUrl ??
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500');

    // Preferences
    final pace = widget.profile.travelPace.isNotEmpty ? widget.profile.travelPace : 'Relaxed';
    final vibe = widget.profile.destinationVibe.isNotEmpty ? widget.profile.destinationVibe : 'Vibrant City';
    final style = widget.profile.planningStyle.isNotEmpty ? widget.profile.planningStyle : 'Spontaneous';

    const cardWidth = 276.0;
    const cardHeight = 490.0;
    const pouchHorizontalPadding = 12.0;
    const pouchTopExtension = 64.0;
    const pouchBottomExtension = 14.0;
    const totalPouchWidth = cardWidth + (pouchHorizontalPadding * 2);
    const totalPouchHeight = cardHeight + pouchTopExtension + pouchBottomExtension;

    return Center(
      child: GestureDetector(
        onTap: _triggerFlip,
        child: SizedBox(
          width: totalPouchWidth,
          height: totalPouchHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ====================================================
              // 1. CLEAR PLASTIC VINYL SLEEVE / POUCH (OUTER CASING)
              // ====================================================
              Positioned.fill(
                child: CustomPaint(
                  painter: _PlasticSleevePainter(),
                ),
              ),

              // ====================================================
              // 2. TOP METALLIC LANYARD RING & HARDWARE CLIP
              // ====================================================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 60,
                    height: 48,
                    child: CustomPaint(
                      painter: _LanyardClipPainter(),
                    ),
                  ),
                ),
              ),

              // ====================================================
              // 3. FLIPPING BADGE CARD (INSIDE THE SLEEVE)
              // ====================================================
              Positioned(
                top: pouchTopExtension,
                left: pouchHorizontalPadding,
                width: cardWidth,
                height: cardHeight,
                child: AnimatedBuilder(
                  animation: _flipAnimation,
                  builder: (context, child) {
                    final angle = _flipAnimation.value;
                    // Determine which face is visible
                    final normalized = (angle % (2 * math.pi));
                    final isFront = normalized <= (math.pi / 2) || normalized >= (3 * math.pi / 2);

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0018) // Perspective tilt
                        ..rotateY(angle),
                      child: isFront
                          ? _buildCardFront(
                              name: name,
                              age: age,
                              pace: pace,
                              vibe: vibe,
                              style: style,
                              ig: ig,
                              x: x,
                              photo: photo,
                              width: cardWidth,
                              height: cardHeight,
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: _buildCardBack(
                                width: cardWidth,
                                height: cardHeight,
                              ),
                            ),
                    );
                  },
                ),
              ),

              // ====================================================
              // 4. VINYL GLOSS & LIGHT REFLECTION OVERLAY
              // ====================================================
              Positioned(
                top: pouchTopExtension,
                left: pouchHorizontalPadding,
                width: cardWidth,
                height: cardHeight,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.18),
                          Colors.white.withValues(alpha: 0.04),
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.08),
                        ],
                        stops: const [0.0, 0.25, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CARD FRONT: Exactly matching the "THE PERFORMER" Layout
  // ==========================================================
  Widget _buildCardFront({
    required String name,
    required String age,
    required String pace,
    required String vibe,
    required String style,
    required String ig,
    required String x,
    required String photo,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F8F4), // Authentic warm cream cardstock
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ----------------------------------------------------
          // Top Header: "THE EXPLORER" & "DROP : 26"
          // ----------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'THE',
                      style: GoogleFonts.archivoBlack(
                        fontSize: 16,
                        height: 0.95,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF141414),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      'EXPLORER',
                      style: GoogleFonts.archivoBlack(
                        fontSize: 21,
                        height: 0.95,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF141414),
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'DROP : 26',
                    style: GoogleFonts.spaceMono(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF222222),
                      letterSpacing: 0.4,
                    ),
                  ),
                  if (widget.profile.verified) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 10, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            'VERIFIED',
                            style: TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const SizedBox(height: 5),

          // Dotted rule under header
          CustomPaint(
            size: const Size(double.infinity, 3),
            painter: _DottedHLinePainter(),
          ),

          const SizedBox(height: 4),

          // Subtitle line: "TRAVEL IDENTITY PASS  tripnest"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'TRAVEL IDENTITY PASS',
                  style: GoogleFonts.spaceMono(
                    fontSize: 8.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF333333),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Text(
                'tripnest',
                style: GoogleFonts.syne(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF141414),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ----------------------------------------------------
          // Center Portrait Photo (Cleanly framed rectangular)
          // ----------------------------------------------------
          Center(
            child: GestureDetector(
              onTap: widget.onPhotoTap,
              child: Container(
                width: 96,
                height: 104,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  border: Border.all(color: const Color(0xFFDCD8CF), width: 2),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        photo,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFF0B2240),
                          child: const Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (widget.onPhotoTap != null)
                        Positioned(
                          bottom: 3,
                          right: 3,
                          child: Container(
                            padding: const EdgeInsets.all(2.5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ----------------------------------------------------
          // Metadata Fields with Dashed Separators
          // ----------------------------------------------------
          _buildMetaRow(
            label: 'NAME',
            value: name,
            valueFontSize: 21,
          ),
          _buildDashedLine(),

          _buildMetaRow(
            label: 'AGE',
            value: age.isNotEmpty ? '$age YRS' : '24 YRS',
            valueFontSize: 19,
          ),
          _buildDashedLine(),

          _buildMetaRow(
            label: 'PACE',
            value: pace,
            valueFontSize: 18,
          ),
          _buildDashedLine(),

          _buildMetaRow(
            label: 'VIBE',
            value: vibe,
            valueFontSize: 18,
          ),
          _buildDashedLine(),

          _buildMetaRow(
            label: 'STYLE',
            value: style,
            valueFontSize: 18,
          ),

          if (ig.isNotEmpty) ...[
            _buildDashedLine(),
            _buildMetaRow(
              label: 'INSTA',
              value: ig,
              valueFontSize: 17,
            ),
          ],
          if (x.isNotEmpty) ...[
            _buildDashedLine(),
            _buildMetaRow(
              label: 'X (TW)',
              value: x,
              valueFontSize: 17,
            ),
          ],

          const Spacer(),

          // ----------------------------------------------------
          // Bottom Footer: Official Holder Notice + Stencil Code
          // ----------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'THE HOLDER OF THIS CARD IS AN\nOFFICIAL EXPLORER FOR TRIPNEST',
                  style: GoogleFonts.spaceMono(
                    fontSize: 6.8,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: const Color(0xFF333333),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '45-12H',
                style: GoogleFonts.archivoBlack(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF141414),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CARD BACK: Branded Security Back for the 3D Flip
  // ==========================================================
  // ==========================================================
  // CARD BACK: Branded Security Back for the 3D Flip
  // ==========================================================
  Widget _buildCardBack({
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EFE9),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0B2240), width: 2),
            ),
            child: const Icon(
              Icons.explore_rounded,
              size: 40,
              color: Color(0xFF0B2240),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'TRIPNEST ARCHIVE',
            style: GoogleFonts.archivoBlack(
              fontSize: 16,
              color: const Color(0xFF0B2240),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'OFFICIAL TRAVEL IDENTITY PASS',
            style: GoogleFonts.spaceMono(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 24,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Center(
              child: Text(
                '★ VERIFIED EXPLORER ★',
                style: GoogleFonts.spaceMono(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0B2240),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tap badge anytime to inspect details',
            style: GoogleFonts.caveat(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Row with Small Monospace Label + Authentic Handwritten Marker Value
  Widget _buildMetaRow({
    required String label,
    required String value,
    required double valueFontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 58,
            child: Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF444444),
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.caveat(
                fontSize: valueFontSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF10141A),
                height: 1.0,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: CustomPaint(
        size: const Size(double.infinity, 1.5),
        painter: _DashedHLinePainter(),
      ),
    );
  }
}

// ==========================================================
// CUSTOM PAINTERS: Clear Plastic Vinyl Sleeve, Hardware & Lines
// ==========================================================

/// Paints the clear plastic sleeve with heat-sealed double borders,
/// zip-lock ribs, and hanging slot.
class _PlasticSleevePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double radius = 10.0;
    final rrectOuter = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    );

    // 1. Pouch Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawRRect(rrectOuter.shift(const Offset(0, 6)), shadowPaint);

    // 2. Clear Vinyl Body Background (subtle smoky tint)
    final vinylPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrectOuter, vinylPaint);

    // 3. Outer Edge Heat-Seal (double line)
    final sealPaintOuter = Paint()
      ..color = const Color(0xFFB0B8C2).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(rrectOuter, sealPaintOuter);

    final rrectInnerSeal = RRect.fromRectAndRadius(
      Rect.fromLTWH(3, 3, size.width - 6, size.height - 6),
      const Radius.circular(radius - 2),
    );
    final sealPaintInner = Paint()
      ..color = const Color(0xFFCBD2DA).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrectInnerSeal, sealPaintInner);

    // 4. Horizontal Zip-Lock Ribs at the top
    final zipPaint = Paint()
      ..color = const Color(0xFFA8B2BC).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    const zipY1 = 44.0;
    const zipY2 = 49.0;
    canvas.drawLine(const Offset(10, zipY1), Offset(size.width - 10, zipY1), zipPaint);
    canvas.drawLine(const Offset(10, zipY2), Offset(size.width - 10, zipY2), zipPaint);

    // 5. Punch Holes in Top Tab:
    // Left eyelet hole
    final eyeletBorderPaint = Paint()
      ..color = const Color(0xFF9EA7B2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final eyeletFillPaint = Paint()
      ..color = const Color(0xFFD4DAE0).withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(36, 22), 8, eyeletFillPaint);
    canvas.drawCircle(const Offset(36, 22), 8, eyeletBorderPaint);

    // Right eyelet hole
    canvas.drawCircle(Offset(size.width - 36, 22), 8, eyeletFillPaint);
    canvas.drawCircle(Offset(size.width - 36, 22), 8, eyeletBorderPaint);

    // Center punched oval slot for the lanyard clip
    final slotRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, 22),
        width: 44,
        height: 12,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(slotRect, eyeletFillPaint);
    canvas.drawRRect(slotRect, eyeletBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the metal split ring / carabiner clip passing through the center punched slot.
class _LanyardClipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Metal Ring Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX, 20), width: 22, height: 32),
      shadowPaint,
    );

    // Metal Ring (Steel Gradient)
    final ringPaint = Paint()
      ..color = const Color(0xFF7A8694)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(centerX, 18), width: 22, height: 32),
      ringPaint,
    );

    // Highlight on metal
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(centerX, 18), width: 22, height: 32),
      -math.pi * 0.7,
      math.pi * 0.5,
      false,
      highlightPaint,
    );

    // Swivel clasp tab above ring
    final claspPaint = Paint()
      ..color = const Color(0xFF5A6673)
      ..style = PaintingStyle.fill;
    final claspRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(centerX, 4), width: 14, height: 10),
      const Radius.circular(3),
    );
    canvas.drawRRect(claspRRect, claspPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints a delicate horizontal dashed line between metadata rows
class _DashedHLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC7C2B6)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    const dashWidth = 3.0;
    const dashSpace = 2.5;
    double currentX = 0.0;

    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, size.height / 2),
        Offset(math.min(currentX + dashWidth, size.width), size.height / 2),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints a dotted line under the header
class _DottedHLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF141414)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dotSpace = 3.5;
    double currentX = 0.0;

    while (currentX < size.width) {
      canvas.drawCircle(Offset(currentX, size.height / 2), 0.8, paint);
      currentX += dotSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
