import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'appearance_page.dart' as appearance;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;
import 'SettingsPage.dart' as settingsmain;

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class access_page extends StatefulWidget {
  const access_page({super.key});

  @override
  State<access_page> createState() => _AccessPageState();
}

class _AccessPageState extends State<access_page>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accessibility", style: TextStyle(
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
                    - text size & change
                  */
                ],
              )
            ],
          )
        ),
      ),
    );
  } // end build
}
