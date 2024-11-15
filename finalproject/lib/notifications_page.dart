import 'package:flutter/material.dart';

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

                  TODO
                    - out of app notifications?
                    - general notifications on/off
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
