import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:student_attendance_app/screens/login_screen.dart';
import 'package:student_attendance_app/screens/student_dashboard_screen.dart';
import 'package:student_attendance_app/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using a StreamProvider to listen to the authentication state changes.
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: Consumer<User?>(
        builder: (_, user, __) {
          // If the user is not logged in, show the LoginScreen.
          if (user == null) {
            return const LoginScreen();
          }
          // If the user is logged in, show the StudentDashboardScreen.
          return const StudentDashboardScreen();
        },
      ),
    );
  }
}
