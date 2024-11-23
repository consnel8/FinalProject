import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';


class notifications_page extends StatefulWidget {
  const notifications_page({super.key});

  @override
  State<notifications_page> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<notifications_page> {

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int _countdown = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid,);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        onSelectNotification(notificationResponse.payload);
      }
    );

    if (Platform.isAndroid) {
      _requestNotificationPermission();
    }

  } // end initState

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.notification.isDenied) {
        PermissionStatus status = await Permission.notification.request();
        if (status.isDenied) {
          print("Notification permission denied");
        }
        else if (status.isGranted) {
          print("Notification permission granted");
        }
      }
    }
  } // end requestNotifPerm

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      print("Notification payload $payload");
    }
  }

  Future<void> scheduleDailyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification',
      channelDescription: "Daily notification at preset time",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        "Journaling Time!",
        "Let\'s pen in a new journal entry for today!",
        _nextInstanceOfTime(21, 30),
        platformChannelSpecifics,
        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Notifications",
              style: TextStyle(
                fontFamily: 'Teko',
                fontSize: 50,
              ))),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "Check external Notification\nPermissions?\n",
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 30, 300),
                    child: ElevatedButton(
                      onPressed: checkPerms,
                      child: Text(
                        "Check Permissions",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              /*
                  TODO:
                    - in app notifications on/off
                  */
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkPerms() async {
    return await openAppSettings();
  }
}
