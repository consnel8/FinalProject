// imports
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
} // end NotificationsPage

class _NotificationsPageState extends State<NotificationsPage> {
  bool enabledisable =
      true; // tracks whether our notifications are enabled or disabled
  String enableSTR = "Enable"; // cosmetic, updates if enabling or disabling

  @override
  void initState() {
    super.initState();

    // Initialize the notification plugin
    PermissionHandler.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Define Android-specific settings (like using app icon for notifications)
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combine Android-specific initialization settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    //for both platforms
    // const InitializationSettings initializationSettings = InitializationSettings(
    //   android: initializationSettingsAndroid,
    //   iOS: initializationSettingsIOS,
    // );

    // Initialize the notification plugin with the defined settings
    PermissionHandler.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        // Handle notification tap event
        PermissionHandler.onSelectNotification(notificationResponse.payload);
        print("test");
        //you call other functions here
      },
    );

    // Request notification permission if running on Android 13+
    if (Platform.isAndroid) {
      PermissionHandler.requestNotificationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Notifications",
              style: TextStyle(
                fontFamily: 'Teko',
                fontSize: 50,
              ))),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: const Text(
                      "Check external Notification Permissions?",
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 17,
                      ),
                    ),
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: checkPerms,
                    child: const Text(
                      "Check Permissions",
                      style: TextStyle(
                        fontFamily: 'Lora',
                      ),
                    ),
                  ),
                ], // end children
              ),
              const Row(
                children: [
                  Text(
                    // explanation about what the button click does
                    "\nBy clicking the following buttons, you will be redirected"
                    " to your"
                    " device\nsettings page. System notifications for this app "
                    "can be enabled or\n"
                    "disabled here.",
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 10,
                    ),
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "$enableSTR In-App Notifications?",
                      // our cosmetic enable/disable text update
                      style: const TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 17,
                      ),
                    ),
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Switch(
                    value: enabledisable,
                    onChanged: (bool value) {
                      if (enabledisable == true) {
                        // when true, user wants to disable notifications
                        setState(() {
                          enabledisable = false;
                          enableSTR =
                              "Enable"; // sets what next action on switch will
                          // do
                          PermissionHandler.disableNotif();
                        });
                      } else if (enabledisable == false) {
                        // if the user is enabling notifications
                        setState(() {
                          /*
                          Users are given the option of enabling only daily
                          notifications, only weekly notifications, both sets of
                          notifications, or none at all.
                           */
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: const Text(
                                // user is given the choice to customize which
                                // notifications they want
                                "Choose which notifications to enable.",
                                style: TextStyle(
                                  fontFamily: 'Lora',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    PermissionHandler.enableDaily();
                                    const snackBar = SnackBar(
                                        content: Text(
                                            "Daily Notifications have been enabled"));
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }, // end onPressed
                                  child: const Text(
                                    "Only Daily Notifications",
                                    style: TextStyle(
                                      fontFamily: 'Lora',
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    PermissionHandler.enableWeekly();
                                    const snackBar = SnackBar(
                                        content: Text(
                                            "Weekly Notifications have been enabled"));
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }, // end onPressed
                                  child: const Text(
                                    "Only Weekly Notifications",
                                    style: TextStyle(
                                      fontFamily: 'Lora',
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    PermissionHandler.enableDaily();
                                    PermissionHandler.enableWeekly();
                                    const snackBar = SnackBar(
                                        content: Text("Daily and Weekly "
                                            "Notifications have been enabled"));
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }, // end onPressed
                                  child: const Text(
                                    "Daily and Weekly Notifications",
                                    style: TextStyle(
                                      fontFamily: 'Lora',
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, // end onPressed
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontFamily: 'Lora',
                                    ),
                                  ),
                                ),
                              ], // end actions
                            ),
                          ); // end ShowDialogue

                          // these two are flipping for the next switch update
                          enabledisable = true;
                          enableSTR = "Disable";
                        }); // end setState
                      } // end else if
                    }, // end onChanged
                  ),
                ], // end children
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // explanation about what the button click does
                    "\nChoose to enable and disable in-app notifications. When "
                    "enabling,\nchoose which "
                    "notifications to enable, if any.",
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 10,
                    ),
                  ),
                ], // end children
              ),
            ], // end children
          ),
        ),
      ),
    );
  } // end build

  Future<bool> checkPerms() async {
    // opens system settings for app permissions
    return await openAppSettings();
  } // end checkPerms
} // end _NotificationsPageState

// Notification processes were put into a separate class to account for use in
// other pages, making access easier

class PermissionHandler {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> enableDaily() async {
    // enables the daily notifications
    scheduleDailyNotification();
  } // end enableDaily

  static Future<void> disableDaily() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  } // end disableDaily

  static Future<void> enableWeekly() async {
    // enables the weekly notifications
    scheduleWeeklyNotification();
  } // end enableWeekly

  static Future<void> disableWeekly() async {
    await flutterLocalNotificationsPlugin.cancel(2);
  } // end disableWeekly

  static Future<void> disableNotif() async {
    // disables all notifications
    await flutterLocalNotificationsPlugin.cancelAll();
  } // end disableNotif

  static Future<void> onSelectNotification(String? payload) async {
    if (payload != null) {
      print("Notification payload $payload");
    } // end if
  } // end onSelectNotification

  static Future<void> scheduleDailyNotification() async {
    // daily notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notification',
      channelDescription: "Daily notification at preset time",
      importance: Importance.max,
      priority: Priority.high,
    ); // end AndroidNotificationDetails

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    ); // end platformChannelSpecifics

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      "Journaling Time!",
      "Let's pen in a new journal entry for today!",
      _nextInstanceOfTime(21, 30),
      platformChannelSpecifics,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    ); // end zonedSchedule
  } // end scheduleDailyNotification

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    } // end if
    return scheduledDate;
  } // end _nextInstanceOfTime

  static tz.TZDateTime _nextInstanceOfTime2(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 7));
    } // end if
    return scheduledDate;
  } // end _nextInstanceOfTime2

  static Future<void> scheduleWeeklyNotification() async {
    // weekly notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'weekly_channel_id',
      'Weekly Notification',
      channelDescription: "Weekly notification at preset time",
      importance: Importance.max,
      priority: Priority.high,
    ); // end Android Notification Details

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    ); // end NotificationDetails

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Time to Cook?",
      "How about we work on a new recipe for this week?",
      _nextInstanceOfTime2(15, 00),
      platformChannelSpecifics,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    ); // end zonedSchedule
  } // end scheduleWeeklyNotification

  static Future<void> requestNotificationPermission() async {
    // checks perms
    if (Platform.isAndroid) {
      if (await Permission.notification.isDenied) {
        PermissionStatus status = await Permission.notification.request();
        if (status.isDenied) {
          print("Notification permission denied");
        } else if (status.isGranted) {
          print("Notification permission granted");
        } // end else if
      } // end if
    } // end if
  } // end requestNotificationPermission
} // end Permission Handler
