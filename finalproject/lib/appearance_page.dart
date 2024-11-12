import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'access_page.dart' as access;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;
import 'SettingsPage.dart' as settingsmain;

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class appearance_page extends StatefulWidget {
  const appearance_page({super.key});

  @override
  State<appearance_page> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<appearance_page>{

  static const List<Widget> display = <Widget>[
    Text('Light'),
    Text('System'),
    Text('Dark')
  ];

  final List<bool> _selectedDisplay = <bool>[true, false, false];
  bool vertical = false;


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
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text("Change Display?\n", style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18
                    )),
                  ),
                ],
              ),
              Row(
                children: <Widget> [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 30, 300),
                    child: ToggleButtons(
                        direction: vertical ? Axis.vertical : Axis.horizontal,
                        onPressed: (int index){
                          setState(() {
                            for (int i = 0; i < 3; i++){
                              _selectedDisplay[i] = i == index;
                            }
                            if (index == 0){
                              AdaptiveTheme.of(context).setLight();
                            }
                            if (index == 1){
                              AdaptiveTheme.of(context).setSystem();
                            }
                            if (index == 2){
                              AdaptiveTheme.of(context).setDark();
                            }
                          });
                        },
                        constraints: BoxConstraints(
                          minHeight: 40,
                          minWidth: 80,
                        ),
                        isSelected: _selectedDisplay,
                        children: display
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
