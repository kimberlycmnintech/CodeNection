// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:wanderlog_clone/main.dart';

void main() {
  testWidgets('auth gate enters the home feed', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TripNestApp());

    // Verify that the auth gate is displayed.
    expect(find.text('Plan your next adventure'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);

    expect(find.text('Already have an account? Sign in'), findsOneWidget);
  });
}
