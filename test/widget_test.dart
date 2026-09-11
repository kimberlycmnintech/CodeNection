import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanderlog_clone/main.dart';
import 'package:wanderlog_clone/models/models.dart';
import 'package:wanderlog_clone/screens/home_shell.dart';
import 'package:wanderlog_clone/screens/onboarding.dart';
import 'package:wanderlog_clone/screens/profile_page.dart';
import 'package:wanderlog_clone/screens/itinerary_page.dart';
import 'package:wanderlog_clone/models/itinerary_trip_models.dart';
import 'package:wanderlog_clone/services/google_maps_service.dart';
import 'package:wanderlog_clone/widgets/boarding_pass_ticket.dart';
import 'package:wanderlog_clone/widgets/travel_id_badge.dart';
import 'package:wanderlog_clone/widgets/interactive_itinerary_map.dart';
import 'package:wanderlog_clone/widgets/place_detail_dialog.dart';

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _MockHttpClientResponse implements HttpClientResponse {
  static final List<int> _kTransparentImage = <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ];

  @override
  int get statusCode => 200;
  @override
  int get contentLength => _kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable(<List<int>>[_kTransparentImage])
        .listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('splash screen renders and navigates to auth gate on tap', (WidgetTester tester) async {
    await tester.pumpWidget(const TripNestApp());

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Find Your Flock. Share the Journey.'), findsOneWidget);
    expect(find.text('Sign Up to page'), findsOneWidget);

    await tester.tap(find.text('Sign Up to page'));
    await tester.pumpAndSettle();

    expect(find.text('Plan your next adventure'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('swipe onboarding prompt dismisses on tap and choices work', (WidgetTester tester) async {
    final social = SocialData();

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeOnboardingScreen(data: social),
      ),
    );

    // Initial frame shows intro question and description
    expect(find.text('“What kind of journey feels right for you?”'), findsOneWidget);
    expect(find.text('Choose the preferences that make your trip uniquely yours.'), findsOneWidget);

    // User taps on the prompt to dismiss it
    await tester.tap(find.text('“What kind of journey feels right for you?”'));
    await tester.pumpAndSettle();

    // Intro prompt is now dismissed
    expect(find.text('“What kind of journey feels right for you?”'), findsNothing);

    // Verify choice section is active with central card "Travel" and "Pace"
    expect(find.text('Travel'), findsOneWidget);
    expect(find.text('Pace'), findsOneWidget);

    // Verify subtitles with short descriptions (without black shape behind)
    expect(find.text('Relaxed'), findsWidgets);
    expect(find.text('Slow mornings, coffee strolls, and peaceful wanderings'), findsOneWidget);

    expect(find.text('Packed Itinerary'), findsWidgets);
    expect(find.text('Fast-paced, full schedules, and seeing every landmark'), findsOneWidget);

    // Tap forward button to select "Packed Itinerary"
    await tester.tap(find.byIcon(Icons.arrow_forward_rounded));
    await tester.pumpAndSettle();

    // Verify next card "Budget" "Style" is displayed
    expect(find.text('Budget'), findsOneWidget);
    expect(find.text('Style'), findsOneWidget);
    expect(find.text('Budget Explorer'), findsWidgets);
    expect(find.text('Comfort & Luxury'), findsWidgets);

    // Verify profile recorded choice
    expect(social.myProfile.travelPace, 'Packed Itinerary');
  });

  testWidgets('swipe onboarding prompt automatically dismisses when user does not respond', (WidgetTester tester) async {
    final social = SocialData();

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeOnboardingScreen(data: social),
      ),
    );

    // Prompt is initially visible
    expect(find.text('“What kind of journey feels right for you?”'), findsOneWidget);

    // Simulate 4.5 seconds of user inactivity
    await tester.pump(const Duration(milliseconds: 4500));
    await tester.pumpAndSettle();

    // Prompt has disappeared automatically
    expect(find.text('“What kind of journey feels right for you?”'), findsNothing);

    // Choice section is now active
    expect(find.text('Travel'), findsOneWidget);
    expect(find.text('Pace'), findsOneWidget);
    expect(find.text('Relaxed'), findsWidgets);
    expect(find.text('Packed Itinerary'), findsWidgets);
  });

  testWidgets('PassengerDetailsFormScreen shows form only, and navigates to PersonalPassScreen with TravelIdBadge', (WidgetTester tester) async {
    final social = SocialData();
    social.myProfile.name = '';
    social.myProfile.age = 0;
    social.myProfile.travelPace = 'Relaxed';
    social.myProfile.budgetStyle = 'Budget Explorer';
    social.myProfile.dailyRhythm = 'Early Riser';
    social.myProfile.destinationVibe = 'Vibrant City';
    social.myProfile.planningStyle = 'Spontaneous';

    bool completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: PassengerDetailsFormScreen(
          data: social,
          onComplete: () {
            completed = true;
          },
        ),
      ),
    );

    // Header and Form only (NO badge or boarding pass shown on this screen!)
    expect(find.text('PASSENGER DETAILS'), findsOneWidget);
    expect(find.text('CREDENTIAL REGISTRATION'), findsOneWidget);
    expect(find.text('Personal Details'), findsOneWidget);
    expect(find.byType(TravelIdBadge), findsNothing);
    expect(find.byType(BoardingPassTicket), findsNothing);

    // Input fields for passenger details and social links
    expect(find.widgetWithText(TextFormField, 'Name of Passenger (Required)'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Age (Required)'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Instagram Link / Handle (Optional)'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'X (Twitter) Link / Handle (Optional)'), findsOneWidget);

    // Fill in required name and age
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name of Passenger (Required)'),
      'Jessie Mesa',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Age (Required)'),
      '24',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Instagram Link / Handle (Optional)'),
      '@jessie_mesa',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'X (Twitter) Link / Handle (Optional)'),
      '@jessie_x',
    );
    await tester.pumpAndSettle();

    // Tap Generate Travel Pass
    await tester.ensureVisible(find.text('Generate Travel Pass'));
    await tester.tap(find.text('Generate Travel Pass'));
    await tester.pumpAndSettle();

    // Now navigated to PersonalPassScreen showing the Travel ID Badge!
    expect(find.text('OFFICIAL TRAVEL PASS'), findsOneWidget);
    expect(find.byType(TravelIdBadge), findsOneWidget);
    expect(find.text('THE'), findsOneWidget);
    expect(find.text('EXPLORER'), findsOneWidget);
    expect(find.text('DROP : 26'), findsOneWidget);
    expect(find.text('45-12H'), findsOneWidget);

    // Preferences and personal data visible on the badge
    expect(find.text('Jessie Mesa'), findsOneWidget);
    expect(find.text('24 YRS'), findsOneWidget);
    expect(find.text('Relaxed'), findsOneWidget);
    expect(find.text('Vibrant City'), findsOneWidget);

    // Test tapping to flip the inside card
    await tester.tap(find.byType(TravelIdBadge));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('THE'), findsOneWidget);
    expect(find.text('EXPLORER'), findsOneWidget);

    // Tap Enter TripNest
    await tester.ensureVisible(find.text('Enter TripNest'));
    await tester.tap(find.text('Enter TripNest'));
    await tester.pump();

    expect(completed, isTrue);
    expect(social.myProfile.name, 'Jessie Mesa');
    expect(social.myProfile.age, 24);
    expect(social.myProfile.instagram, '@jessie_mesa');
  });

  testWidgets('ProfilePage shows pending status when details missing, and shows Boarding Pass when all information filled', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final social = SocialData();
    // Start with empty name and 0 age to test incomplete state
    social.myProfile.name = '';
    social.myProfile.age = 0;
    social.myProfile.travelPace = 'Relaxed';
    social.myProfile.budgetStyle = 'Budget Explorer';
    social.myProfile.dailyRhythm = 'Early Riser';
    social.myProfile.destinationVibe = 'Vibrant City';
    social.myProfile.planningStyle = 'Spontaneous';

    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(
          data: social,
          trip: TripData(),
          onChanged: () {},
        ),
      ),
    );

    // Initial state: details missing, shows pending notice
    expect(find.text('Travel Pass Pending'), findsOneWidget);
    expect(find.text('PENDING DETAILS'), findsOneWidget);
    expect(find.text('0 of 2 required fields completed'), findsOneWidget);
    expect(find.text('ISSUED & ACTIVE'), findsNothing);

    // Enter passenger name
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Name of Passenger (Required)'),
      'Harshall D.P',
    );
    await tester.pumpAndSettle();

    // Now 1 of 2 completed, still pending
    expect(find.text('1 of 2 required fields completed'), findsOneWidget);
    expect(find.text('ISSUED & ACTIVE'), findsNothing);

    // Enter passenger age
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Age (Required)'),
      '24',
    );
    await tester.pumpAndSettle();

    // Now all required information is filled!
    // The Travel Pass badge appears with ISSUED & ACTIVE
    expect(find.text('ISSUED & ACTIVE'), findsOneWidget);
    expect(find.byType(TravelIdBadge), findsOneWidget);
    expect(find.text('THE'), findsOneWidget);
    expect(find.text('EXPLORER'), findsOneWidget);
    expect(find.text('45-12H'), findsOneWidget);

    // Enter optional social media links
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Instagram Link / Handle (Optional)'),
      '@harshall_travels',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'X (Twitter) Link / Handle (Optional)'),
      '@harshall_x',
    );
    await tester.pumpAndSettle();

    // Verify live update on badge
    expect(
      find.descendant(
        of: find.byType(TravelIdBadge),
        matching: find.text('@harshall_travels'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(TravelIdBadge),
        matching: find.text('@harshall_x'),
      ),
      findsOneWidget,
    );

    // Tap Save button
    await tester.ensureVisible(find.text('Save & Update Travel Pass'));
    await tester.tap(find.text('Save & Update Travel Pass'));
    await tester.pump();

    // Verify profile updated
    expect(social.myProfile.name, 'Harshall D.P');
    expect(social.myProfile.age, 24);
    expect(social.myProfile.instagram, '@harshall_travels');
    expect(social.myProfile.xHandle, '@harshall_x');
  });

  testWidgets('HomeShell renders 5 tabs (Home, Itinerary, Pairing, Chat, Profile) with outstanding middle Pairing button', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final social = SocialData();
    social.myProfile.name = 'Alex Morgan';
    social.myProfile.age = 25;

    await tester.pumpWidget(
      MaterialApp(
        home: HomeShell(data: social),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 5 tab labels exist
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Itinerary'), findsOneWidget);
    expect(find.text('Pairing'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Initial tab is Home
    expect(find.text('TripNest'), findsOneWidget);
    expect(find.text('Continue planning'), findsOneWidget);

    // Switch to Itinerary tab
    await tester.tap(find.text('Itinerary'));
    await tester.pumpAndSettle();
    expect(find.text('My Itineraries'), findsOneWidget);

    // Switch to outstanding center Pairing tab
    await tester.tap(find.text('Pairing'));
    await tester.pumpAndSettle();
    expect(find.text('Travel Pairing'), findsOneWidget);
    expect(find.text('YOUR TRAVEL DNA'), findsOneWidget);

    // Switch to Chat tab
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    expect(find.text('Tokyo Squad'), findsWidgets);

    // Switch to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(TravelIdBadge), findsOneWidget);

    // Return to Home tab
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Continue planning'), findsOneWidget);
  });

  testWidgets('ItineraryPage: renders My Itineraries dashboard, folders, search, filter, and calendar view', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final social = SocialData();
    final trip = TripData();

    await tester.pumpWidget(
      MaterialApp(
        home: ItineraryPage(trip: trip, data: social),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Header & Subtitle
    expect(find.text('My Itineraries'), findsOneWidget);
    expect(find.text('Every conversation can become a journey.'), findsOneWidget);

    // 2. Trip Folder Cards render
    expect(find.text('Tokyo Adventure'), findsOneWidget);
    expect(find.text('Seoul Food Trip'), findsOneWidget);
    expect(find.text('Penang Weekend'), findsOneWidget);
    expect(find.text('Tokyo Squad'), findsOneWidget);

    // 3. Switch to Calendar View
    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();

    expect(find.text('November 2026'), findsOneWidget);
    expect(find.text('All scheduled trip journeys & dates'), findsOneWidget);
    expect(find.text('FOLDER SCHEDULE'), findsOneWidget);

    // 4. Switch back to Folders View
    await tester.tap(find.text('Folders'));
    await tester.pumpAndSettle();

    expect(find.text('Tokyo Adventure'), findsOneWidget);

    // 5. Filter Trips
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();
    expect(find.text('Tokyo Adventure'), findsOneWidget);
  });

  testWidgets('TripDetailPage: timeline stops, interactive map, Google Maps info, and AI suggestions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final social = SocialData();
    final trip = TripData();
    String? navigatedChatId;

    await tester.pumpWidget(
      MaterialApp(
        home: ItineraryPage(
          trip: trip,
          data: social,
          onNavigateToChat: (chatId) {
            navigatedChatId = chatId;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Tap on Tokyo Adventure folder to open workspace
    await tester.tap(find.text('Tokyo Adventure'));
    await tester.pumpAndSettle();

    // Verify workspace top bar
    expect(find.text('Tokyo Adventure'), findsOneWidget);
    expect(find.text('Chat: Tokyo Squad'), findsOneWidget);

    // Verify day timeline header & stops
    expect(find.text('DAY 1'), findsOneWidget);
    expect(find.text('Shibuya & Harajuku Culture'), findsOneWidget);
    expect(find.text('Blue Bottle Coffee Shibuya'), findsOneWidget);
    expect(find.text('Shibuya Sky Observation Deck'), findsOneWidget);

    // Verify Interactive Map component is mounted
    expect(find.byType(InteractiveItineraryMap), findsOneWidget);

    // 2. Click a place to open rich PlaceDetailDialog
    await tester.tap(find.text('Blue Bottle Coffee Shibuya'));
    await tester.pumpAndSettle();

    expect(find.text('About this place'), findsOneWidget);
    expect(find.text('WHY TRIPNEST RECOMMENDS IT'), findsOneWidget);
    expect(find.text('View on Google Maps'), findsWidgets);

    // Close place dialog
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // 3. AI Assistant Panel suggestions
    expect(find.text('TripNest AI Assistant'), findsOneWidget);
    expect(find.text('PLANNING CHECK'), findsOneWidget);
    expect(find.text('Move Day 2 Start to 10:30 AM'), findsOneWidget);

    // Apply AI suggestion (Move Day 2 start to 10:30 AM)
    await tester.tap(find.text('Apply Change').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Itinerary Updated! "Move Day 2 Start to 10:30 AM" applied.'), findsOneWidget);

    // Switch to Day 2 and verify time shifted to 10:30
    await tester.tap(find.text('Day 2'));
    await tester.pumpAndSettle();
    expect(find.text('10:30'), findsWidgets);

    // 4. Test Chatroom Connection
    await tester.tap(find.text('Chat: Tokyo Squad'));
    await tester.pumpAndSettle();
    expect(navigatedChatId, 'tokyo_squad');

    // Dismiss any snackbar timer
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('Google Maps API: Static Maps URL, Directions URL, and PlaceDetailDialog linking', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final trips = TripRepository.getDemoTrips();
    final tokyoTrip = trips.first;
    final day1Stops = tokyoTrip.days.first.stops;

    // 1. Verify Google Maps Service URL Builders with User API Key
    final staticMapUrl = GoogleMapsService.getStaticMapUrl(stops: day1Stops, mapType: 'roadmap');
    expect(staticMapUrl, contains('AIzaSyAKFFCfV1F2nh5CePtaRJFR7QaS-F5IMbw'));
    expect(staticMapUrl, contains('maptype=roadmap'));
    expect(staticMapUrl, contains('markers=color:0xFB7185'));
    expect(staticMapUrl, contains('path=color:0xFB7185ee'));

    final directionsUrl = GoogleMapsService.getFullDayDirectionsUrl(day1Stops);
    expect(directionsUrl, contains('https://www.google.com/maps/dir/'));
    expect(directionsUrl, contains('origin=35.6635,139.7005'));
    expect(directionsUrl, contains('destination=35.661,139.7001'));

    final streetViewUrl = GoogleMapsService.getStreetViewUrl(lat: day1Stops.first.lat, lng: day1Stops.first.lng);
    expect(streetViewUrl, contains('https://maps.googleapis.com/maps/api/streetview'));
    expect(streetViewUrl, contains('AIzaSyAKFFCfV1F2nh5CePtaRJFR7QaS-F5IMbw'));

    // 2. Verify Verified Google Places details for Blue Bottle Shibuya
    final blueBottle = day1Stops.first;
    final googleData = GoogleMapsService.getPlaceDetails(blueBottle);
    expect(googleData.name, 'Blue Bottle Coffee - Shibuya Cafe');
    expect(googleData.rating, 4.6);
    expect(googleData.userRatingsTotal, 1665);
    expect(googleData.formattedAddress, contains('Shibuya, Jinnan'));
    expect(googleData.phoneNumber, '+81 3-6712-7390');
    expect(googleData.website, contains('bluebottlecoffee.jp'));

    // 3. Render PlaceDetailDialog and verify Google Maps elements
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaceDetailDialog(stop: blueBottle),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Google Maps Verified'), findsOneWidget);
    expect(find.text('GOOGLE MAPS INFORMATION'), findsOneWidget);
    expect(find.text(googleData.formattedAddress), findsOneWidget);
    expect(find.text('4.6'), findsOneWidget);
    expect(find.text('Street View 📷'), findsOneWidget);
    expect(find.text('View on Google Maps'), findsOneWidget);
    expect(find.text('Directions'), findsOneWidget);

    // Toggle Street View
    await tester.tap(find.text('Street View 📷'));
    await tester.pumpAndSettle();
    expect(find.text('Show Category'), findsOneWidget);

    // Scroll down in dialog to reveal bottom action buttons
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Tap View on Google Maps
    await tester.tap(find.text('View on Google Maps'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Opening Google Maps URL'), findsOneWidget);
  });
}

