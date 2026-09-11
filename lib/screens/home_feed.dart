import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../models/itinerary_trip_models.dart';
import 'trip_detail_page.dart';
import 'trip_ai_assistant_screen.dart';

class HomeFeed extends StatefulWidget {
  final TripData trip;
  final SocialData? data;
  final VoidCallback onOpenTrip;
  final VoidCallback onSeeAll;
  final Function(int tabIndex)? onNavigateToTab;

  const HomeFeed({
    super.key,
    required this.trip,
    this.data,
    required this.onOpenTrip,
    required this.onSeeAll,
    this.onNavigateToTab,
  });

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  late TripFolderItem _activeTrip;
  final TextEditingController _searchController = TextEditingController();
  
  int _tripCoins = 150;
  bool _bonusClaimed = false;
  String _selectedVibe = 'All';
  
  final Set<String> _sentPairRequests = {};
  final Set<String> _likedPosts = {};
  final Set<String> _savedPosts = {};

  final List<Map<String, String>> _vibes = [
    {'name': 'All', 'icon': '✨'},
    {'name': 'Tokyo Nightlife', 'icon': '🏮'},
    {'name': 'Kyoto Zen', 'icon': '🌸'},
    {'name': 'Café Hopping', 'icon': '☕'},
    {'name': 'Alpine Trek', 'icon': '🏔️'},
    {'name': 'Street Food', 'icon': '🍜'},
  ];

  @override
  void initState() {
    super.initState();
    final demoTrips = TripRepository.getDemoTrips();
    _activeTrip = demoTrips.isNotEmpty ? demoTrips.first : _createFallbackTrip();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  TripFolderItem _createFallbackTrip() {
    return TripFolderItem(
      id: 'demo_tokyo',
      name: 'Tokyo Adventure',
      destination: 'Tokyo, Japan',
      startDate: 'Apr 12, 2026',
      endDate: 'Apr 22, 2026',
      startDateTime: DateTime(2026, 4, 12),
      endDateTime: DateTime(2026, 4, 22),
      status: TripStatus.upcoming,
      chatId: 'chat_tokyo',
      chatName: 'Tokyo Squad',
      travellers: [],
      days: [],
      placesCount: 14,
      lastUpdated: 'Today',
      notebookDecisionsCount: 4,
      mapPreviewUrl: '',
      themeColor: const Color(0xFF0F172A),
      recommendations: [],
      aiSuggestions: [],
    );
  }

  void _navigateTo(int tabIndex) {
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(tabIndex);
    }
  }

