import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import 'home_feed.dart';
import 'itinerary_page.dart';
import 'pairing_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'trip_screen.dart';
import 'trips_page.dart';

class HomeShell extends StatefulWidget {
  final SocialData data;
  const HomeShell({super.key, required this.data});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with TickerProviderStateMixin {
  int selected = 0;
  bool tripDetailOpen = false;
  bool tripsListOpen = false;
  final trip = TripData();

  late List<AnimationController> _tabControllers;

  @override
  void initState() {
    super.initState();
    _tabControllers = List.generate(
      5,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 130),
        lowerBound: 0.88,
        upperBound: 1.0,
        value: 1.0,
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _tabControllers) { c.dispose(); }
    super.dispose();
  }

  void openTrip() => setState(() {
        selected = 0;
        tripDetailOpen = true;
        tripsListOpen = false;
      });

  void openTripsList() => setState(() {
        selected = 0;
        tripDetailOpen = false;
        tripsListOpen = true;
      });

  void createTrip(String name, String destination) {
    setState(() {
      trip.name = name;
      trip.destination = destination;
      selected = 0;
      tripDetailOpen = true;
      tripsListOpen = false;
    });
  }

  void _onTabSelected(int index) async {
    final c = _tabControllers[index];
    c.reverse();
    await Future.delayed(const Duration(milliseconds: 80));
    c.forward();
    setState(() {
      selected = index;
      if (index == 0) {
        tripDetailOpen = false;
        tripsListOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      tripDetailOpen
          ? TripScreen(
              trip: trip,
              data: widget.data,
              onBack: () => setState(() => tripDetailOpen = false),
            )
          : tripsListOpen
              ? TripsPage(trip: trip, onOpenTrip: openTrip)
              : HomeFeed(
                  trip: trip,
                  data: widget.data,
                  onOpenTrip: openTrip,
                  onSeeAll: openTripsList,
                  onNavigateToTab: (idx) => _onTabSelected(idx),
                ),
      ItineraryPage(
        trip: trip,
        data: widget.data,
        onOpenTrip: openTrip,
        onNavigateToChat: (chatId) => setState(() => selected = 3),
      ),
      PairingPage(
        data: widget.data,
        trip: trip,
        onNavigateToChat: () => _onTabSelected(3),
      ),
      ChatPage(data: widget.data, trip: trip),
      ProfilePage(data: widget.data, trip: trip, onChanged: () => setState(() {})),
    ];

    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD),
      extendBody: true,
      body: IndexedStack(index: selected, children: pages),
      // =====================================================================
      // FLOATING PILL NAVIGATION BAR WITH ELEVATED PAIR BUTTON
      // Matched precisely to design: soft ice-pill active tabs & protruding Pair compass
      // =====================================================================
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? bottomPadding + 6 : 16),
        child: SizedBox(
          height: 76,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // 1. The Main Capsule Bar
              Container(
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF192338).withValues(alpha: 0.07),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavTab(
                        0,
                        Icons.home_rounded,
                        Icons.home_outlined,
                        'Home',
                      ),
                    ),
                    Expanded(
                      child: _buildNavTab(
                        1,
                        Icons.calendar_month_rounded,
                        Icons.calendar_month_outlined,
                        'Trips',
                      ),
                    ),
                    // Centered gap for the elevated Pair button
                    const SizedBox(width: 64),
                    Expanded(
                      child: _buildNavTab(
                        3,
                        Icons.chat_bubble_rounded,
                        Icons.chat_bubble_outline_rounded,
                        'Chat',
                      ),
                    ),
                    Expanded(
                      child: _buildNavTab(
                        4,
                        Icons.person_rounded,
                        Icons.person_outline_rounded,
                        'Me',
                      ),
                    ),
                  ],
                ),
              ),

              // 2. The Floating Elevated Center "Pair" Button
              Positioned(
                bottom: 6,
                child: _buildCenterPairTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isActive = selected == index;

    return ScaleTransition(
      scale: _tabControllers[index],
      child: GestureDetector(
        onTap: () => _onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: isActive ? 66 : 58,
            height: 56,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFF1F6FB) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isActive)
                  Container(
                    width: 34,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF192338),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      activeIcon,
                      color: Colors.white,
                      size: 19,
                    ),
                  )
                else
                  SizedBox(
                    height: 30,
                    child: Center(
                      child: Icon(
                        inactiveIcon,
                        color: const Color(0xFF7E8E9F),
                        size: 23,
                      ),
                    ),
                  ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? const Color(0xFF192338) : const Color(0xFF7E8E9F),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterPairTab() {
    final isSelected = selected == 2;

    return ScaleTransition(
      scale: _tabControllers[2],
      child: GestureDetector(
        onTap: () => _onTabSelected(2),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF192338).withValues(alpha: 0.10),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF192338),
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: const Color(0xFF3B82F6), width: 2)
                      : null,
                ),
                child: const Center(
                  child: Icon(
                    Icons.explore,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Pair',
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF192338),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
