import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../theme.dart';

/// Reusable Boarding Pass Ticket matching the authentic travel ticket design
class BoardingPassTicket extends StatelessWidget {
  final UserProfile profile;
  final String? displayName;
  final String? displayAge;
  final String? displayInstagram;
  final String? displayX;
  final String? profileImage;
  final VoidCallback? onPhotoTap;
  final double ticketWidth;
  final double ticketHeight;
  final double splitRatio;

  const BoardingPassTicket({
    super.key,
    required this.profile,
    this.displayName,
    this.displayAge,
    this.displayInstagram,
    this.displayX,
    this.profileImage,
    this.onPhotoTap,
    this.ticketWidth = 800.0,
    this.ticketHeight = 340.0,
    this.splitRatio = 0.69,
  });

  @override
  Widget build(BuildContext context) {
    final splitX = ticketWidth * splitRatio;

    final name = (displayName != null && displayName!.trim().isNotEmpty)
        ? displayName!.trim().toUpperCase()
        : (profile.name.isNotEmpty ? profile.name.toUpperCase() : 'HARSHALL D.P');

    final age = (displayAge != null && displayAge!.trim().isNotEmpty)
        ? displayAge!.trim()
        : '${profile.age > 0 ? profile.age : 24}';

    final igRaw = displayInstagram ?? profile.instagram ?? '';
    final ig = igRaw.trim().isEmpty ? '-' : '@${igRaw.trim().replaceAll('@', '')}';

    final xRaw = displayX ?? profile.xHandle ?? '';
    final x = xRaw.trim().isEmpty ? '-' : '@${xRaw.trim().replaceAll('@', '')}';

    final image = (profileImage != null && profileImage!.isNotEmpty)
        ? profileImage!
        : ((profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
            ? profile.avatarUrl!
            : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500');

    return ClipPath(
      clipper: TicketClipper(
        splitRatio: splitRatio,
        notchRadius: 14.0,
        cornerRadius: 16.0,
      ),
      child: Container(
        width: ticketWidth,
        height: ticketHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ==========================================
            // 1. TOP NAVY BANNER
            // ==========================================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 42,
              child: Container(
                color: const Color(0xFF0B2240),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'PASSENGER TICKET',
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'BOARDING PASS',
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 80),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BOARDING PASS',
                          style: GoogleFonts.cinzel(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'TEMPORARY CLASS',
                          style: GoogleFonts.cinzel(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: const Color(0xFF87CEFA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 2. VERTICAL PERFORATION DASHED LINE
            // ==========================================
            Positioned(
              left: splitX - 1,
              top: 0,
              bottom: 0,
              width: 2,
              child: CustomPaint(
                painter: DashedLinePainter(
                  color: const Color(0xFF0B2240).withValues(alpha: 0.5),
                  dashHeight: 5,
                  dashSpace: 4,
                ),
              ),
            ),

            // ==========================================
            // 3. MAIN PASSENGER TICKET (LEFT SECTION)
            // ==========================================
            Positioned(
              left: 0,
              top: 42,
              bottom: 0,
              width: splitX,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo with EXCLUSIVE Rubber Stamp
                    GestureDetector(
                      onTap: onPhotoTap,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 112,
                            height: 142,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF0B2240).withValues(alpha: 0.18),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: const Color(0xFF0B2240),
                                  child: const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 52,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // EXCLUSIVE Rubber Stamp (Angled double-border box)
                          Positioned(
                            bottom: -6,
                            right: -10,
                            child: Transform.rotate(
                              angle: -0.18,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF0B2240),
                                    width: 2.2,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                  color: const Color(0xFFF7F8FA),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFF0B2240),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    'EXCLUSIVE',
                                    style: GoogleFonts.spaceMono(
                                      color: const Color(0xFF0B2240),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Passenger Metadata Grid (2 Columns)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: USERNAME & TRAIN
                          Row(
                            children: [
                              Expanded(
                                child: _buildTicketField(
                                  label: 'USERNAME',
                                  value: profile.username.toUpperCase(),
                                ),
                              ),
                              Expanded(
                                child: _buildTicketField(
                                  label: 'TRAIN',
                                  value: 'OURSTATION',
                                ),
                              ),
                            ],
                          ),
                          // Row 2: FROM & DEPARTURE
                          Row(
                            children: [
                              Expanded(
                                child: _buildTicketField(
                                  label: 'FROM',
                                  value: 'WIYANA, MARCH',
                                ),
                              ),
                              Expanded(
                                child: _buildTicketField(
                                  label: 'DEPARTURE',
                                  value: '05:00PM',
                                ),
                              ),
                            ],
                          ),
                          // Row 3: TO & ARRIVE
                          Row(
                            children: [
                              Expanded(
                                child: _buildTicketField(
                                  label: 'TO',
                                  value: 'WIDARPA, MAY',
                                ),
                              ),
                              Expanded(
                                child: _buildTicketField(
                                  label: 'ARRIVE',
                                  value: '12:00PM',
                                ),
                              ),
                            ],
                          ),
                          // Row 4: DATE & SEAT
                          Row(
                            children: [
                              Expanded(
                                child: _buildTicketField(
                                  label: 'DATE',
                                  value: '15 MARCH 2026',
                                ),
                              ),
                              Expanded(
                                child: _buildTicketField(
                                  label: 'SEAT',
                                  value: 'CD-M20',
                                ),
                              ),
                            ],
                          ),
                          // Row 5: PASSENGER & AGE
                          Row(
                            children: [
                              Expanded(
                                child: _buildTicketField(
                                  label: 'NAME OF PASSENGER',
                                  value: name,
                                  highlight: true,
                                ),
                              ),
                              Expanded(
                                child: _buildTicketField(
                                  label: 'AGE',
                                  value: '$age YRS',
                                  highlight: true,
                                ),
                              ),
                            ],
                          ),
                          // Row 6: INSTAGRAM & X (Optional)
                          Row(
                            children: [
                              Expanded(
                                child: _buildTicketField(
                                  label: 'INSTAGRAM',
                                  value: ig,
                                ),
                              ),
                              Expanded(
                                child: _buildTicketField(
                                  label: 'X (TWITTER)',
                                  value: x,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Barcode & Rotated TEMPORARY CLASS strip
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 236,
                            child: CustomPaint(
                              painter: BarcodePainter(
                                color: const Color(0xFF0B2240),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              'TEMPORARY CLASS',
                              style: GoogleFonts.spaceMono(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.2,
                                color: const Color(0xFF0B2240),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 4. BOARDING PASS STUB (RIGHT SECTION)
            // Displays preferences chosen by user previously
            // ==========================================
            Positioned(
              left: splitX,
              right: 0,
              top: 42,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTicketField(
                      label: 'NAME OF PASSENGER',
                      value: name,
                      highlight: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTicketField(
                            label: 'FROM',
                            value: 'WIYANA, MARCH',
                          ),
                        ),
                        Expanded(
                          child: _buildTicketField(
                            label: 'TO',
                            value: 'WIDARPA, MAY',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTicketField(
                            label: 'TRAIN',
                            value: 'OURSTATION',
                          ),
                        ),
                        Expanded(
                          child: _buildTicketField(
                            label: 'SEAT',
                            value: 'CD-M20',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: const Color(0xFF0B2240).withValues(alpha: 0.18),
                    ),
                    // Travel Preferences Header
                    Text(
                      'YOUR TRAVEL PREFERENCES',
                      style: GoogleFonts.spaceMono(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: const Color(0xFF0B2240),
                      ),
                    ),
                    _buildPreferenceRow('PACE', profile.travelPace),
                    _buildPreferenceRow('BUDGET', profile.budgetStyle),
                    _buildPreferenceRow('RHYTHM', profile.dailyRhythm),
                    _buildPreferenceRow('VIBE', profile.destinationVibe),
                    _buildPreferenceRow('STYLE', profile.planningStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketField({
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5A6E85),
            letterSpacing: 0.6,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.spaceMono(
            fontSize: highlight ? 13 : 11.5,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0B2240),
            letterSpacing: 0.4,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPreferenceRow(String title, String value) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: GoogleFonts.spaceMono(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5A6E85),
          ),
        ),
        Expanded(
          child: Text(
            value.toUpperCase(),
            style: GoogleFonts.spaceMono(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0B2240),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Helper modal to pick or upload a profile picture
void showAvatarPickerSheet({
  required BuildContext context,
  required String currentImage,
  required ValueChanged<String> onSelected,
}) {
  final urlInputController = TextEditingController();
  final sampleAvatars = [
    {
      'title': 'Minimalist Nomad',
      'url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
    },
    {
      'title': 'Urban Explorer',
      'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
    },
    {
      'title': 'Alpine Adventurer',
      'url': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500',
    },
    {
      'title': 'Creative Backpacker',
      'url': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500',
    },
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF131C28),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Upload / Select Profile Photo',
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose a travel avatar or paste a custom image URL (Optional)',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sampleAvatars.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final item = sampleAvatars[index];
                  final isSelected = currentImage == item['url'];
                  return GestureDetector(
                    onTap: () {
                      onSelected(item['url']!);
                      Navigator.pop(ctx);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? primaryColor : Colors.white30,
                              width: isSelected ? 3 : 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              item['url']!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['title']!.split(' ').first,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? primaryColor : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlInputController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Custom Image URL',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'https://...',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: const Color(0xFF1E2A38),
                prefixIcon: const Icon(Icons.link, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () {
                  final text = urlInputController.text.trim();
                  if (text.isNotEmpty) {
                    onSelected(text);
                  }
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B2240),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Custom ticket clipper that cuts semicircular notches top & bottom at splitRatio
class TicketClipper extends CustomClipper<Path> {
  final double splitRatio;
  final double notchRadius;
  final double cornerRadius;

  TicketClipper({
    required this.splitRatio,
    required this.notchRadius,
    required this.cornerRadius,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final splitX = size.width * splitRatio;
    final r = cornerRadius;
    final nr = notchRadius;

    // Start at top-left after corner
    path.moveTo(r, 0);
    // Line to before top notch
    path.lineTo(splitX - nr, 0);
    // Top notch (curve inward down)
    path.arcToPoint(
      Offset(splitX + nr, 0),
      radius: Radius.circular(nr),
      clockwise: false,
    );
    // Line to top-right corner
    path.lineTo(size.width - r, 0);
    path.arcToPoint(Offset(size.width, r), radius: Radius.circular(r));
    // Right edge
    path.lineTo(size.width, size.height - r);
    path.arcToPoint(Offset(size.width - r, size.height), radius: Radius.circular(r));
    // Bottom line to before bottom notch
    path.lineTo(splitX + nr, size.height);
    // Bottom notch (curve inward up)
    path.arcToPoint(
      Offset(splitX - nr, size.height),
      radius: Radius.circular(nr),
      clockwise: false,
    );
    // Bottom line to bottom-left corner
    path.lineTo(r, size.height);
    path.arcToPoint(Offset(0, size.height - r), radius: Radius.circular(r));
    // Left edge
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: Radius.circular(r));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Paints the vertical dashed line for the perforation divider
class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashHeight;
  final double dashSpace;

  DashedLinePainter({
    required this.color,
    this.dashHeight = 5.0,
    this.dashSpace = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5;

    double y = 14.0;
    final endY = size.height - 14.0;
    while (y < endY) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashHeight),
        paint,
      );
      y += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the vertical barcode lines on the boarding pass
class BarcodePainter extends CustomPainter {
  final Color color;
  BarcodePainter({this.color = const Color(0xFF0B2240)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final pattern = [
      3, 1, 1, 2, 4, 1, 2, 1, 3, 2, 1, 4, 1, 2, 3, 1, 1, 2, 4, 1, 2, 1, 3, 2, 1, 4, 2, 1, 3, 1, 2, 4, 1, 2, 3, 1, 2, 4, 1, 3
    ];
    double currentY = 0;
    for (int i = 0; i < pattern.length; i++) {
      final h = pattern[i] * 2.1;
      if (currentY + h > size.height) break;
      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromLTWH(0, currentY, size.width, h), paint);
      }
      currentY += h;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
