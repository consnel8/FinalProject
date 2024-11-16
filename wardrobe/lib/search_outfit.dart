import 'package:flutter/material.dart';

import 'outfit_screen.dart';



class OutfitSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> outfits;

  OutfitSearchDelegate({required this.outfits});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = outfits
        .where((outfit) => outfit['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final outfit = results[index];
        return ListTile(
          title: Text(outfit['title'] as String? ?? ''),
          onTap: () {
            close(context, null); // Close search on item tap
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OutfitScreen(outfit: outfit)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = outfits
        .where((outfit) => outfit['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final outfit = suggestions[index];
        return ListTile(
          title: Text(outfit['title'] as String? ?? ''),
          onTap: () {
            query = outfit['title'];
            showResults(context); // Show results when suggestion is tapped
          },
        );
      },
    );
  }
}
