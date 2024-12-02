
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'outfit_screen.dart';
import 'outfit_model.dart';
class OutfitSearchDelegate extends SearchDelegate {
  final List<Outfit> outfits;

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
    final results = outfits.where((outfit) {
      return outfit.title.toLowerCase().contains(query.toLowerCase()) ||
          outfit.typeOfItem.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      // Show a message if no results are found
      return Center(
        child: Text( "The item ${query} you're searching for isn't in your wardrobe.\nTry searching for something else.",
          textAlign: TextAlign.center, style
              : TextStyle( fontSize: 16, color: Colors.black, fontFamily: 'Lora',
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final outfit = results[index];
        return ListTile(
          title: Text(outfit.title, style: const TextStyle(fontFamily: 'Lora')),
          subtitle: Text(outfit.typeOfItem, style: const TextStyle(fontFamily: 'Lora')),
          onTap: () {
            // Navigate to OutfitScreen with the Outfit object
            close(context, null); // Close search
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OutfitScreen(outfit: outfit),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = outfits.where((outfit) {
      return outfit.title.toLowerCase().contains(query.toLowerCase()) ||
          outfit.typeOfItem.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final outfit = suggestions[index];
        return ListTile(
          title: Text(outfit.title, style: const TextStyle(fontFamily: 'Lora')),
          subtitle: Text(outfit.typeOfItem, style: const TextStyle(fontFamily: 'Lora')),
          onTap: () {
            // Update the query and show results
            query = outfit.title;
            showResults(context);
          },
        );
      },
    );
  }
}


