import 'package:flutter/material.dart';
import '../models/models.dart';
import 'home_feed.dart';
import 'social_page.dart';
import 'create_trip_page.dart';
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
          : HomeFeed(trip: trip, onOpenTrip: openTrip, onSeeAll: openTripsList),
      SocialPage(data: widget.data),
      CreateTripPage(data: widget.data, onCreate: createTrip),
      ProfilePage(data: widget.data, trip: trip, onChanged: () => setState(() {})),
    ];
    return Scaffold(
      body: pages[selected],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) => setState(() {
          selected = index;
          if (index == 0) {
            tripDetailOpen = false;
            tripsListOpen = false;
          }
        }),
        indicatorColor: const Color(0xffffe2de),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Social',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
