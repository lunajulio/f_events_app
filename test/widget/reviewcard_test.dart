import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_app/widget/reviewcard.dart';
import 'package:event_app/models/review.dart';

void main() {
  testWidgets('ReviewCard displays review details correctly', (WidgetTester tester) async {
    // Mock review data
    final review = Review(
      comment: 'This is a test review.',
      rating: 4.5,
      createdAt: DateTime(2025, 5, 2),
    );

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReviewCard(review: review),
        ),
      ),
    );

    // Verify the review comment is displayed
    expect(find.text('This is a test review.'), findsOneWidget);

    // Verify the review date is displayed
    expect(find.text('2/5/2025'), findsOneWidget);

    // Verify the correct number of stars is displayed
    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsNWidgets(0));
  });
}