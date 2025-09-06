import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:student_attendance_app/services/auth_service.dart';

void main() {
  group('AuthService', () {
    // Create a mock FirebaseAuth instance.
    final auth = MockFirebaseAuth();
    // Create an instance of the AuthService with the mock FirebaseAuth instance.
    final authService = AuthService(auth: auth);

    test('signInWithEmailAndPassword signs in a user', () async {
      // Sign in the mock user.
      final user = await authService.signInWithEmailAndPassword(
        'test@example.com',
        'password',
      );
      // Check that the user is signed in.
      expect(auth.currentUser, isNotNull);
      expect(auth.currentUser!.email, 'test@example.com');
    });

    test('createUserWithEmailAndPassword creates a user', () async {
      // Create the mock user.
      final user = await authService.createUserWithEmailAndPassword(
        'test@example.com',
        'password',
      );
      // Check that the user is created.
      expect(auth.currentUser, isNotNull);
      expect(auth.currentUser!.email, 'test@example.com');
    });

    test('signOut signs out a user', () async {
      // Sign in the mock user.
      await authService.signInWithEmailAndPassword(
        'test@example.com',
        'password',
      );
      // Sign out the user.
      await authService.signOut();
      // Check that the user is signed out.
      expect(auth.currentUser, isNull);
    });
  });
}
