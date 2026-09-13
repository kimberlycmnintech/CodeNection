import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import 'home_shell.dart';
import '../widgets/boarding_pass_ticket.dart';
import '../widgets/travel_id_badge.dart';

class SwipeOnboardingScreen extends StatefulWidget {
  final SocialData data;
  const SwipeOnboardingScreen({super.key, required this.data});

  @override
  State<SwipeOnboardingScreen> createState() => _SwipeOnboardingScreenState();
}

class _SwipeOnboardingScreenState extends State<SwipeOnboardingScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  Offset _dragOffset = Offset.zero;
  late AnimationController _springController;
  late Animation<Offset> _springAnimation;
  bool _isAnimating = false;

  final List<Map<String, dynamic>> questions = [
    {
      'topic': 'TRAVEL PACE',
      'title': 'Which travel pace fits you better?',
      'left': {
        'title': 'Relaxed',
        'subtitle': 'Slow mornings, fewer stops.',
        'tags': ['Rest', 'Slow Travel'],
        'footer': 'More time to soak it all in.',
        'color': Color(0xFFF59E0B), // Warm Amber/Gold
        'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      },
      'center': {
        'title': 'Balanced',
        'subtitle': 'A mix of exploration and relaxation.',
        'stamp': 'GOOD\n✈\nJOURNEYS\nAHEAD',
        'tags': ['Culture', 'Nature', 'Local Food'],
        'footer': 'Meaningful experiences, with time to unwind.',
        'image': 'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=800',
      },
      'right': {
        'title': 'Packed Itinerary',
        'subtitle': 'More places, energetic days.',
        'tags': ['Adventure', 'Sightseeing'],
        'footer': 'See more, do more, every day.',
        'color': Color(0xFF2563EB), // Vibrant Blue
        'image': 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=800',
      },
    },
    {
      'topic': 'BUDGET STYLE',
      'title': 'What budget style suits your trip?',
      'left': {
        'title': 'Budget Explorer',
        'subtitle': 'Hostels & savvy street eats.',
        'tags': ['Hostels', 'Street Eats'],
        'footer': 'Maximum memories, minimum spend.',
        'color': Color(0xFF10B981), // Emerald Green
        'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800',
      },
      'center': {
        'title': 'Flexible Comfort',
        'subtitle': 'Boutique stays & quality dining.',
        'stamp': 'SMART\n✈\nTRAVEL\nSTYLE',
        'tags': ['Boutique', 'Cafes', 'Comfort'],
        'footer': 'Comfortable balance without breaking the bank.',
        'image': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
      },
      'right': {
        'title': 'Luxury & Fine Stays',
        'subtitle': '5-star resorts & premium comfort.',
        'tags': ['Resorts', 'Fine Dining'],
        'footer': 'First-class experiences all the way.',
        'color': Color(0xFF8B5CF6), // Royal Purple
        'image': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      },
    },
    {
      'topic': 'DAILY RHYTHM',
      'title': 'What daily rhythm feels right?',
      'left': {
        'title': 'Early Riser',
        'subtitle': 'Catching dawn light & quiet streets.',
        'tags': ['Sunrise', 'Fresh Air'],
        'footer': 'Beat the crowds, feel the morning breeze.',
        'color': Color(0xFFF97316), // Sunrise Orange
        'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      },
      'center': {
        'title': 'Balanced Flow',
        'subtitle': 'Go with the mood each day.',
        'stamp': 'YOUR\n✈\nRHYTHM\nAHEAD',
        'tags': ['Balanced', 'Easyflow', 'Flexible'],
        'footer': 'Adaptable schedule as adventures unfold.',
        'image': 'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=800',
      },
      'right': {
        'title': 'Night Explorer',
        'subtitle': 'Starlit dinners & vibrant evenings.',
        'tags': ['Nightlife', 'Late Dinners'],
        'footer': 'The city comes alive after dark.',
        'color': Color(0xFF6366F1), // Indigo Night
        'image': 'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=800',
      },
    },
    {
      'topic': 'DESTINATION VIBE',
      'title': 'Which destination vibe calls to you?',
      'left': {
        'title': 'Wild Nature',
        'subtitle': 'Alpine trails & scenic lakes.',
        'tags': ['Nature', 'Hiking'],
        'footer': 'Unplug, recharge, surround yourself with green.',
        'color': Color(0xFF059669), // Forest Green
        'image': 'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800',
      },
      'center': {
        'title': 'Coastal & Culture',
        'subtitle': 'Historic towns by seaside waters.',
        'stamp': 'EXPLORE\n✈\nMORE\nPLACES',
        'tags': ['History', 'Seaside', 'Culture'],
        'footer': 'Blend of rich history and coastal breeze.',
        'image': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800',
      },
      'right': {
        'title': 'Vibrant Metropolis',
        'subtitle': 'Neon lights & urban energy.',
        'tags': ['Urban', 'Museums'],
        'footer': 'Art galleries, skyscrapers, and endless street energy.',
        'color': Color(0xFFEC4899), // Neon Pink
        'image': 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=800',
      },
    },
    {
      'topic': 'PLANNING STYLE',
      'title': 'How do you prefer to plan?',
      'left': {
        'title': 'Spontaneous',
        'subtitle': 'Follow wherever curiosity leads.',
        'tags': ['Spontaneous', 'Free Spirit'],
        'footer': 'No strict plans, just pure discovery.',
        'color': Color(0xFFEAB308), // Spontaneous Gold
        'image': 'https://images.unsplash.com/photo-1527631746610-bca00a040d60?w=800',
      },
      'center': {
        'title': 'Semi-Structured',
        'subtitle': 'Anchor points with room to wander.',
        'stamp': 'PERFECT\n✈\nMATCH\nFOUND',
        'tags': ['Curated', 'Flexible', 'Routes'],
        'footer': 'Must-see highlights with room to wander.',
        'image': 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800',
      },
      'right': {
        'title': 'Organized',
        'subtitle': 'Curated timelines & routes.',
        'tags': ['Itinerary', 'Reserved'],
        'footer': 'Seamless efficiency with zero missed details.',
        'color': Color(0xFF0284C7), // Sky Blue
        'image': 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800',
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (_isAnimating) return;
    _springController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating) return;
    final velocity = details.velocity.pixelsPerSecond.dx;

    if (_dragOffset.dx < -90 || velocity < -400) {
      // Swiped Left
      final q = questions[currentIndex];
      final leftTitle = q['left']['title'] as String;
      _swipeOutAndAdvance(leftTitle);
    } else if (_dragOffset.dx > 90 || velocity > 400) {
      // Swiped Right
      final q = questions[currentIndex];
      final rightTitle = q['right']['title'] as String;
      _swipeOutAndAdvance(rightTitle);
    } else {
      // Spring back to center
      _springAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _springController, curve: Curves.easeOutBack),
      )..addListener(() {
          setState(() {
            _dragOffset = _springAnimation.value;
          });
        });
      _springController.forward(from: 0.0);
    }
  }

  void _swipeOutAndAdvance(String choice) {
    _isAnimating = true;
    if (currentIndex == 0) {
      widget.data.myProfile.travelPace = choice;
    } else if (currentIndex == 1) {
      widget.data.myProfile.budgetStyle = choice;
    } else if (currentIndex == 2) {
      widget.data.myProfile.dailyRhythm = choice;
    } else if (currentIndex == 3) {
      widget.data.myProfile.destinationVibe = choice;
    } else if (currentIndex == 4) {
      widget.data.myProfile.planningStyle = choice;
    }

    setState(() {
      _dragOffset = Offset.zero;
      _isAnimating = false;
      if (currentIndex < questions.length - 1) {
        currentIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PassengerDetailsFormScreen(data: widget.data),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final screenWidth = size.width;
    final isPhone = screenWidth < 768;

    final q = questions[currentIndex];
    final leftData = q['left'] as Map<String, dynamic>;
    final centerData = q['center'] as Map<String, dynamic>;
    final rightData = q['right'] as Map<String, dynamic>;

    final leftColor = leftData['color'] as Color;
    final rightColor = rightData['color'] as Color;

    // Drag calculations
    final dragDx = _dragOffset.dx;
    final dragRatio = (dragDx / 180.0).clamp(-1.0, 1.0);
    final leftIntensity = (-dragDx / 140.0).clamp(0.0, 1.0);
    final rightIntensity = (dragDx / 140.0).clamp(0.0, 1.0);

    return Scaffold(
      body: Stack(
        children: [
          // Background Base & Dynamic Drag Color Glow Overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF4F8FC),
                    Color(0xFFE8F1FA),
                    Color(0xFFDFECF8),
                  ],
                ),
              ),
            ),
          ),

          // Left Drag Color Overlay Glow (When dragging left towards Left Choice)
          if (leftIntensity > 0)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 50),
                opacity: leftIntensity * 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        leftColor.withValues(alpha: 0.45),
                        leftColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Right Drag Color Overlay Glow (When dragging right towards Right Choice)
          if (rightIntensity > 0)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 50),
                opacity: rightIntensity * 0.75,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        rightColor.withValues(alpha: 0.45),
                        rightColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                // ==========================================
                // TOP HEADER BAR (Logo, Progress Pill, Preferences)
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Brand logo
                      Image.asset(
                        'assets/logo.png',
                        height: 32,
                        fit: BoxFit.contain,
                      ),

                      // Center Question Pill + Progress Bar
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'Question ${currentIndex + 1} of ${questions.length}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF475569),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 80,
                            height: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: (currentIndex + 1) / questions.length,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Right Preferences button
                      Row(
                        children: [
                          const Icon(
                            Icons.tune_rounded,
                            size: 16,
                            color: Color(0xFF475569),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Preferences',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // ==========================================
                // HERO QUESTION TITLE & SUBTITLE
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        q['title'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: isPhone ? 28 : 34,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.6,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Drag the card left or right to choose your style.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ==========================================
                // SINGLE INTERACTIVE DRAGGABLE CENTER CARD
                // ==========================================
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final containerWidth = constraints.maxWidth;
                      final cardWidth = isPhone
                          ? (containerWidth * 0.72).clamp(240.0, 310.0)
                          : (containerWidth * 0.35).clamp(280.0, 360.0);

                      final rotation = (dragRatio * 0.16);

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Left Option Label Accent (Reveals on drag left)
                          Positioned(
                            left: isPhone ? 16 : 40,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 50),
                              opacity: leftIntensity,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: leftColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: leftColor.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      leftData['title'],
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Right Option Label Accent (Reveals on drag right)
                          Positioned(
                            right: isPhone ? 16 : 40,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 50),
                              opacity: rightIntensity,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: rightColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: rightColor.withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      rightData['title'],
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Single Main Center Card with Drag Transform
                          GestureDetector(
                            onPanStart: _onPanStart,
                            onPanUpdate: _onPanUpdate,
                            onPanEnd: _onPanEnd,
                            child: Transform.translate(
                              offset: _dragOffset,
                              child: Transform.rotate(
                                angle: rotation,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.grab,
                                  child: Stack(
                                    children: [
                                      _buildOptionCard(
                                        topic: q['topic'],
                                        stepText: '${currentIndex + 1} / ${questions.length}',
                                        title: centerData['title'],
                                        subtitle: centerData['subtitle'],
                                        imageUrl: centerData['image'],
                                        stampText: centerData['stamp'],
                                        tags: List<String>.from(centerData['tags']),
                                        footer: centerData['footer'],
                                        cardWidth: cardWidth,
                                        activeGlowColor: leftIntensity > 0
                                            ? leftColor.withValues(alpha: leftIntensity * 0.5)
                                            : (rightIntensity > 0
                                                ? rightColor.withValues(alpha: rightIntensity * 0.5)
                                                : null),
                                      ),

                                      // Left choice overlay stamp inside card
                                      if (leftIntensity > 0.15)
                                        Positioned(
                                          top: 24,
                                          right: 24,
                                          child: Opacity(
                                            opacity: leftIntensity,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: leftColor,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '← ${leftData['title']}',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      // Right choice overlay stamp inside card
                                      if (rightIntensity > 0.15)
                                        Positioned(
                                          top: 24,
                                          left: 24,
                                          child: Opacity(
                                            opacity: rightIntensity,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: rightColor,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${rightData['title']} →',
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Quick choice tap row (for ease of selection on desktop/mobile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left choice button
                      InkWell(
                        onTap: () => _swipeOutAndAdvance(leftData['title']),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: leftColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: leftColor.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_rounded, size: 15, color: leftColor),
                              const SizedBox(width: 6),
                              Text(
                                leftData['title'],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: leftColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Right choice button
                      InkWell(
                        onTap: () => _swipeOutAndAdvance(rightData['title']),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: rightColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: rightColor.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                rightData['title'],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: rightColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, size: 15, color: rightColor),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ==========================================
                // BOTTOM PAGE INDICATOR DOTS
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    questions.length,
                    (index) => Container(
                      width: index == currentIndex ? 10 : 7,
                      height: index == currentIndex ? 10 : 7,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFCBD5E1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Bottom Drag Indicator Bar
                Container(
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the single Option Card matching the reference mockup
  Widget _buildOptionCard({
    required String topic,
    required String stepText,
    required String title,
    required String subtitle,
    required String imageUrl,
    String? stampText,
    required List<String> tags,
    required String footer,
    required double cardWidth,
    Color? activeGlowColor,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 50),
      width: cardWidth,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: activeGlowColor ?? const Color(0xFF0F172A).withValues(alpha: 0.12),
            blurRadius: activeGlowColor != null ? 30 : 22,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: activeGlowColor ?? Colors.white,
          width: activeGlowColor != null ? 2.5 : 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Card Metadata Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    topic,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  Text(
                    stepText,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            // Card Headline Title & Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF0F172A),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: const Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Scenic Travel Photo with Overlay Stamp
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      imageUrl,
                      height: 145,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 145,
                        color: const Color(0xFFCBD5E1),
                        child: const Icon(Icons.landscape, color: Colors.white),
                      ),
                    ),
                  ),

                  // Circular Stamp Badge Overlay
                  if (stampText != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.85),
                          border: Border.all(
                            color: const Color(0xFF475569).withValues(alpha: 0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'GOOD',
                                style: GoogleFonts.inter(
                                  fontSize: 6.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              const Icon(
                                Icons.flight_rounded,
                                size: 10,
                                color: Color(0xFF334155),
                              ),
                              Text(
                                'JOURNEYS',
                                style: GoogleFonts.inter(
                                  fontSize: 6.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF334155),
                                ),
                              ),
                              Text(
                                'AHEAD',
                                style: GoogleFonts.inter(
                                  fontSize: 5.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF334155),
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

            const SizedBox(height: 12),

            // Tag Pills Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: tags.map((tag) {
                  IconData tagIcon = Icons.auto_awesome_rounded;
                  if (tag.contains('Culture')) tagIcon = Icons.eco_outlined;
                  if (tag.contains('Nature')) tagIcon = Icons.landscape_outlined;
                  if (tag.contains('Food') || tag.contains('Eats')) tagIcon = Icons.restaurant_rounded;
                  if (tag.contains('Rest')) tagIcon = Icons.king_bed_outlined;
                  if (tag.contains('Adventure')) tagIcon = Icons.hiking_rounded;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tagIcon, size: 11, color: const Color(0xFF475569)),
                        const SizedBox(width: 4),
                        Text(
                          tag,
                          style: GoogleFonts.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Card Footer Description
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(
                footer,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen 2 of Onboarding: Form ONLY (no boarding pass).
/// Displayed after user finishes swiping travel preferences.
class PassengerDetailsFormScreen extends StatefulWidget {
  final SocialData data;
  final VoidCallback? onComplete;
  const PassengerDetailsFormScreen({super.key, required this.data, this.onComplete});

  @override
  State<PassengerDetailsFormScreen> createState() => _PassengerDetailsFormScreenState();
}

class _PassengerDetailsFormScreenState extends State<PassengerDetailsFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _igController;
  late TextEditingController _xController;

  String _profileImage =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500';

  @override
  void initState() {
    super.initState();
    final profile = widget.data.myProfile;
    _nameController = TextEditingController(
      text: profile.name.isNotEmpty && profile.name != 'Harshall D.P'
          ? profile.name
          : '',
    );
    _ageController = TextEditingController(
      text: profile.age > 0 ? profile.age.toString() : '',
    );
    _igController = TextEditingController(
      text: profile.instagram ?? '',
    );
    _xController = TextEditingController(
      text: profile.xHandle ?? '',
    );

    if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
      _profileImage = profile.avatarUrl!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _igController.dispose();
    _xController.dispose();
    super.dispose();
  }

  void _openAvatarPicker() {
    showAvatarPickerSheet(
      context: context,
      currentImage: _profileImage,
      onSelected: (url) {
        setState(() {
          _profileImage = url;
        });
      },
    );
  }

  void _onGeneratePass() {
    final name = _nameController.text.trim();
    final ageStr = _ageController.text.trim();

    if (name.isEmpty || ageStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in both Name and Age to generate your travel pass.',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF0F172A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final age = int.tryParse(ageStr) ?? 24;
    final ig = _igController.text.trim();
    final x = _xController.text.trim();

    widget.data.myProfile.name = name;
    widget.data.myProfile.age = age;
    widget.data.myProfile.instagram = ig.isNotEmpty ? ig : null;
    widget.data.myProfile.xHandle = x.isNotEmpty ? x : null;
    widget.data.myProfile.avatarUrl = _profileImage;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PersonalPassScreen(
          data: widget.data,
          onComplete: widget.onComplete,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PASSENGER DETAILS',
          style: GoogleFonts.inter(
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Pill Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF0284C7)),
                    const SizedBox(width: 6),
                    Text(
                      'CREDENTIAL REGISTRATION',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0284C7),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Personal Details',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Please enter your passenger details below. Once submitted, your official 3D TripNest Travel Pass will be generated.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),

              // Form White Card Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo Selection Row
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _openAvatarPicker,
                          child: Stack(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFF0EA5E9),
                                    width: 2.2,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(_profileImage),
                                    fit: BoxFit.cover,
                                    onError: (_, _) {},
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0F172A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile Picture',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0F172A),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Tap to choose travel avatar or paste image URL',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _openAvatarPicker,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F172A),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Change',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Passenger Name
                    TextFormField(
                      controller: _nameController,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Passenger Name *',
                        hintText: 'e.g. Jessie Mesa',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: Color(0xFF0EA5E9),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Age Field
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Age *',
                        hintText: 'e.g. 24',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.cake_outlined,
                          color: Color(0xFF0EA5E9),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Instagram Field
                    TextFormField(
                      controller: _igController,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Instagram Handle (Optional)',
                        hintText: '@username',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF0EA5E9),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // X Field
                    TextFormField(
                      controller: _xController,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: 'X (Twitter) Handle (Optional)',
                        hintText: '@username',
                        hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                        labelStyle: GoogleFonts.inter(color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.alternate_email_rounded,
                          color: Color(0xFF0EA5E9),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Generate Travel Pass Dark Editorial Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _onGeneratePass,
                        icon: const Icon(
                          Icons.badge_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        label: Text(
                          'Generate Travel Pass',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.3),
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
    );
  }
}

/// Screen 3 of Onboarding: Displays the Personal Details in the
/// authentic 3D interactive clear plastic lanyard badge holder!
class PersonalPassScreen extends StatefulWidget {
  final SocialData data;
  final VoidCallback? onComplete;

  const PersonalPassScreen({
    super.key,
    required this.data,
    this.onComplete,
  });

  @override
  State<PersonalPassScreen> createState() => _PersonalPassScreenState();
}

class _PersonalPassScreenState extends State<PersonalPassScreen> {
  final GlobalKey<TravelIdBadgeState> _badgeKey = GlobalKey<TravelIdBadgeState>();

  void _enterApp(BuildContext context) {
    if (widget.onComplete != null) {
      widget.onComplete!();
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeShell(data: widget.data),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.data.myProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0EA5E9).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'YOUR TRAVEL CREDENTIALS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0284C7),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Official Travel Pass',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),

              // ==========================================
              // THE 3D TRAVEL ID BADGE
              // ==========================================
              TravelIdBadge(
                key: _badgeKey,
                profile: profile,
                displayName: profile.name,
                displayAge: profile.age.toString(),
                displayInstagram: profile.instagram,
                displayX: profile.xHandle,
                profileImage: profile.avatarUrl,
                animateFlipOnMount: true,
                enableTapToFlip: true,
              ),

              const SizedBox(height: 14),

              // 3D Interactive Controls Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      _badgeKey.currentState?.flip180();
                    },
                    icon: const Icon(Icons.flip_camera_android_rounded, size: 16, color: Color(0xFF0F172A)),
                    label: Text(
                      'Flip 180°',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      _badgeKey.currentState?.resetView();
                    },
                    icon: const Icon(Icons.center_focus_strong_rounded, size: 16, color: Color(0xFF0F172A)),
                    label: Text(
                      'Center View',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Gesture Tip Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.screen_rotation_rounded, size: 16, color: Color(0xFF0EA5E9)),
                    const SizedBox(width: 8),
                    Text(
                      'Drag badge in 3D • Double-tap to flip',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Enter App Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: () => _enterApp(context),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Enter TripNest',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.3),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Edit Details Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Edit Details',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Backwards compatibility alias for BoardingPassScreen
class BoardingPassScreen extends StatelessWidget {
  final SocialData data;
  final VoidCallback? onComplete;
  const BoardingPassScreen({super.key, required this.data, this.onComplete});

  @override
  Widget build(BuildContext context) {
    return PassengerDetailsFormScreen(data: data, onComplete: onComplete);
  }
}

/// Alias for backwards compatibility
typedef TravelCardScreen = BoardingPassScreen;
