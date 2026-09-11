import 'dart:ui';
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
      ItineraryPage(
        trip: trip,
        data: widget.data,
        onOpenTrip: openTrip,
        onNavigateToChat: (chatId) {
          setState(() {
            selected = 3; // Switch directly to Chat tab!
          });
        },
      ),
      // Tab 2: Pairing
      PairingPage(
        data: widget.data,
        trip: trip,
        onNavigateToChat: () => _onTabSelected(3),
      ),
      // Tab 3: Chat
      ChatPage(data: widget.data, trip: trip),
      // Tab 4: Profile
      ProfilePage(data: widget.data, trip: trip, onChanged: () => setState(() {})),
    ];

    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selected,
        children: pages,
      ),
      // =======================================================================
      // FLOATING ICE-BLUE LIGHT PILL NAVIGATION BAR (REF MOCKUP STYLE)
      // =======================================================================
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding > 0 ? bottomPadding + 4 : 16),
        height: 64,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92), // Light translucent pill
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFloatingTab(0, Icons.home_rounded, 'Home'),
                  _buildFloatingTab(1, Icons.calendar_today_rounded, 'Itinerary'),
                  _buildFloatingTab(2, Icons.swap_horiz_rounded, 'Pairing'),
                  _buildFloatingTab(3, Icons.chat_bubble_rounded, 'Chat'),
                  _buildFloatingTab(4, Icons.person_rounded, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingTab(int index, IconData icon, String label) {
    final isSelected = selected == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 8)
            : const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? darkSlate : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: darkSlate.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : darkSlate.withValues(alpha: 0.75),
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: isSelected
                  ? boldItalicTitle(12, color: Colors.white)
                  : TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: darkSlate.withValues(alpha: 0.75),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

