import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:student_attendance_app/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen has a title, two text fields, and a button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verify that our screen has a title.
    expect(find.text('Login'), findsOneWidget);

    // Verify that our screen has two text fields.
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify that our screen has a login button.
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('LoginScreen shows error messages for empty fields', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap the login button without entering any text.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that our error messages are shown.
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
