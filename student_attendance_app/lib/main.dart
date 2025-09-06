import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:student_attendance_app/services/notification_service.dart';
import 'package:student_attendance_app/widgets/auth_wrapper.dart';

void main() async {
  // Ensure that the Flutter binding is initialized before calling Firebase.initializeApp.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Create a global key for the navigator.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Initialize the notification service.
    NotificationService().initialize(navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Student Attendance App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // The initial screen of the app will be the AuthWrapper.
      home: const AuthWrapper(),
    );
  }
}
