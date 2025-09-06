import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // An instance of FirebaseAuth.
  final FirebaseAuth _auth;

  // A constructor that accepts an instance of FirebaseAuth.
  // This allows us to inject a mock instance for testing.
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  // A method to sign in with email and password.
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Re-throw the exception to be handled by the UI.
      rethrow;
    }
  }

  // A method to create a new user with email and password.
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // Re-throw the exception to be handled by the UI.
      rethrow;
    }
  }

  // A method to sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // A stream to listen for changes in the authentication state.
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
