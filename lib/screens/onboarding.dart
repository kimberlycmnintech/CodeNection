import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
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
    with TickerProviderStateMixin {
  int currentIndex = 0;
  Offset _dragOffset = Offset.zero;

  // Intro transition animation & auto-dismiss timer
  Timer? _autoDismissTimer;
  late AnimationController _introDismissController;
  late Animation<double> _promptFadeAnimation;
  late Animation<Offset> _promptSlideUpAnimation;
  bool _introFinished = false;
  bool _isDismissingIntro = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  late AnimationController _springController;
  late Animation<Offset> _springAnimation;

  bool _isAnimating = false;

  final List<Map<String, dynamic>> topics = [
    {
      'topicLine1': 'Travel',
      'topicLine2': 'Pace',
      'leftTitle': 'Relaxed',
      'leftDescription': 'Slow mornings, coffee strolls, and peaceful wanderings',
      'rightTitle': 'Packed Itinerary',
      'rightDescription': 'Fast-paced, full schedules, and seeing every landmark',
      'leftImage':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      'rightImage':
          'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=800',
    },
    {
      'topicLine1': 'Budget',
      'topicLine2': 'Style',
      'leftTitle': 'Budget Explorer',
      'leftDescription': 'Hostels, local street eats, and savvy spending',
      'rightTitle': 'Comfort & Luxury',
      'rightDescription': 'Boutique stays, fine dining, and seamless comfort',
      'leftImage':
          'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800',
      'rightImage':
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800',
    },
    {
      'topicLine1': 'Daily',
      'topicLine2': 'Rhythm',
      'leftTitle': 'Early Riser',
      'leftDescription': 'Catching dawn light, fresh mornings, and beat the crowds',
      'rightTitle': 'Late Starter',
      'rightDescription': 'Slow easy mornings, vibrant dinners, and night strolls',
      'leftImage':
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800',
      'rightImage':
          'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=800',
    },
    {
      'topicLine1': 'Destination',
      'topicLine2': 'Vibe',
      'leftTitle': 'Wild Nature',
      'leftDescription': 'Fresh mountain air, alpine trails, and scenic serenity',
      'rightTitle': 'Vibrant City',
      'rightDescription': 'Skyscrapers, energetic avenues, art, and nightlife',
      'leftImage':
          'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800',
      'rightImage':
          'https://images.unsplash.com/photo-1519501025264-65ba15a82390?w=800',
    },
    {
      'topicLine1': 'Planning',
      'topicLine2': 'Style',
      'leftTitle': 'Spontaneous',
      'leftDescription': 'Go with the flow and follow wherever curiosity leads',
      'rightTitle': 'Organized',
      'rightDescription': 'Curated timelines, reserved tickets, and structured routes',
      'leftImage':
          'https://images.unsplash.com/photo-1527631746610-bca00a040d60?w=800',
      'rightImage':
          'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Controller to dismiss the centered prompt
    _introDismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _promptFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _introDismissController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
      ),
    );

    _promptSlideUpAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -1.3),
    ).animate(
      CurvedAnimation(
        parent: _introDismissController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Automatically dismiss the prompt if user doesn't click for 4.5 seconds
    _autoDismissTimer = Timer(const Duration(milliseconds: 4500), () {
      if (mounted && !_introFinished) {
        _dismissIntro();
      }
    });

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _introDismissController.dispose();
    _slideController.dispose();
    _springController.dispose();
    super.dispose();
  }

  void _dismissIntro() {
    if (_isDismissingIntro || _introFinished) return;
    _isDismissingIntro = true;
    _autoDismissTimer?.cancel();
    _introDismissController.forward().then((_) {
      if (mounted) {
        setState(() {
          _introFinished = true;
        });
      }
    });
    setState(() {});
  }

  // Hover tracking for 3D card tilt and background transition
  double _hoverX = 0.0; // -1.0 (left) to 1.0 (right)
  double _hoverY = 0.0; // -1.0 (top) to 1.0 (bottom)
  bool _isHoveringLeft = false;
  bool _isHoveringRight = false;
  bool _showBottomDrawer = false;

  void _onHoverChanged(PointerEvent event, Size size) {
    if (_isAnimating || !_introFinished) return;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final normX = ((event.position.dx - centerX) / centerX).clamp(-1.0, 1.0);
    final normY = ((event.position.dy - centerY) / centerY).clamp(-1.0, 1.0);

    setState(() {
      _hoverX = normX;
      _hoverY = normY;
      _isHoveringLeft = normX < -0.15;
      _isHoveringRight = normX > 0.15;
    });
  }

  void _onHoverExit() {
    setState(() {
      _hoverX = 0.0;
      _hoverY = 0.0;
      _isHoveringLeft = false;
      _isHoveringRight = false;
    });
  }

  void _selectChoice({required bool isLeft}) {
    if (_isAnimating || !_introFinished) return;
    _swipeCardOut(isLeft: isLeft);
  }

  void _onPanStart(DragStartDetails details) {
    if (_isAnimating || !_introFinished) return;
    _springController.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating || !_introFinished) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isAnimating || !_introFinished) return;
    final velocity = details.velocity.pixelsPerSecond.dx;

    if (_dragOffset.dx > 80 || velocity > 500) {
      _swipeCardOut(isLeft: false);
    } else if (_dragOffset.dx < -80 || velocity < -500) {
      _swipeCardOut(isLeft: true);
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

  void _swipeCardOut({required bool isLeft}) {
    if (_isAnimating) return;
    _isAnimating = true;

    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = isLeft ? -screenWidth * 1.4 : screenWidth * 1.4;
    final targetOffset = Offset(targetX, _dragOffset.dy * 1.2);

    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: targetOffset,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOutCubic),
    )..addListener(() {
        setState(() {
          _dragOffset = _slideAnimation.value;
        });
      });

    _slideController.forward(from: 0.0).then((_) {
      _handleChoice(
        isLeft
            ? topics[currentIndex]['leftTitle']!
            : topics[currentIndex]['rightTitle']!,
      );
    });
  }

  String _getSavedChoice(int index) {
    switch (index) {
      case 0:
        return widget.data.myProfile.travelPace;
      case 1:
        return widget.data.myProfile.budgetStyle;
      case 2:
        return widget.data.myProfile.dailyRhythm;
      case 3:
        return widget.data.myProfile.destinationVibe;
      case 4:
        return widget.data.myProfile.planningStyle;
      default:
        return '';
    }
  }

  void _handleChoice(String choice) {
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

    _slideController.reset();
    _dragOffset = Offset.zero;
    _isAnimating = false;

    if (currentIndex < topics.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PassengerDetailsFormScreen(data: widget.data),
        ),
      );
    }
  }

  void _jumpToTopic(int index) {
    if (_isAnimating || index == currentIndex) return;
    setState(() {
      currentIndex = index;
      _dragOffset = Offset.zero;
      _slideController.reset();
      _showBottomDrawer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final current = topics[currentIndex];

    // Determine if we are on a phone/narrow viewport
    final isPhone = screenWidth < 768;

    // Card dimensions adapted from Chrome showcase with phone responsiveness
    final cardWidth = isPhone
        ? (screenWidth * 0.74).clamp(230.0, 300.0)
        : (screenWidth * 0.40).clamp(240.0, 360.0);
    final cardHeight = isPhone
        ? (screenHeight * 0.48).clamp(320.0, 400.0)
        : (screenHeight * 0.60).clamp(380.0, 520.0);

    // Dynamic tilt calculation
    // When hovering left (negative _hoverX), card tilts towards left (negative rotateY)
    final hoverTiltY = _hoverX * 0.42; 
    final hoverTiltX = -_hoverY * 0.15;
    final hoverTiltZ = _hoverX * 0.08;

    // Drag contribution
    final dragTiltY = (_dragOffset.dx / screenWidth) * 0.45;
    final totalTiltY = hoverTiltY + dragTiltY;

    // Yellow backdrop sweep intensity when leaning left
    final leftLeanFactor = (-_hoverX).clamp(0.0, 1.0);
    final rightLeanFactor = (_hoverX).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF2563EB), // Chrome showcase vibrant blue
      body: MouseRegion(
        onHover: (e) => _onHoverChanged(e, size),
        onExit: (_) => _onHoverExit(),
        child: Stack(
          children: [
            // ==========================================
            // 1. DYNAMIC CHROME SHOWCASE BACKGROUND
            // (Blue backdrop with yellow semi-circle accent when leaning left)
            // ==========================================
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                color: const Color(0xFF2563EB), // Primary Showcase Blue
                child: Stack(
                  children: [
                    // Dynamic Golden/Amber Crescent that emerges on the left when hovering/leaning left
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      left: -screenWidth * 0.25 + (leftLeanFactor * screenWidth * 0.12),
                      top: screenHeight * 0.05,
                      width: screenWidth * 0.55,
                      height: screenHeight * 0.90,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: (leftLeanFactor * 0.95).clamp(0.0, 1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFBBF24), // Vibrant gold accent from showcase
                          ),
                        ),
                      ),
                    ),

                    // Subtle cyan/indigo accent for right lean
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      right: -screenWidth * 0.25 + (rightLeanFactor * screenWidth * 0.10),
                      top: screenHeight * 0.08,
                      width: screenWidth * 0.50,
                      height: screenHeight * 0.85,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: (rightLeanFactor * 0.70).clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top Header navigation matching Chrome Showcase ("About" ... "The Web Can Do What!?" ... "Share")
            Positioned(
              top: mediaQuery.padding.top + 16,
              left: isPhone ? 18 : 32,
              right: isPhone ? 18 : 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TripNest',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      'Question ${currentIndex + 1} of ${topics.length}',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: isPhone ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Text(
                    'Preferences',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: isPhone ? 13 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 2. INTERACTIVE FOREGROUND LAYER
            // ==========================================
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _introDismissController,
                builder: (context, child) {
                  final opacity = _introFinished
                      ? 1.0
                      : _introDismissController.value.clamp(0.0, 1.0);
                  return Opacity(
                    opacity: opacity,
                    child: IgnorePointer(
                      ignoring: !_introFinished && _introDismissController.value < 0.75,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // --- LEFT OPTION LABEL (Shown on desktop/tablet viewports) ---
                    if (!isPhone)
                      Positioned(
                        left: 48,
                        top: screenHeight * 0.40,
                        child: GestureDetector(
                          onTap: () => _selectChoice(isLeft: true),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() {
                              _hoverX = -0.7;
                              _isHoveringLeft = true;
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              transform: Matrix4.translationValues(
                                _isHoveringLeft ? 8.0 : 0.0,
                                0.0,
                                0.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: _isHoveringLeft
                                            ? const Color(0xFF1E293B)
                                            : Colors.white.withValues(alpha: 0.7),
                                        size: 26,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        current['leftTitle']!,
                                        style: GoogleFonts.outfit(
                                          fontSize: 34,
                                          fontWeight: FontWeight.w800,
                                          color: _isHoveringLeft
                                              ? const Color(0xFF0F172A)
                                              : Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 140,
                                    height: 3,
                                    color: _isHoveringLeft
                                        ? const Color(0xFF0F172A)
                                        : Colors.white.withValues(alpha: 0.4),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      current['leftDescription']!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: _isHoveringLeft
                                            ? const Color(0xFF1E293B)
                                            : Colors.white.withValues(alpha: 0.85),
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // --- RIGHT OPTION LABEL (Shown on desktop/tablet viewports) ---
                    if (!isPhone)
                      Positioned(
                        right: 48,
                        top: screenHeight * 0.40,
                        child: GestureDetector(
                          onTap: () => _selectChoice(isLeft: false),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            onEnter: (_) => setState(() {
                              _hoverX = 0.7;
                              _isHoveringRight = true;
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              transform: Matrix4.translationValues(
                                _isHoveringRight ? -8.0 : 0.0,
                                0.0,
                                0.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        current['rightTitle']!,
                                        style: GoogleFonts.outfit(
                                          fontSize: 34,
                                          fontWeight: FontWeight.w800,
                                          color: _isHoveringRight
                                              ? Colors.white
                                              : Colors.white.withValues(alpha: 0.85),
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: _isHoveringRight
                                            ? Colors.white
                                            : Colors.white.withValues(alpha: 0.7),
                                        size: 26,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 140,
                                    height: 3,
                                    color: _isHoveringRight
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.4),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      current['rightDescription']!,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: _isHoveringRight
                                            ? Colors.white
                                            : Colors.white.withValues(alpha: 0.85),
                                        fontWeight: FontWeight.w500,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    // --- CENTRAL 3D TILT CARD DECK ---
                    Center(
                      child: SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            // Card underneath in stack (peeking background card)
                            if (currentIndex + 1 < topics.length)
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.0012)
                                  ..multiply(Matrix4.translationValues(12.0, 8.0, -40.0))
                                  ..rotateZ(0.04),
                                child: _buildChromeDeckCard(
                                  topicLine1: topics[currentIndex + 1]['topicLine1']!,
                                  topicLine2: topics[currentIndex + 1]['topicLine2']!,
                                  leftTitle: topics[currentIndex + 1]['leftTitle']!,
                                  rightTitle: topics[currentIndex + 1]['rightTitle']!,
                                  imageUrl: topics[currentIndex + 1]['leftImage']!,
                                  isTopCard: false,
                                ),
                              ),

                            // Top Active Card with 3D Tilt Matrix
                            Transform.translate(
                              offset: _dragOffset,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.0018)
                                  ..rotateX(hoverTiltX)
                                  ..rotateY(totalTiltY)
                                  ..rotateZ(hoverTiltZ),
                                child: GestureDetector(
                                  onPanStart: _onPanStart,
                                  onPanUpdate: _onPanUpdate,
                                  onPanEnd: _onPanEnd,
                                  onTapUp: (details) {
                                    // When user clicks the card:
                                    // If click is on left half -> choose left
                                    // If click is on right half -> choose right
                                    final clickX = details.localPosition.dx;
                                    if (clickX < cardWidth / 2) {
                                      _selectChoice(isLeft: true);
                                    } else {
                                      _selectChoice(isLeft: false);
                                    }
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        _buildChromeDeckCard(
                                          topicLine1: current['topicLine1']!,
                                          topicLine2: current['topicLine2']!,
                                          leftTitle: current['leftTitle']!,
                                          rightTitle: current['rightTitle']!,
                                          imageUrl: _isHoveringRight
                                              ? current['rightImage']!
                                              : current['leftImage']!,
                                          isTopCard: true,
                                        ),

                                        // Subtle Hover Direction Arrow Overlay
                                        if (_isHoveringLeft)
                                          Positioned(
                                            left: 16,
                                            bottom: 16,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0F172A),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Click for ${current['leftTitle']}',
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                        if (_isHoveringRight)
                                          Positioned(
                                            right: 16,
                                            bottom: 16,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0F172A),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Click for ${current['rightTitle']}',
                                                    style: GoogleFonts.outfit(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ],
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
                        ),
                      ),
                    ),


                    // Left & Right quick tap buttons for tests / touch devices
                    Positioned(
                      bottom: mediaQuery.padding.bottom + 84,
                      left: 16,
                      right: 16,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () => _selectChoice(isLeft: true),
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isPhone ? 12 : 16,
                                    vertical: isPhone ? 8 : 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPhone
                                        ? const Color(0xFF0F172A)
                                        : Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isPhone
                                          ? const Color(0xFFFBBF24)
                                          : Colors.white.withValues(alpha: 0.3),
                                      width: isPhone ? 1.5 : 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.arrow_back_rounded,
                                          color: Colors.white, size: 18),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          current['leftTitle']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: isPhone ? 12 : 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: isPhone ? 12 : 20),
                            Flexible(
                              child: InkWell(
                                onTap: () => _selectChoice(isLeft: false),
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isPhone ? 12 : 16,
                                    vertical: isPhone ? 8 : 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isPhone
                                        ? const Color(0xFF0F172A)
                                        : Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isPhone
                                          ? const Color(0xFF38BDF8)
                                          : Colors.white.withValues(alpha: 0.3),
                                      width: isPhone ? 1.5 : 1.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          current['rightTitle']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: isPhone ? 12 : 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.arrow_forward_rounded,
                                          color: Colors.white, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ==========================================
                    // 3. BOTTOM SELECTION PILL (CHROME SHOWCASE STYLE)
                    // Shows current status & expands to re-select previous
                    // ==========================================
                    Positioned(
                      bottom: mediaQuery.padding.bottom + 22,
                      child: _buildBottomSelectionBar(),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 4. CENTERED PROMPT
            // Disappears on user click or after 4.5s of no response
            // ==========================================
            if (!_introFinished)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _dismissIntro,
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.65 * (1.0 - _introDismissController.value),
                    ),
                    alignment: Alignment.center,
                    child: SlideTransition(
                      position: _promptSlideUpAnimation,
                      child: FadeTransition(
                        opacity: _promptFadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 54,
                                height: 5,
                                margin: const EdgeInsets.only(bottom: 24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFBBF24),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              Text(
                                '“What kind of journey feels right for you?”',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.calistoga(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.25,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 18,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Choose the preferences that make your trip uniquely yours.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  color: Colors.white.withValues(alpha: 0.95),
                                  height: 1.45,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 14,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the Chrome for Developers style white card with window mockup
  Widget _buildChromeDeckCard({
    required String topicLine1,
    required String topicLine2,
    required String leftTitle,
    required String rightTitle,
    required String imageUrl,
    required bool isTopCard,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Crisp clean off-white
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isTopCard ? 0.28 : 0.15),
            blurRadius: isTopCard ? 36 : 18,
            offset: Offset(0, isTopCard ? 18 : 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            // Card Top Pill Tag ("Introduction" / Topic)
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 20, right: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8), // Light blue badge
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$topicLine1 $topicLine2',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),

            // Abstract colorful shape background behind mockup (as seen in screenshots)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background geometric splashes (Google Chrome showcase style)
                    Positioned(
                      top: 0,
                      right: 10,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34A853).withValues(alpha: 0.85), // Green
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 10,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBBC05).withValues(alpha: 0.85), // Yellow
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 15,
                      child: Container(
                        width: 100,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA4335).withValues(alpha: 0.9), // Red
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 10,
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4285F4).withValues(alpha: 0.85), // Blue
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    // Central White Browser Window Mockup (Chrome showcase core motif)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Browser dots (red, yellow, green)
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF59E0B),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Big bold title
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                topicLine1,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                  height: 1.1,
                                ),
                              ),
                              Text(
                                topicLine2,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Subtitle options
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Text(
                                  '◀ $leftTitle',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              const Text(
                                '•',
                                style: TextStyle(color: Color(0xFF94A3B8)),
                              ),
                              Flexible(
                                child: Text(
                                  '$rightTitle ▶',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the bottom selection pill dock with previous choices
  Widget _buildBottomSelectionBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Drawer of all selections if opened
        if (_showBottomDrawer)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 32,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(topics.length, (idx) {
                  final topic = topics[idx];
                  final saved = _getSavedChoice(idx);
                  final isCurrent = idx == currentIndex;
                  final isAnswered = saved.isNotEmpty;

                  return GestureDetector(
                    onTap: () => _jumpToTopic(idx),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? const Color(0xFF38BDF8)
                            : (isAnswered
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.white.withValues(alpha: 0.05)),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${topic['topicLine1']} ${topic['topicLine2']}',
                            style: GoogleFonts.outfit(
                              color: isCurrent ? Colors.white : Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isAnswered ? saved : 'Pending',
                            style: GoogleFonts.outfit(
                              color: isCurrent
                                  ? Colors.white
                                  : (isAnswered
                                      ? const Color(0xFF34D399)
                                      : Colors.white38),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

        // Chrome showcase pill button (capsule with toggle / grid icon)
        GestureDetector(
          onTap: () {
            setState(() {
              _showBottomDrawer = !_showBottomDrawer;
            });
          },
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A), // Dark pill container
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle pill dot
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 4-dot grid icon (as in Chrome showcase bottom pill)
                Icon(
                  _showBottomDrawer
                      ? Icons.expand_more_rounded
                      : Icons.grid_view_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Selections (${currentIndex + 1}/${topics.length})',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
          content: const Text(
            'Please fill in both Name and Age to generate your travel pass.',
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      backgroundColor: const Color(0xFF0C141F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'PASSENGER DETAILS',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.badge_outlined, size: 14, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'CREDENTIAL REGISTRATION',
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Personal Details',
                style: GoogleFonts.cinzel(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Please enter your required passenger details below. Once submitted, your official TripNest Travel Pass will be generated.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131E2B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _openAvatarPicker,
                          child: Stack(
                            children: [
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: primaryColor,
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
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 13,
                                    color: Color(0xFF0B2240),
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
                              const Text(
                                'Profile Picture (Optional)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Tap to choose travel avatar or URL',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _openAvatarPicker,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            side: const BorderSide(color: primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name of Passenger (Required)',
                        hintText: 'e.g. Jessie Mesa',
                        hintStyle: const TextStyle(color: Colors.white30),
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: primaryColor,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E2A38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Age (Required)',
                        hintText: 'e.g. 24',
                        hintStyle: const TextStyle(color: Colors.white30),
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.cake_outlined,
                          color: primaryColor,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E2A38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _igController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Instagram Link / Handle (Optional)',
                        hintText: '@username',
                        hintStyle: const TextStyle(color: Colors.white30),
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.camera_alt_outlined,
                          color: primaryColor,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E2A38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _xController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'X (Twitter) Link / Handle (Optional)',
                        hintText: '@username',
                        hintStyle: const TextStyle(color: Colors.white30),
                        labelStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.alternate_email_rounded,
                          color: primaryColor,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E2A38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton.icon(
                        onPressed: _onGeneratePass,
                        icon: const Icon(
                          Icons.badge_outlined,
                          color: Color(0xFF0B2240),
                          size: 22,
                        ),
                        label: const Text(
                          'Generate Travel Pass',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B2240),
                          ),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
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
/// authentic clear plastic lanyard badge holder with 3D flip animation!
class PersonalPassScreen extends StatelessWidget {
  final SocialData data;
  final VoidCallback? onComplete;

  const PersonalPassScreen({
    super.key,
    required this.data,
    this.onComplete,
  });

  void _enterApp(BuildContext context) {
    if (onComplete != null) {
      onComplete!();
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => HomeShell(data: data),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = data.myProfile;

    return Scaffold(
      backgroundColor: const Color(0xFF0C141F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'OFFICIAL TRAVEL PASS',
          style: GoogleFonts.cinzel(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'YOUR TRAVEL CREDENTIALS',
                style: GoogleFonts.spaceMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Official Travel Pass',
                style: GoogleFonts.cinzel(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // THE TRAVEL ID BADGE (Flips 3 full turns on entry!)
              // ==========================================
              TravelIdBadge(
                profile: profile,
                displayName: profile.name,
                displayAge: profile.age.toString(),
                displayInstagram: profile.instagram,
                displayX: profile.xHandle,
                profileImage: profile.avatarUrl,
                animateFlipOnMount: true,
                enableTapToFlip: true,
              ),

              const SizedBox(height: 16),

              // Interactive Hint
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.touch_app_outlined, size: 14, color: primaryColor),
                    const SizedBox(width: 6),
                    Text(
                      'Tap badge anytime to flip & inspect details',
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Enter TripNest Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => _enterApp(context),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF0B2240),
                    size: 20,
                  ),
                  label: const Text(
                    'Enter TripNest',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B2240),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 6,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Edit Details Button
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Edit Details',
                  style: GoogleFonts.spaceMono(
                    fontSize: 12,
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
