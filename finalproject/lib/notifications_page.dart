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
  bool enabledisable = true;
  bool dailyTrue = false;
  bool weeklyTrue = false;
  String enableSTR = "Enable";

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 30, 0),
                    child: Text(
                      "$enableSTR In-App Notifications?\n",
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 30, 0),
                    child: Switch(
                      value: enabledisable,
                      onChanged: (bool value) {
                        if (enabledisable == true) {
                          setState(() {
                            enabledisable = false;
                            enableSTR = "Enable";
                            PermissionHandler.disableNotif();
                          });
                        } else if (enabledisable == false) {
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: Text(
                                    "Choose which notifications to enable."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      PermissionHandler.enableDaily();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Only Daily Notifications"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      PermissionHandler.enableWeekly();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Only Weekly Notifications"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      PermissionHandler.enableDaily();
                                      PermissionHandler.enableWeekly();
                                      Navigator.pop(context);
                                    },
                                    child:
                                        Text("Daily and Weekly Notifications"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Nevermind"),
                                  ),
                                ],
                              ),
                            );
                            enabledisable = true;
                            enableSTR = "Disable";
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
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

class PermissionHandler {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> enableDaily() async {
    scheduleDailyNotification();
  }

  static Future<void> enableWeekly() async {
    scheduleWeeklyNotification();
  }

  static Future<void> disableNotif() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      print("Notification payload $payload");
    }
  }

  static Future<void> scheduleDailyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _nextInstanceOfTime2(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 7));
    }
    return scheduledDate;
  }

  static Future<void> scheduleWeeklyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'weekly_channel_id',
      'Weekly Notification',
      channelDescription: "Weekly notification at preset time",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Time to Cook?",
      "How about we work on a new recipe for this week?",
      _nextInstanceOfTime2(15, 00),
      platformChannelSpecifics,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  static Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.notification.isDenied) {
        PermissionStatus status = await Permission.notification.request();
        if (status.isDenied) {
          print("Notification permission denied");
        } else if (status.isGranted) {
          print("Notification permission granted");
        }
      }
    }
  } // end requestNotifPerm
}
