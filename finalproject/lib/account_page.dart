import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'appearance_page.dart' as appearance;
import 'access_page.dart' as access;
import 'about_page.dart' as aboutp;
import 'SettingsPage.dart' as settingsmain;

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class account_page extends StatefulWidget {
  const account_page({super.key});

  @override
  State<account_page> createState() => _AccountPageState();
}

class _AccountPageState extends State<account_page>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account", style: TextStyle(
          fontFamily: 'Teko',
          fontSize: 50,
        ))
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 300),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*
                  TODO:
                    - User Name
                    - Username & change username
                    - Password & change password
                  */
                ], // end children
              ),
            ], // end children
          ),
        ),
      ),
    );
  } // end build
} // end account_page
