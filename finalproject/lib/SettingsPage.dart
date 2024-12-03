// imports
import 'package:flutter/material.dart';
import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'appearance_page.dart' as appearance;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;

// defining the main settings page as a stateful widget, allowing for
// dynamic updating
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => MainSettings();
} // end SettingsPage

// MAIN PAGE CLASS
class MainSettings extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // creates our main header, Settings
        title: const Text("Settings",
            style: TextStyle(
              fontFamily: 'Teko',
              fontSize: 50,
            )),
      ),
      body: Center(
        child: Container(
          // custom padding and alignment throughout the page for uniformity
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // all children redirect to a different settings page
                  const Text("Account",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // redirect to Account page
                              builder: (context) => account.AccountPage()));
                    }, // end onPressed
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Notifications",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // redirect to Notifications page
                              builder: (context) =>
                                  notifications.NotificationsPage()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Appearance",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // redirect to Appearance page
                              builder: (context) =>
                                  appearance.AppearancePage()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Privacy and Safety",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // redirect to Privacy and Safety page
                              builder: (context) =>
                                  privsafety.PrivSafetyPage()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("About",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lora',
                      )),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              // redirect to About page
                              builder: (context) => aboutp.AboutPage()));
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
