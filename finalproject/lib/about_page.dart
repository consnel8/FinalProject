import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("About",
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
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: const Text(
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
              const Row(
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
                    child: const Text("Megan Brandreth",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(38, 0, 10, 10),
                    child: const Text("GitHub: mbrandreth",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: const Text("Eisha Rizvi",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(82, 0, 10, 10),
                    child: const Text("GitHub: eisharizvi",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: const Text("Syeda Muqadas",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(50, 0, 10, 10),
                    child: const Text("GitHub: Syeda-Muqadas",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: const Text("Connor Snelgrove",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(33, 0, 10, 10),
                    child: const Text("GitHub: consnel8",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: const Text("Zara Farrukh",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(68, 0, 10, 10),
                    child: const Text("GitHub: zarafarrukh",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        )),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: const Text(
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
                    child: const Image(
                        image: AssetImage('assets/logo.png'),
                        width: 280,
                        height: 150),
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
