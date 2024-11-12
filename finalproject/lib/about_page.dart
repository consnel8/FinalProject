import 'privsafety_page.dart' as privsafety;
import 'notifications_page.dart' as notifications;
import 'appearance_page.dart' as appearance;
import 'access_page.dart' as access;
import 'account_page.dart' as account;
import 'SettingsPage.dart' as settingsmain;

import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class about_page extends StatefulWidget {
  const about_page({super.key});

  @override
  State<about_page> createState() => _AboutPageState();
}

class _AboutPageState extends State<about_page>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: Text("About", style: TextStyle(
          fontFamily: 'Teko',
          fontSize: 50,
        ))
      ),
      body: Center(
        child: Container (
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 300),
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: Text(
                      "About The Team",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lora',
                      ),
                    ),
                  ),
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("\n"),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text("Megan Brandreth", style: TextStyle(fontFamily: 'Lora',)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(38, 0, 10, 10),
                    child: Text("GitHub: illxso", style: TextStyle(fontFamily: 'Lora',)),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text("Eisha Rizvi", style: TextStyle(fontFamily: 'Lora',)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(82, 0, 10, 10),
                    child: Text("GitHub: eisharizvi", style: TextStyle(fontFamily: 'Lora',)),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text("Syeda Muqadas", style: TextStyle(fontFamily: 'Lora',)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 10, 10),
                    child: Text("GitHub: Syeda-Muqadas", style: TextStyle(fontFamily: 'Lora',)),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text("Connor Snelgrove", style: TextStyle(fontFamily: 'Lora',)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(33, 0, 10, 10),
                    child: Text("GitHub: consnel8", style: TextStyle(fontFamily: 'Lora',)),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text("Zara Farrukh", style: TextStyle(fontFamily: 'Lora',)),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(68, 0, 10, 10),
                    child: Text("GitHub: zarafarrukh", style: TextStyle(fontFamily: 'Lora',)),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text(
                        "\nThis project was created for Ontario Tech\n"
                        "University's CSCI 4100 Mobile Development course\n"
                        "during the fall of 2024."),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(40, 10, 10, 0),
                    child: const Image(image: AssetImage('images/Life_Palette_logo.png'), width: 280, height: 150),
                  ),
                ],
              ),
            ], // end children
          ),
        ),
      ),
    );
  } // end build
} // end about_page