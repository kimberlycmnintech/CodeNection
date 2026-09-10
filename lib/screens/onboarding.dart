import 'dart:async';
import 'dart:math' as math;
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

    if (_dragOffset.dx > 90 || velocity > 500) {
      _swipeCardOut(isLeft: false);
    } else if (_dragOffset.dx < -90 || velocity < -500) {
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
    final targetX = isLeft ? -screenWidth * 1.5 : screenWidth * 1.5;
    final targetOffset = Offset(targetX, _dragOffset.dy * 1.2);

    _slideAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: targetOffset,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInQuad),
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    final current = topics[currentIndex];

    // Card dimensions matching diagram proportions
    final cardWidth = math.min(screenWidth * 0.44, 280.0).clamp(200.0, 300.0);
    final cardHeight = (screenHeight * 0.52).clamp(300.0, 420.0);

    // Rotation tilt angle based on horizontal drag
    final rotationAngle = (_dragOffset.dx / screenWidth) * 0.35;

    // Feedback intensities for left and right titles
    final leftDragIntensity = (-_dragOffset.dx / 100.0).clamp(0.0, 1.0);
    final rightDragIntensity = (_dragOffset.dx / 100.0).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ==========================================
          // 1. RECTANGULAR COMBINED DUAL-IMAGE BACKGROUND
          // WITH VAGUE / FEATHERED GRADIENT BRIDGE
          // ==========================================
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Right Image (covering right side and blended underneath)
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Image.network(
                      current['rightImage'],
                      key: ValueKey<String>('right_${current['rightImage']}'),
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.3, 0.0),
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xFF232526), Color(0xFF414345)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Left Image with ShaderMask fading out across the center bridge
                Positioned.fill(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.0, 0.32, 0.68, 1.0],
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.transparent,
                          Colors.transparent,
                        ],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Image.network(
                        current['leftImage'],
                        key: ValueKey<String>('left_${current['leftImage']}'),
                        fit: BoxFit.cover,
                        alignment: const Alignment(-0.3, 0.0),
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Soft subtle center vignette softening the bridge
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.35, 0.50, 0.65, 1.0],
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.06),
                          Colors.black.withValues(alpha: 0.22),
                          Colors.black.withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Full-bleed Black Gradient Overlay from top to bottom
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.32),
                          Colors.black.withValues(alpha: 0.45),
                          Colors.black.withValues(alpha: 0.72),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 2. FOREGROUND CHOICE SECTION
          // (Fades in when centered prompt disappears)
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
                children: [
                  // "First Title" + Short Description (No black shape behind)
                  Positioned(
                    left: 28,
                    right: screenWidth * 0.52,
                    bottom: mediaQuery.padding.bottom + 28,
                    child: AnimatedScale(
                      scale: 1.0 + (leftDragIntensity * 0.10),
                      duration: const Duration(milliseconds: 120),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            current['leftTitle']!,
                            style: GoogleFonts.caladea(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            current['leftDescription']!,
                            style: GoogleFonts.caladea(
                              fontSize: 13,
                              height: 1.35,
                              color: Colors.white.withValues(alpha: 0.90),
                              fontWeight: FontWeight.w400,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // "Second title" + Short Description (No black shape behind)
                  Positioned(
                    right: 28,
                    left: screenWidth * 0.52,
                    bottom: mediaQuery.padding.bottom + 28,
                    child: AnimatedScale(
                      scale: 1.0 + (rightDragIntensity * 0.10),
                      duration: const Duration(milliseconds: 120),
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            current['rightTitle']!,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.caladea(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            current['rightDescription']!,
                            textAlign: TextAlign.right,
                            style: GoogleFonts.caladea(
                              fontSize: 13,
                              height: 1.35,
                              color: Colors.white.withValues(alpha: 0.90),
                              fontWeight: FontWeight.w400,
                              shadows: const [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Top Step Progress Indicator
                  Positioned(
                    top: mediaQuery.padding.top + 16,
                    left: 36,
                    right: 36,
                    child: Row(
                      children: List.generate(topics.length, (index) {
                        final isDoneOrCurrent = index <= currentIndex;
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: isDoneOrCurrent
                                  ? primaryColor
                                  : Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Central Card Interface
                  Center(
                    child: SizedBox(
                      width: cardWidth,
                      height: cardHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Underneath Card in Stack
                          if (currentIndex + 1 < topics.length)
                            Transform.scale(
                              scale: 0.92,
                              child: _buildCardContent(
                                topicLine1:
                                    topics[currentIndex + 1]['topicLine1']!,
                                topicLine2:
                                    topics[currentIndex + 1]['topicLine2']!,
                                isTopCard: false,
                              ),
                            ),

                          // Front Active Card (Draggable & Animated)
                          Transform.translate(
                            offset: _dragOffset,
                            child: Transform.rotate(
                              angle: rotationAngle,
                              child: GestureDetector(
                                onPanStart: _onPanStart,
                                onPanUpdate: _onPanUpdate,
                                onPanEnd: _onPanEnd,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    _buildCardContent(
                                      topicLine1: current['topicLine1']!,
                                      topicLine2: current['topicLine2']!,
                                      isTopCard: true,
                                    ),

                                    // Dynamic Stamp: Right Choice
                                    if (rightDragIntensity > 0.1)
                                      Positioned(
                                        top: 20,
                                        left: 16,
                                        child: Transform.rotate(
                                          angle: -0.2,
                                          child: Opacity(
                                            opacity: rightDragIntensity,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF27AE60),
                                                  width: 2.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                current['rightTitle']!
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Color(0xFF27AE60),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 0.8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Dynamic Stamp: Left Choice
                                    if (leftDragIntensity > 0.1)
                                      Positioned(
                                        top: 20,
                                        right: 16,
                                        child: Transform.rotate(
                                          angle: 0.2,
                                          child: Opacity(
                                            opacity: leftDragIntensity,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFE74C3C),
                                                  width: 2.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                current['leftTitle']!
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Color(0xFFE74C3C),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 0.8,
                                                ),
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
                        ],
                      ),
                    ),
                  ),

                  // Tap-to-swipe navigation buttons at bottom center
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: mediaQuery.padding.bottom + 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _swipeCardOut(isLeft: true),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF1E242B),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        InkWell(
                          onTap: () => _swipeCardOut(isLeft: false),
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF1E242B),
                              size: 22,
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
          // 3. CENTERED PROMPT
          // Disappears on user click or after 4.5s of no response
          // ==========================================
          if (!_introFinished)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _dismissIntro, // User click triggers immediate slide-up & disappear
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.50 * (1.0 - _introDismissController.value),
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
                              width: 48,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 24),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Text(
                              '“What kind of journey feels right for you?”',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.calistoga(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.25,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 16,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Choose the preferences that make your trip uniquely yours.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.caladea(
                                fontSize: 17,
                                color: Colors.white.withValues(alpha: 0.9),
                                height: 1.45,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black87,
                                    blurRadius: 12,
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
    );
  }

  /// Builds the black center card with Calistoga font
  Widget _buildCardContent({
    required String topicLine1,
    required String topicLine2,
    required bool isTopCard,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black, // Solid black
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.16),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isTopCard ? 0.45 : 0.25),
            blurRadius: isTopCard ? 24 : 14,
            offset: Offset(isTopCard ? 4 : 2, isTopCard ? 8 : 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              topicLine1,
              style: GoogleFonts.calistoga(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: Colors.white, // White text
                letterSpacing: -0.5,
                height: 1.15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              topicLine2,
              style: GoogleFonts.calistoga(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: Colors.white, // White text
                letterSpacing: -0.5,
                height: 1.15,
              ),
              textAlign: TextAlign.center,
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
