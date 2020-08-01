import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._();
  static NotificationManager get instance => _instance;

  final FirebaseMessaging _messaging = FirebaseMessaging();

  NotificationManager._();

  Future<String> getToken() {
    _messaging.requestNotificationPermissions();
    _messaging.configure();

    return _messaging.getToken();
  }
}