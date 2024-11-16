import 'package:flutter/material.dart';


class OutfitScreen extends StatelessWidget {
  final Map<String, dynamic> outfit;

  OutfitScreen({required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(outfit['title'])),
      body: Column(
        children: [
          Image.network(outfit['image']),
          SizedBox(height: 10),
          Text(outfit['title'], style: TextStyle(fontSize: 24)),
          SizedBox(height: 10),
          Text(outfit['category'], style: TextStyle(fontSize: 18)),
          // Add more outfit details later will add more functioanlities
        ],
      ),
    );
  }
}
