import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';
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

class _HomeShellState extends State<HomeShell> {
  int selected = 0;
  bool tripDetailOpen = false;
  bool tripsListOpen = false;
  final trip = TripData();

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

  void _onTabSelected(int index) {
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
      // Tab 0: Home
      tripDetailOpen
          ? TripScreen(
              trip: trip,
              data: widget.data,
              onBack: () => setState(() => tripDetailOpen = false),
            )
          : tripsListOpen
          ? TripsPage(trip: trip, onOpenTrip: openTrip)
          : HomeFeed(trip: trip, onOpenTrip: openTrip, onSeeAll: openTripsList),
      // Tab 1: Itinerary
      ItineraryPage(trip: trip, data: widget.data, onOpenTrip: openTrip),
      // Tab 2: Pairing (Middle & Outstanding!)
      PairingPage(data: widget.data, trip: trip),
      // Tab 3: Chat
      ChatPage(data: widget.data, trip: trip),
      // Tab 4: Profile
      ProfilePage(data: widget.data, trip: trip, onChanged: () => setState(() {})),
    ];

    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: IndexedStack(
        index: selected,
        children: pages,
      ),
      bottomNavigationBar: Container(
        height: 70 + bottomPadding,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // --------------------------------------------------
            // Bottom Bar White Background & Border
            // --------------------------------------------------
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 60 + bottomPadding,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -3),
                    ),
                  ],
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            // --------------------------------------------------
            // 5 Tabs Row: Home, Itinerary, [Pairing Gap], Chat, Profile
            // --------------------------------------------------
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomPadding,
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tab 0: Home
                  Expanded(
                    child: _buildStandardTab(
                      index: 0,
                      label: 'Home',
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                    ),
                  ),
                  // Tab 1: Itinerary
                  Expanded(
                    child: _buildStandardTab(
                      index: 1,
                      label: 'Itinerary',
                      icon: Icons.calendar_month_outlined,
                      activeIcon: Icons.calendar_month_rounded,
                    ),
                  ),
                  // Tab 2 Center Placeholder Gap for the Outstanding Pairing Button
                  const Expanded(
                    child: SizedBox.shrink(),
                  ),
                  // Tab 3: Chat
                  Expanded(
                    child: _buildStandardTab(
                      index: 3,
                      label: 'Chat',
                      icon: Icons.chat_bubble_outline_rounded,
                      activeIcon: Icons.chat_bubble_rounded,
                    ),
                  ),
                  // Tab 4: Profile
                  Expanded(
                    child: _buildStandardTab(
                      index: 4,
                      label: 'Profile',
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                    ),
                  ),
                ],
              ),
            ),

            // --------------------------------------------------
            // Outstanding Central "Pairing" Floating Button
            // --------------------------------------------------
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomPadding + 4,
              child: Center(
                child: Semantics(
                  button: true,
                  label: 'Pairing',
                  selected: selected == 2,
                  child: InkWell(
                    onTap: () => _onTabSelected(2),
                    borderRadius: BorderRadius.circular(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutBack,
                          width: selected == 2 ? 54 : 50,
                          height: selected == 2 ? 54 : 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF5A5F), // TripNest Coral
                                Color(0xFFFF7E40), // Warm Sunrise Orange
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF5A5F)
                                    .withValues(alpha: selected == 2 ? 0.5 : 0.35),
                                blurRadius: selected == 2 ? 14 : 10,
                                spreadRadius: selected == 2 ? 2 : 1,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white,
                              width: selected == 2 ? 3.5 : 2.8,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.people_alt_rounded,
                              color: Colors.white,
                              size: selected == 2 ? 27 : 24,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pairing',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selected == 2 ? FontWeight.w800 : FontWeight.w700,
                            color: selected == 2 ? coral : const Color(0xFF64748B),
                            letterSpacing: -0.2,
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
    );
  }

  Widget _buildStandardTab({
    required int index,
    required String label,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = selected == index;
    final color = isSelected ? coral : const Color(0xFF64748B);

    return Semantics(
      button: true,
      label: label,
      selected: isSelected,
      child: InkWell(
        onTap: () => _onTabSelected(index),
        child: SizedBox(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey<bool>(isSelected),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
