import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class Notifications {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async{
    tz_data.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation('Asia/Manila'));

    //support for both android and ios platforms:
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notificationsPlugin.initialize(settings: settings);
  }

  static Future<void> schedulePickupReminder({required int id, required String postTitle, required DateTime pickupTime}) async{
    //remind 1 hour before pickup time:
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      DateTime.now().add(const Duration(seconds: 5)),
      //pickupTime.subtract(const Duration(hours:1)), 
      tz.local
    );

    if(scheduledDate.isBefore(DateTime.now())) return;  //don't schedule if reminder time has already passed

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'pickup_reminders', 'Pickup Reminders',
      channelDescription: 'Alerts sent 1 hour before scheduled pickup.',
      importance: Importance.max,
      priority: Priority.high
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

    await _notificationsPlugin.zonedSchedule(
      id: id, 
      title:'🥘Salo Pickup Reminder🫕', 
      body: 'Your pickup for "$postTitle" is in 1 hour!',
      scheduledDate: scheduledDate,
      notificationDetails: platformDetails, 
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}