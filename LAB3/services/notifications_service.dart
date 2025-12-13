import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationsService {
  static Future<void> init() async {

    if (!kIsWeb) return;

    FirebaseMessaging messaging = FirebaseMessaging.instance;


    NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
        'Web notification permission: ${settings.authorizationStatus}');


    String? token = await messaging.getToken(
      vapidKey:
      'BN8iq6tvsqtZ7kZJLBnYctiBmtwSNSraTzWWQbdYTF3Ryu-ruW7NuV4CwRipkSYrAx3cTq243x3oNtvwPXG0GOk',
    );

    debugPrint('WEB FCM TOKEN: $token');


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        debugPrint('Foreground notification received:');
        debugPrint('Title: ${notification.title}');
        debugPrint('Body: ${notification.body}');
      }
    });
  }
}
