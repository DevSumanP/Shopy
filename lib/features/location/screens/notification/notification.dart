// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> createNotificationChannel() async {
//   const AndroidNotificationChannel androidNotificationChannel =
//       AndroidNotificationChannel(
//     'background_location_channel', // Channel ID
//     'Background Location Service', // Channel name
//     description: 'This channel is used for background location updates.',
//     importance: Importance.high,
//   );

//   const AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//     'background_location_channel', // Channel ID
//     'Background Location Service', // Channel name
//     channelDescription: 'This channel is used for background location updates.',
//     importance: Importance.high,
//     priority: Priority.high,
//     showWhen: false,
//   );

//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidNotificationDetails);

//   // Initialize the plugin (can be done once in main or before creating the channel)
//   await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
//     android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//   ));

//   // Create the notification channel
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(androidNotificationChannel);

//   // Show a test notification
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'Background Location Tracking',
//     'Your app is running in the background',
//     platformChannelSpecifics,
//   );
// }
