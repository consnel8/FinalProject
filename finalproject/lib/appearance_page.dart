import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class appearance_page extends StatefulWidget {
  const appearance_page({super.key});

  @override
  State<appearance_page> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<appearance_page> {
  static const List<Widget> display = <Widget>[
    Text('Light'),
    Text('Dark'),
  ];

  final List<bool> _selectedDisplay = <bool>[true, false];
  bool vertical = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Appearance",
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
                      child: Text("Change Display?\n",
                          style: TextStyle(fontFamily: 'Lora', fontSize: 18)),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(50, 0, 30, 300),
                      child: ToggleButtons(
                          direction: vertical ? Axis.vertical : Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              for (int i = 0; i < 2; i++) {
                                _selectedDisplay[i] = i == index;
                              }
                              if (index == 0) {
                                AdaptiveTheme.of(context).setLight();
                              }
                              if (index == 1) {
                                AdaptiveTheme.of(context).setDark();
                              }
                            });
                          },
                          constraints: BoxConstraints(
                            minHeight: 40,
                            minWidth: 80,
                          ),
                          isSelected: _selectedDisplay,
                          children: display),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
