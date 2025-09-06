import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// A background message handler.
// This must be a top-level function.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // A method to initialize the notification service.
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // Request permission to receive notifications.
    await requestPermission();

    // Handle incoming messages when the app is in the foreground.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Handle messages that are opened from a terminated state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // In a real app, you would navigate to a specific screen based on the message data.
      // For example:
      // navigatorKey.currentState!.pushNamed('/your_route', arguments: message.data);
    });

    // Set the background message handler.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    // Get the FCM token for this device.
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  // A method to request permission to receive notifications.
  Future<void> requestPermission() async {
    final NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }
}
