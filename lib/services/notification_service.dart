import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/grocery_item.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    await Permission.notification.request();
  }

  static Future<void> scheduleExpiryNotification(GroceryItem item) async {
    if (item.daysLeft <= 1 && item.daysLeft >= 0) {
      await _notifications.show(
        item.id.hashCode,
        'Grocery Expiry Alert!',
        '${item.name} expires ${item.daysLeft == 0 ? 'today' : 'tomorrow'}!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'grocery_expiry',
            'Grocery Expiry Notifications',
            channelDescription: 'Notifications for grocery items expiring soon',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> scheduleAllNotifications(List<GroceryItem> items) async {
    for (final item in items) {
      await scheduleExpiryNotification(item);
    }
  }
}