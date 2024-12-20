
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'outfit_screen.dart';
import 'outfit_model.dart';
class OutfitSearchDelegate extends SearchDelegate {
  final List<Outfit> outfits;

  OutfitSearchDelegate({required this.outfits});
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white, // Light background for the search bar
        iconTheme: const IconThemeData(color: Colors.black), // Black icons
        titleTextStyle: const TextStyle(
          color: Colors.black, // Black text in the search bar
          fontSize: 18,
          fontFamily: 'Lora',
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey), // Hint text color
      ),
    );
  }

  @override
  TextStyle get searchFieldStyle => const TextStyle(
    color: Colors.black, // Black text for input
    fontSize: 16,
    fontFamily: 'Lora',
  );

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
      return Center(
        child: Text(
          "The item \"$query\" you're searching for isn't in your wardrobe.\nTry searching for something else.",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.blue,
            fontFamily: 'Lora',
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
          title: Text(outfit.title, style: const TextStyle(fontFamily: 'Lora', )),
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


