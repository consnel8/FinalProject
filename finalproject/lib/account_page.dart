import 'package:flutter/material.dart';

class account_page extends StatefulWidget {
  const account_page({super.key});

  @override
  State<account_page> createState() => _AccountPageState();
}

class _AccountPageState extends State<account_page>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account", style: TextStyle(
          fontFamily: 'Teko',
          fontSize: 50,
        ))
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      "Delete Data?",
                      style: TextStyle(
                        fontFamily: 'Lora',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: deletionAlert,
                      child: const Text(
                          "Begin Data Deletion",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        ),
                      ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(" "),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "By clicking the above button, you agree to the complete deletion of\n"
                        "your data off the Life Palette"
                        "app. All recipes, wardrobe items, journal\n"
                        "entries, or otherwise saved data will be completely wiped. This data\n"
                        "will not be able to be recovered.\n",
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 10,
                    ),
                  ),
                ],
              )
            ], // end children
          ),
        ),
      ),
    );
  } // end build

  void deletionAlert() {
       showDialog(
           context: context,
           builder: (BuildContext context) => AlertDialog(
             title: const Text(
               "Delete Data?",
               style: TextStyle(
                 fontFamily: 'Lora',
                 fontSize: 18,
               ),
             ),
             content: const Text("Are you sure you'd like to delete your data? This action cannot be undone."),
             actions: <Widget>[
               TextButton(
                   onPressed: () {
                     Navigator.pop(context);
                   },
                   child: Text(
                       "Cancel",
                     style: TextStyle(
                       fontFamily: 'Lora',
                       fontSize: 18,
                     ),
                   ),
               ),
               TextButton(
                   onPressed: () {

                     /*
                     TODO:
                      Implement cloud deletion, either occurring here
                      or redirecting to process elsewhere before returning,
                      closing this pop up in the process and potentially giving the user a pop up
                      or notification to explain it is finished.
                     */

                   },
                   child: Text(
                     "Proceed",
                     style: TextStyle(
                       fontFamily: 'Lora',
                       fontSize: 18,
                     ),
                   ),
               ),
             ],
           ),
       );
  }
} // end account_page
