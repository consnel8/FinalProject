import 'package:final_project/pages/outfits_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wardrobe App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: OutfitDashboardPage(),
    );
  }
}