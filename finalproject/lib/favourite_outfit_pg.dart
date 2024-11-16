import 'package:flutter/material.dart';

import 'outfit_screen.dart';


class FavoriteOutfitsPage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteOutfits;

  FavoriteOutfitsPage({required this.favoriteOutfits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Outfits')),
      body: ListView.builder(
        itemCount: favoriteOutfits.length,
        itemBuilder: (context, index) {
          final outfit = favoriteOutfits[index];
          return ListTile(
            title: Text(outfit['title']),
            leading: Image.network(outfit['image']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OutfitScreen(outfit: outfit)),
              );
            },
          );
        },
      ),
    );
  }
}
