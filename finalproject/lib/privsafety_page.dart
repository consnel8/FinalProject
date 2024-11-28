import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PrivSafetyPage extends StatefulWidget {
  const PrivSafetyPage({super.key});

  @override
  State<PrivSafetyPage> createState() => _PSPageState();
}

class _PSPageState extends State<PrivSafetyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Privacy & Safety",
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
                  /*
                  With flutter, permissions cannot be retroactively applied or denied.
                  This must be done through system settings, geolocation redirect will redirect
                  users wishing to change their privacy permissions to their system settings
                  */

                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: const Text(
                      "Check Geolocation Permissions?",
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
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
                ],
              ),
              const Row(
                children: [
                  Text(" "),
                ],
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "By clicking the following buttons, you will be redirected to your"
                    " device\nsettings page. From here, you can enable or disable your location.",
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
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
