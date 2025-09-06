import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_attendance_app/screens/registration_screen.dart';

void main() {
  testWidgets('RegistrationScreen has a title, two text fields, and a button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

    // Verify that our screen has a title.
    expect(find.text('Register'), findsOneWidget);

    // Verify that our screen has two text fields.
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify that our screen has a register button.
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('RegistrationScreen shows error messages for empty fields', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));

    // Tap the register button without entering any text.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that our error messages are shown.
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });
}
