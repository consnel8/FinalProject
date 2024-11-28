import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
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
            title: const Text("Appearance",
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
                      child: const Text("Change Display?\n",
                          style: TextStyle(fontFamily: 'Lora', fontSize: 18)),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                          constraints: const BoxConstraints(
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
