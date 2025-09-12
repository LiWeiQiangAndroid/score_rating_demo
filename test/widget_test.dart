// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:score_rating_demo/main.dart';

void main() {
  testWidgets('Score rating app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScoreRatingApp());

    // Verify that we have the app bar with correct title.
    expect(find.text('五维雷达图Demo'), findsOneWidget);
    
    // Verify that we have at least one score displayed.
    expect(find.text('95'), findsOneWidget);
  });
}
