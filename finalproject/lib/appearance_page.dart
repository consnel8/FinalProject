import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'access_page.dart' as access;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;
import 'SettingsPage.dart' as settingsmain;

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class appearance_page extends StatefulWidget {
  const appearance_page({super.key});

  @override
  State<appearance_page> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<appearance_page>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appearance", style: TextStyle(
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
                    - dark mode/light mode
                  */
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
