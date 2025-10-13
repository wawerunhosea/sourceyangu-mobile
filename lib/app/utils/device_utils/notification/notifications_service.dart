// Push notifications, local alerts

// ignore_for_file: unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sourceyangu/app/utils/device_utils/permission_manager.dart';

class NotificationService {
  final _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    final granted = await PermissionManager.ensure(
      Permission.notification,
      'notification_permission',
    );
    if (!granted) return;
    final token = await _messaging.getToken();

    //TODO: Send token to backend
  }
}