  void _openTripDetailScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripDetailPage(
          trip: _activeTrip,
          onBack: () => Navigator.pop(context),
          onNavigateToChat: (chatId) {
            Navigator.pop(context);
            _navigateTo(3);
          },
        ),
      ),
    );
  }

  void _openAiAssistantScreen({String? initialPrompt}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripAiAssistantScreen(
          trip: _activeTrip,
          onApplySuggestion: (suggestion) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Applied "${suggestion.title}" to itinerary!'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF0F172A),
              ),
            );
          },
        ),
      ),
    );
  }

  void _claimDailyBonus() {
    if (_bonusClaimed) return;
    setState(() {
      _tripCoins += 25;
      _bonusClaimed = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 22),
            const SizedBox(width: 8),
            Text(
              '🎉 +25 TripCoins claimed! Total: $_tripCoins',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 960;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TOP DYNAMIC HEADER
                  _buildDynamicHeader(),
                  const SizedBox(height: 18),

                  // 2. DISCOVERY SEARCH & VIBE CAPSULES
                  _buildSearchAndVibeBar(),
                  const SizedBox(height: 22),

                  // 3. UPCOMING ACTIVE TRIP SHOWCASE (HERO)
                  _buildActiveTripHero(isDesktop),
                  const SizedBox(height: 26),

                  // 4. TRAVEL PAIRING COMPANION SPOTLIGHT CAROUSEL
                  _buildTravelPairingSection(),
                  const SizedBox(height: 26),

                  // 5. TRIPNEST AI STUDIO & SMART PROMPT CHIPS
                  _buildAiStudioSection(),
                  const SizedBox(height: 26),

                  // 6. DAILY LOG & GAMIFICATION (TripCoins + Mood Check-in)
                  _buildDailyLogAndGamificationSection(isDesktop),
                  const SizedBox(height: 26),

                  // 7. CURATED COMMUNITY JOURNAL STORIES
                  _buildCommunityStoriesSection(),
                  const SizedBox(height: 26),

                  // 8. QUICK PLANNING HUB LAUNCHPAD
                  _buildQuickPlanningHub(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================================
  // 1. DYNAMIC PERSONALIZED HEADER
  // =========================================================================
  Widget _buildDynamicHeader() {
    final profile = widget.data?.myProfile;
    final name = profile?.name ?? 'Ben';
    final avatarUrl = profile?.avatarUrl ??
        'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500';

    final hour = DateTime.now().hour;
    String greeting;
    String greetingEmoji;
    if (hour < 12) {
      greeting = 'Good morning';
      greetingEmoji = '☀️';
    } else if (hour < 18) {
      greeting = 'Good afternoon';
      greetingEmoji = '🌤️';
    } else {
      greeting = 'Good evening';
      greetingEmoji = '🌙';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: User Greeting and Status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pill Status
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flight_takeoff_rounded, color: Colors.white, size: 12),
                        const SizedBox(width: 5),
                        Text(
                          'TOKYO IN 12 DAYS',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: Color(0xFF16A34A), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Level 2 Explorer',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Greeting Headline
              Text(
                '$greeting, $name $greetingEmoji',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),

              // Weather & Live Context Subtitle
              Row(
                children: [
                  const Icon(Icons.wb_sunny_rounded, size: 14, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 5),
                  Text(
                    'Tokyo 18°C & Clear',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('•', style: TextStyle(color: Color(0xFF94A3B8))),
                  const SizedBox(width: 8),
                  Text(
                    '4 compatible companions near you',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Right Actions: Profile Avatar
        Row(
          children: [
            // Profile Avatar with Status Ring
            GestureDetector(
              onTap: () => _navigateTo(4), // Me tab
              child: Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // 2. SEARCH & VIBE CAPSULES
  // =========================================================================
  Widget _buildSearchAndVibeBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Editorial Search Bar
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search destinations, companions, or vibes...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _searchController.clear()),
                  child: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF94A3B8)),
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.tune_rounded, size: 15, color: Color(0xFF475569)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Vibe Filter Chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _vibes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final vibe = _vibes[index];
              final isSelected = _selectedVibe == vibe['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVibe = vibe['name']!;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.18),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(vibe['icon']!, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Text(
                        vibe['name']!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 3. UPCOMING ACTIVE TRIP HERO
  // =========================================================================
  Widget _buildActiveTripHero(bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Photo Cover with Gradient
          SizedBox(
            height: isDesktop ? 300 : 340,
            width: double.infinity,
            child: Image.network(
              'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=1000',
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => Container(
                color: const Color(0xFF1E293B),
                child: const Icon(Icons.landscape_rounded, size: 60, color: Colors.white38),
              ),
            ),
          ),

          // Rich Multi-layer Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.55),
                    const Color(0xFF0F172A).withValues(alpha: 0.94),
                  ],
                  stops: const [0.0, 0.45, 0.88],
                ),
              ),
            ),
          ),

          // Foreground Content
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Tag Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge: Ongoing Trip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF34D399),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ONGOING TRIP',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Day Progress Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wb_sunny_rounded, size: 14, color: Color(0xFF15803D)),
                          const SizedBox(width: 5),
                          Text(
                            'Day 3 of 10',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Destination Title & Dates
                Text(
                  'Tokyo Adventure 🇯🇵',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, size: 14, color: Colors.white70),
                    const SizedBox(width: 6),
                    Text(
                      'Apr 12 – Apr 22, 2026 • 10 Days • 14 Places',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Next Scheduled Stop Preview (Frosted Container)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text('☕', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'DAY 3 • 09:30 AM',
                                        style: GoogleFonts.inter(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Next scheduled stop',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Senso-ji Temple & Asakusa Market',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Collaborators Stack & CTA Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Co-travelers Avatar Stack
                    Row(
                      children: [
                        SizedBox(
                          width: 82,
                          height: 32,
                          child: Stack(
                            children: [
                              _buildPositionedAvatar(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=120',
                                0,
                              ),
                              _buildPositionedAvatar(
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120',
                                18,
                              ),
                              _buildPositionedAvatar(
                                'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=120',
                                36,
                              ),
                              Positioned(
                                left: 54,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF0F172A), width: 1.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+2',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Maya, Daniel +2',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    // Actions: Ask AI & Open Itinerary
                    Row(
                      children: [
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: 0.18),
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                          tooltip: 'Ask Trip AI',
                          onPressed: () => _openAiAssistantScreen(),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0F172A),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: _openTripDetailScreen,
                          child: Row(
                            children: [
                              Text(
                                'Open Trip',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded, size: 15),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 4. TRAVEL PAIRING COMPANION SPOTLIGHT CAROUSEL
  // =========================================================================
  Widget _buildTravelPairingSection() {
    final matches = widget.data?.potentialMatches ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.explore_rounded, color: Color(0xFF2563EB), size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Travel Pairing Matches',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Travelers matching your INTJ rhythm, pace & destinations',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _navigateTo(2), // Pair tab
              child: Row(
                children: [
                  Text(
                    'Explore All',
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF2563EB)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Carousel of Companion Cards
        SizedBox(
          height: 228,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: matches.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final match = matches[index];
              final isRequested = _sentPairRequests.contains(match.username);

              return Container(
                width: 270,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar & Compatibility Score Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            match.avatarUrl ??
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      match.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    ', ${match.age}',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      match.mbti,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      match.travelPace,
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF64748B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Match Score Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${match.compatibilityScore}%',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF16A34A),
                                ),
                              ),
                              Text(
                                'Match',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Destination Goal
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF2563EB)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            match.preferredDestination != 'Unknown'
                                ? match.preferredDestination
                                : 'Flexible Destination',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Interests Tags
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: match.interests.take(2).map((interest) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            interest,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const Spacer(),

                    // Action Button: Pair Request
                    SizedBox(
                      width: double.infinity,
                      child: isRequested
                          ? OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF10B981)),
                                backgroundColor: const Color(0xFFECFDF5),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.check_rounded, size: 14, color: Color(0xFF059669)),
                              label: Text(
                                'Pair Requested',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                            )
                          : FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _sentPairRequests.add(match.username);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('✨ Pair request sent to ${match.name}!'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: const Color(0xFF0F172A),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.handshake_rounded, size: 14),
                              label: Text(
                                'Request Pair',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 5. TRIPNEST AI STUDIO & PROMPT CHIPS
  // =========================================================================
  Widget _buildAiStudioSection() {
    final suggestions = [
      {'icon': '✨', 'prompt': 'Make Day 2 less tiring'},
      {'icon': '🍜', 'prompt': 'Hidden ramen gems near Shibuya'},
      {'icon': '💰', 'prompt': 'Check budget for Tokyo trip'},
      {'icon': '🌦️', 'prompt': 'Re-order stops to avoid rain'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFEFF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBAE6FD)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TripNest AI Studio',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Intelligent recommendations & pace balancing',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                ),
                onPressed: () => _openAiAssistantScreen(),
                child: Text(
                  'Open Chat',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            'Tap any prompt to optimize Tokyo Adventure right now:',
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 10),

          // Suggestion Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((s) {
              return GestureDetector(
                onTap: () => _openAiAssistantScreen(initialPrompt: s['prompt']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s['icon']!, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Text(
                        s['prompt']!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 6. DAILY LOG & GAMIFICATION (TripCoins)
  // =========================================================================
  Widget _buildDailyLogAndGamificationSection(bool isDesktop) {
    return _buildTripCoinsCard();
  }

  Widget _buildTripCoinsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.stars_rounded, color: Color(0xFFD97706), size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'TripCoins Wallet',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 14, color: Color(0xFFEA580C)),
                    const SizedBox(width: 4),
                    Text(
                      '3-day streak',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_tripCoins',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'TripCoins',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Redeemable for curated local experiences & itinerary perks.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),

          // Daily Bonus Claim Button
          SizedBox(
            width: double.infinity,
            child: _bonusClaimed
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF16A34A)),
                          const SizedBox(width: 6),
                          Text(
                            'Daily bonus claimed (+25 coins) ✓',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _claimDailyBonus,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.card_giftcard_rounded, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Claim Today\'s Bonus (+25)',
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }



  // =========================================================================
  // 7. CURATED COMMUNITY JOURNAL STORIES
  // =========================================================================
  Widget _buildCommunityStoriesSection() {
    final posts = widget.data?.posts ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Travel Log',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Stories, spots & notes shared by paired companions',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF2563EB)),
              onPressed: () => _navigateTo(1),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Horizontal Story Cards
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final post = posts[index];
              final isLiked = _likedPosts.contains(post.tripName);
              final isSaved = _savedPosts.contains(post.tripName);

              return Container(
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post Image with Author Tag
                    Stack(
                      children: [
                        Image.network(
                          'https://images.unsplash.com/${post.image}?w=500',
                          height: 125,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(
                            height: 125,
                            color: const Color(0xFFCBD5E1),
                            child: const Icon(Icons.image, color: Colors.white),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  post.location,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSaved) {
                                  _savedPosts.remove(post.tripName);
                                } else {
                                  _savedPosts.add(post.tripName);
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                size: 16,
                                color: isSaved ? const Color(0xFF2563EB) : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Post Details
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                post.tripName,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              Text(
                                '@${post.owner}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            post.caption,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF475569),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),

                          // Like and Share Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isLiked) {
                                      _likedPosts.remove(post.tripName);
                                    } else {
                                      _likedPosts.add(post.tripName);
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                      size: 16,
                                      color: isLiked ? const Color(0xFFEF4444) : const Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isLiked ? '19 likes' : '18 likes',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        color: const Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                post.dates,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // 8. QUICK PLANNING HUB LAUNCHPAD
  // =========================================================================
  Widget _buildQuickPlanningHub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Planning Hub',
          style: GoogleFonts.playfairDisplay(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.calendar_month_rounded,
                title: 'Itinerary',
                subtitle: '14 places set',
                badgeText: 'Live',
                badgeColor: const Color(0xFF10B981),
                onTap: () => _navigateTo(1),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.explore_rounded,
                title: 'Pairing',
                subtitle: '8 matches',
                badgeText: 'New',
                badgeColor: const Color(0xFF2563EB),
                onTap: () => _navigateTo(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.auto_awesome_rounded,
                title: 'AI Studio',
                subtitle: '4 ideas',
                badgeText: 'Pro',
                badgeColor: const Color(0xFF8B5CF6),
                onTap: () => _openAiAssistantScreen(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.person_pin_rounded,
                title: 'Travel ID',
                subtitle: 'Score 98',
                badgeText: 'Verified',
                badgeColor: const Color(0xFF059669),
                onTap: () => _navigateTo(4),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionedAvatar(String url, double left) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage(url),
        ),
      ),
    );
  }
}
