import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wanderlog_clone/models/itinerary_trip_models.dart';
import 'package:wanderlog_clone/widgets/travel_memories_dialog.dart';

void main() {
  testWidgets('TripMemories3DBookDialog renders open book without black bracket and supports dragging to flip pages', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final testTrip = TripRepository.getDemoTrips().first;

    final testMemories = [
      TravelMemoryItem(
        dayNumber: 1,
        dateStr: 'Nov 12',
        destination: 'Tokyo Moments',
        photoUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=700',
        emoji: '😊',
        feelingLabel: 'Peaceful',
        heading: 'Arrival & Autumn Pagoda Walk',
        reflection: 'Arrived in Tokyo! Crisp autumn 18°C weather. Golden dusk illuminated the pagodas.',
      ),
      TravelMemoryItem(
        dayNumber: 2,
        dateStr: 'Nov 13',
        destination: 'Shibuya Highs',
        photoUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?w=700',
        emoji: '✨',
        feelingLabel: 'Excited',
        heading: 'Shibuya Sunset & Neon Lights',
        reflection: 'Spectacular sunset from Shibuya Sky 47 floors above the crossing.',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withValues(alpha: 0.55),
                  builder: (_) => TripMemories3DBookDialog(
                    trip: testTrip,
                    memories: testMemories,
                    initialPage: 0,
                  ),
                );
              },
              child: const Text('Open 3D Book'),
            ),
          ),
        ),
      ),
    );

    // 1. Open the 3D Book Dialog
    await tester.tap(find.text('Open 3D Book'));
    await tester.pumpAndSettle();

    // Verify open book header
    expect(find.text('Trip Memory Book'), findsOneWidget);
    expect(find.text('Drag page to flip with 3D depth'), findsOneWidget);

    // Verify open book spread (Left page photo & caption, Right page details)
    expect(find.text('Arrival & Autumn Pagoda Walk'), findsOneWidget);
    expect(find.textContaining('Tokyo Moments'), findsWidgets);
    expect(find.text('Peaceful'), findsOneWidget);
    expect(find.text('Day 1 (1 of 2)'), findsOneWidget);

    // Verify no dark/black container bracket (0xFF0F172A background removed)
    final darkContainerFinder = find.byWidgetPredicate(
      (widget) => widget is Container && widget.color == const Color(0xFF0F172A),
    );
    expect(darkContainerFinder, findsNothing);

    // 2. Test horizontal drag to flip forward
    await tester.drag(find.text('Arrival & Autumn Pagoda Walk'), const Offset(-300, 0));
    await tester.pumpAndSettle();

    // Verify page has turned to Page 2
    expect(find.text('Shibuya Sunset & Neon Lights'), findsOneWidget);
    expect(find.text('Day 2 (2 of 2)'), findsOneWidget);

    // 3. Test Prev Page button to flip back
    await tester.tap(find.text('Prev Page'));
    await tester.pumpAndSettle();

    // Verify returned to Page 1
    expect(find.text('Arrival & Autumn Pagoda Walk'), findsOneWidget);
    expect(find.text('Day 1 (1 of 2)'), findsOneWidget);

    // 4. Test Next Page button
    await tester.tap(find.text('Next Page'));
    await tester.pumpAndSettle();
    expect(find.text('Shibuya Sunset & Neon Lights'), findsOneWidget);

    // Close Dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Trip Memory Book'), findsNothing);
  });
}
