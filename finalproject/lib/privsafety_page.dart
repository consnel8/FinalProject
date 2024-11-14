import 'package:flutter/material.dart';


class privsafety_page extends StatefulWidget {
  const privsafety_page({super.key});

  @override
  State<privsafety_page> createState() => _PSPageState();
}

class _PSPageState extends State<privsafety_page>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy & Safety", style: TextStyle(
          fontFamily: 'Teko',
          fontSize: 50,
        ))
      ),
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
                  TODO:
                    - delete data (cloud)
                    - disable geolocation/enable geolocation
                  */
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
