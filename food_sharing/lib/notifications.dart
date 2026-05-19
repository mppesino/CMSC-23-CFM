import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data; 
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class Notifications {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async{
  tz_data.initializeTimeZones();

  final timezoneInfo =
    await FlutterTimezone.getLocalTimezone();

  tz.setLocalLocation(
    tz.getLocation(timezoneInfo.identifier),
  );  

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
   const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      channelDescription: 'Notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id:id, 
      title: '🥘 Salo Pickup Reminder 🫕', 
      body: 'Your pickup for "$postTitle" is scheduled soon!', 
      notificationDetails: details
    );

  }

  static Future<void> showNotificationTest() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      channelDescription: 'Notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id:0,
      title: 'Notification Scheduled',
      body: 'Food item pick-up time has been scheduled',
      notificationDetails: details,
    );
  }

static Future<void> schedulePickupReminder({
  required int id,
  required String postTitle,
  required DateTime pickupTime,
}) async {

  final scheduledDate = tz.TZDateTime.from(
    pickupTime.subtract(const Duration(hours: 1)),
    tz.local,
  );

  print("NOW: ${tz.TZDateTime.now(tz.local)}");
  print("SCHEDULED: $scheduledDate");

  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'pickup_reminders',
    'Pickup Reminders',
    channelDescription:
        'Alerts sent before scheduled pickup.',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await _notificationsPlugin.zonedSchedule(
    id:id,
    title:'🥘Salo Pickup Reminder🫕',
    body:'Your pickup for "$postTitle" is in 1 hour!',
    scheduledDate:  scheduledDate,
    notificationDetails: platformDetails,
    androidScheduleMode:
        AndroidScheduleMode.exactAllowWhileIdle,
  );

  print("Scheduled successfully");
}

}