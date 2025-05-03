import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:event_app/widget/add_review_dialog.dart';

void main() {
  testWidgets('AddReviewDialog allows submitting a review', (WidgetTester tester) async {
    double? submittedRating;
    String? submittedComment;

    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddReviewDialog(
            onSubmit: (rating, comment) {
              submittedRating = rating;
              submittedComment = comment;
            },
          ),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Escribir reseña'), findsOneWidget);
    expect(find.text('Enviar'), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsNWidgets(5));

    // Tap on the third star
    await tester.tap(find.byIcon(Icons.star_border).at(2));
    await tester.pump();

    // Verify the stars update
    expect(find.byIcon(Icons.star), findsNWidgets(3));
    expect(find.byIcon(Icons.star_border), findsNWidgets(2));

    // Enter a comment
    await tester.enterText(find.byType(TextField), 'Great event!');
    await tester.pump();

    // Verify the comment is entered
    expect(find.text('Great event!'), findsOneWidget);

    // Tap the submit button
    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    // Verify the onSubmit callback is called with correct values
    expect(submittedRating, 3.0);
    expect(submittedComment, 'Great event!');
  });
}