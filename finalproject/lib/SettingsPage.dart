import 'package:flutter/material.dart';
import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'appearance_page.dart' as appearance;
import 'access_page.dart' as access;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;
import 'colour_theme.dart' as colours;

import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

void main() { // will be removed on push
  runApp(const SPage());
} // end main
// will be removed


class SPage extends StatelessWidget { // will be removed on push
  const SPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: colours.AppTheme.light,
        dark: colours.AppTheme.dark,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          title: 'Settings',
          theme: colours.AppTheme.light,
          darkTheme: colours.AppTheme.dark,
          themeMode: ThemeMode.system,

          home: const SettingsPage(title: 'Settings Page'),
          routes: {
            '/privsafety_page': (context) => privsafety.privsafety_page(),
            '/notifications_page' : (context) => notifications.notifications_page(),
            '/appearance_page' : (context) => appearance.appearance_page(),
            '/access_page' : (context) => access.access_page(),
            '/account_page' : (context) => account.account_page(),
            '/about_page' : (context) => aboutp.about_page(),
          },
        )
    );
  }
} // end SPage
// will be removed

/*
TODO:
  - main settings page
    - search bar
    - Account (page)
    - Notifications (page)
    - Appearance (page)
    - Privacy and Safety (page)
    - Accessibility (page)
    - About (page)
    - Log Out (button)
    - Delete Account (button)
    - redirect to main page
*/

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});
  final String title;

  @override
  State<SettingsPage> createState() => _MainSettings();
}

// MAIN PAGE CLASS
class _MainSettings extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton( // redirect arrow to main page
              onPressed: () {
                /*
                TODO:
                  - redirect to main page
                */
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 50,
              ),
          ),
        ], // end actions
          title: Text("Settings", style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 50,
          )) // Settings title
      ),
      body: Center(
        child: Container (
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MaterialApp( // built for the search bar
                  home: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SearchAnchor(
                        builder: (BuildContext context, SearchController controller){
                          return SearchBar(
                            controller: controller,
                            padding:  const WidgetStatePropertyAll<EdgeInsets>(
                                EdgeInsets.symmetric(horizontal: 5.0)),
                            onTap: () {
                              controller.openView();
                            },
                            onChanged: (_) {
                              controller.openView();
                            },
                            leading: const Icon(Icons.search),
                          );
                        }, // end builder
                        suggestionsBuilder: (BuildContext context, SearchController controller) {

                          /*
                          TODO:
                            Code from SearchBar class docs (https://api.flutter.dev/flutter/material/SearchBar-class.html)
                            must be altered to display recommendations (and redirects) to searched for OR common searches
                          */

                          return List<ListTile>.generate(5, (int index) {
                            final String x = ' ';
                            return ListTile(
                              title: Text(x),
                              onTap: () {
                                setState(() {
                                  controller.closeView(x);
                                }); // end setState
                              }, // end onTap
                            );
                          });
                        }, // end suggestionsBuilder
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Account", style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lora',
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => account.account_page()));
                      }, // end onPressed
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Notifications", style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lora',
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => notifications.notifications_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Appearance", style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lora',
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => appearance.appearance_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Privacy and Safety", style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lora',
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => privsafety.privsafety_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Accessibility", style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lora',
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => access.access_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("About", style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lora',
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => aboutp.about_page()));
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.0),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container (
                    padding: const EdgeInsets.fromLTRB(120, 10, 0, 10),
                    child: TextButton(
                      onPressed: (){
                        // TODO: log out and redirect to log in page
                      },
                      child: Text("Log Out", style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lora',
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(85, 0, 0, 10),
                    child: TextButton(
                      onPressed: (){
                        // TODO: log out and redirect to delete confirm page
                      },
                      child: Text("Delete Account", style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lora',
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      )),
                    ),
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
