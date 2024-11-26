import 'package:flutter/material.dart';
import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'appearance_page.dart' as appearance;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => MainSettings();
}

// MAIN PAGE CLASS
class MainSettings extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",
            style: TextStyle(
              fontFamily: 'Teko',
              fontSize: 50,
            )),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Account",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => account.account_page()));
                    }, // end onPressed
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Notifications",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  notifications.notifications_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Appearance",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  appearance.appearance_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Privacy and Safety",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  privsafety.privsafety_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("About",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => aboutp.about_page()));
                    }, // end press
                  ),
                ], // end children
              ),
            ], // end children
          ),
        ),
      ),
    );
  } // end build
} // end _MainSettings
