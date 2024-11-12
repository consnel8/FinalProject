import 'package:flutter/material.dart';
import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'appearance_page.dart' as appearance;
import 'access_page.dart' as access;
import 'account_page.dart' as account;
import 'about_page.dart' as aboutp;

import 'package:google_fonts/google_fonts.dart';

void main() { // will be removed on final push after complete integration
  runApp(const SPage());
} // end main
// will be removed

class SPage extends StatelessWidget { // will be removed on final push after complete integration
  const SPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( // theme data will be necessary for the main application
        scaffoldBackgroundColor: const Color(0xFFEFEBE9),
        dialogBackgroundColor: const Color(0xFFEFEBE9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFEFEBE9),),
        useMaterial3: true,
        textTheme: TextTheme(
          titleLarge: GoogleFonts.teko(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.teko(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      home: const SettingsPage(title: 'Settings Page'),
      routes: {
        '/privsafety_page': (context) => privsafety.privsafety_page(),
        '/notifications_page' : (context) => notifications.notifications_page(),
        '/appearance_page' : (context) => appearance.appearance_page(),
        '/access_page' : (context) => access.access_page(),
        '/account_page' : (context) => account.account_page(),
        '/about_page' : (context) => aboutp.about_page(),
      },
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
                color: Colors.black,
                size: 50,
              )
          )
        ], // end actions
          title: Text("Settings") // Settings title
        /*
        TODO:
          - title size and font
          - change colours
        */
      ),
      body: Center(
        child: Container (
          color: const Color(0xFFEFEBE9),
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: MaterialApp( // built for the search bar
                  home: Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SearchAnchor(
                        viewBackgroundColor: const Color(0xFFEFEBE9),
                        viewSurfaceTintColor: const Color(0xFFEFEBE9),
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
                    fontSize: 20,
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => account.account_page()));
                       // Navigator.push(context, _accountPage());
                      }, // end onPressed
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Notifications", style: TextStyle(
                    fontSize: 20,
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => notifications.notifications_page()));
                      //Navigator.push(context, _notificationsPage());
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Appearance", style: TextStyle(
                    fontSize: 20,
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => appearance.appearance_page()));
                     // Navigator.push(context, _appearancePage());
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Privacy and Safety", style: TextStyle(
                    fontSize: 20,
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => privsafety.privsafety_page()));
                     // Navigator.push(context, _privsafetyPage());
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Accessibility", style: TextStyle(
                    fontSize: 20,
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => access.access_page()));
                     // Navigator.push(context, _accessPage());
                    }, // end press
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("About", style: TextStyle(
                    fontSize: 20,
                  )),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => aboutp.about_page()));
                      //Navigator.push(context, _aboutPage());
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
                    padding: const EdgeInsets.fromLTRB(120, 0, 0, 10),
                    child: TextButton(
                      onPressed: (){
                        // TODO: log out and redirect to log in page
                      },
                      child: Text("Log Out", style: TextStyle(
                        fontSize: 15,
                      )),
                    ),
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(100, 0, 0, 10),
                    child: TextButton(
                      onPressed: (){
                        // TODO: log out and redirect to delete confirm page
                      },
                      child: Text("Delete Account", style: TextStyle(
                        fontSize: 15,
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
