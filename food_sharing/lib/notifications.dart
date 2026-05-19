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

    //request notification permissions:
    final androidImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if(androidImplementation != null) await androidImplementation.requestNotificationsPermission();

    final iosImplementation = _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if(iosImplementation != null) await iosImplementation.requestPermissions();
  }

  //FOR TESTING:
  static Future<void> showInstantNotif({required int id, required String postTitle, required DateTime pickupTime}) async{
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_alerts', 'Instant Alerts',
      channelDescription: 'Used for direct immediate application warnings.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());
    await _notificationsPlugin.show(
      id:id, 
      title: '🥘 Salo Pickup Reminder 🫕', 
      body: 'Your pickup for "$postTitle" is scheduled soon!', 
      notificationDetails: platformDetails
    );
  }



  static Future<void> schedulePickupReminder({required int id, required String postTitle, required DateTime pickupTime}) async{
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      pickupTime.subtract(const Duration(hours:1)), 
      tz.local
    );

    if(scheduledDate.isBefore(DateTime.now())){
      await showInstantNotif(id: id, postTitle: postTitle, pickupTime: pickupTime);
      return;
    }
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