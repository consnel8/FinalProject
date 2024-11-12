import 'privsafety_page.dart' as privsafety;
import 'appearance_page.dart' as appearance;
import 'access_page.dart' as access;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;
import 'SettingsPage.dart' as settingsmain;

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class notifications_page extends StatefulWidget {
  const notifications_page({super.key});

  @override
  State<notifications_page> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<notifications_page>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(
          fontFamily: 'Teko',
          fontSize: 50,
        ))
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*
                  TODO:
                    - in app notifications on/off
                  */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
