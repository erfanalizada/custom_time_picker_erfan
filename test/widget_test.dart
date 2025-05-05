// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_time_picker_erfan/custom_time_picker_erfan.dart';

void main() {
  testWidgets('Time Picker shows and selects time', (
    WidgetTester tester,
  ) async {
    // Build a MaterialApp with a button to show the time picker
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showTimePickerErfan(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 30),
                  );
                },
                child: const Text('Show Time Picker'),
              );
            },
          ),
        ),
      ),
    );

    // Verify the button is present
    expect(find.text('Show Time Picker'), findsOneWidget);

    // Tap the button to show the time picker
    await tester.tap(find.text('Show Time Picker'));
    await tester.pumpAndSettle();

    // Verify the time picker dialog is shown
    expect(find.text('Choose Time'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);

    // Test cancel button
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify the dialog is dismissed
    expect(find.text('Choose Time'), findsNothing);
  });
}
