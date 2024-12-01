
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'outfit_screen.dart';

class OutfitSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> outfits;

  OutfitSearchDelegate({required this.outfits});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter results based on the search query
    final results = outfits
        .where((outfit) =>
    outfit['title'].toLowerCase().contains(query.toLowerCase()) ||
        (outfit['typeOfItem']?.toLowerCase() ?? '')
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final outfit = results[index];
        return ListTile(
          title: Text(outfit['title'] as String? ?? '',
              style: const TextStyle(fontFamily: 'Lora')),
          subtitle: Text(outfit['typeOfItem'] as String? ?? '',
              style: const TextStyle(fontFamily: 'Lora')),
          onTap: () {
            // Navigate to OutfitScreen using outfitId
            close(context, null); // Close search on item tap
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OutfitScreen(
                  outfitId: outfit['id'], // Pass outfitId to fetch data
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions based on the search query
    final suggestions = outfits
        .where((outfit) =>
    outfit['title'].toLowerCase().contains(query.toLowerCase()) ||
        (outfit['typeOfItem']?.toLowerCase() ?? '')
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final outfit = suggestions[index];
        return ListTile(
          title: Text(outfit['title'] as String? ?? '',
              style: const TextStyle(fontFamily: 'Lora')),
          subtitle: Text(outfit['typeOfItem'] as String? ?? '',
              style: const TextStyle(fontFamily: 'Lora')),
          onTap: () {
            // Update query and show results when suggestion is tapped
            query = outfit['title'];
            showResults(context);
          },
        );
      },
    );
  }
}
