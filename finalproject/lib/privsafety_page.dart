import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class privsafety_page extends StatefulWidget {
  const privsafety_page({super.key});

  @override
  State<privsafety_page> createState() => _PSPageState();
}

class _PSPageState extends State<privsafety_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Privacy & Safety",
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
                  /*
                  With flutter, permissions cannot be retroactively applied or denied.
                  This must be done through system settings, geolocation redirect will redirect
                  users wishing to change their privacy permissions to their system settings
                  */

                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "Check Geolocation Permissions?\n",
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 30, 300),
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
              )
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
