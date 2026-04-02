import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

class NotificationService {
  final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notifications.initialize(settings: initSettings);
  }

  Future<void> showMessageNotification({
    required String senderName,
    required String message,
    required bool isFirstTime,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'off_chat_messages',
      'Off Chat Messages',
      channelDescription: 'Notifications for new offline messages',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(message),
    );

    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final title = isFirstTime ? "New Connection: $senderName" : "Message from $senderName";

    await _notifications.show(
      id: message.hashCode,
      title: title,
      body: message,
      notificationDetails: details,
    );
  }
}

@Riverpod(keepAlive: true)
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}
