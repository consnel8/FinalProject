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
                            AND colours fixed. Potentially swap to textfield instead of SearchBar.
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
                        // TODO: log out and redirect to log in page IF implemented
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
