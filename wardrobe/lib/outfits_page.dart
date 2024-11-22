import 'package:final_project/pages/outfit_builder.dart';
import 'package:final_project/pages/outfit_editer.dart';
import 'package:flutter/material.dart';

import 'favourite_outfit_pg.dart';
import 'outfit_screen.dart';


class OutfitDashboardPage extends StatefulWidget {
  @override
  _OutfitDashboardPageState createState() => _OutfitDashboardPageState();
}

class _OutfitDashboardPageState extends State<OutfitDashboardPage> {
  final List<String> categories = ['All Categories', 'Formal', 'Casual', 'Dresses', 'Single Item'];
  String selectedCategory = 'All Categories';
  bool editMode = false;
  List<Map<String, dynamic>> outfits = [
    {'title': 'Winter Coat', 'category': 'Formal',
      'image': 'https://via.placeholder.com/150',
      'isFavorite': false},
    {'title': 'Casual T-Shirt', 'category': 'Casual', 'image': 'https://via.placeholder.com/150', 'isFavorite': false},
  ];

  List<Map<String, dynamic>> favoriteOutfits = []; // List to store favorite outfits

  void navigateToOutfitBuilder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutfitBuilderPage(
          onSave: (newOutfit) {
            setState(() {
              outfits.add(newOutfit);
            });
          },
        ),
      ),
    );
  }

  void toggleFavorite(int index) {
    setState(() {
      outfits[index]['isFavorite'] = !outfits[index]['isFavorite'];
      if (outfits[index]['isFavorite']) {
        favoriteOutfits.add(outfits[index]); // Adding to favorites
      } else {
        favoriteOutfits.removeAt(
            favoriteOutfits.indexOf(outfits[index])); // Removing from favorites
      }
    });
  }
  void addOutfit(Map<String, dynamic> outfit) {
    setState(() {
      outfits.add(outfit); // Adding new outfit to the list
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Outfit Dashboard')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the initial screen

          },
        ),
        actions: [
          // Search Button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              showSearch(context: context, delegate: OutfitSearchDelegate(outfits: outfits));
            },
          ),
          // Favorite Button
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteOutfitsPage(favoriteOutfits: favoriteOutfits),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = selected ? category : 'All Categories';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
              itemCount: outfits.length,
              itemBuilder: (context, index) {
                final outfit = outfits[index];
                if (selectedCategory != 'All Categories' && outfit['category'] != selectedCategory) {
                  return Container();
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OutfitScreen(outfit: outfit)),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditOutfitPage()),
                    );
                  },
                  child: Stack(
                    children: [
                      OutfitCard(outfit: outfit),
                      if (editMode)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                outfits.removeAt(index);
                              });
                            },
                          ),
                        ),
                      if (editMode)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditOutfitPage()),
                              );
                            },
                          ),
                        ),
                      // Favorite Icon positioned at the bottom of the card
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            outfit['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                            color: outfit['isFavorite'] ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            toggleFavorite(index);
                          },
                        ),
                      ),
                    ],
                  ),

                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Outfit'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit Wardrobe'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OutfitDashboardPage()),
            );
          } else if (index == 1) {
            navigateToOutfitBuilder();
          } else if (index == 2) {
            setState(() {
              editMode = !editMode;
            });
          }
        },
      ),
    );
  }
}

// Outfit Card Widget
class OutfitCard extends StatelessWidget {
  final Map<String, dynamic> outfit;

  OutfitCard({required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                outfit['image'] as String? ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(outfit['title'] as String? ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(outfit['category'] as String? ?? '', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Outfit Search Delegate
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
