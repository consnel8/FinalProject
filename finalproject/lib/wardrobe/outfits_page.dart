import 'package:flutter/material.dart';

import '../SettingsPage.dart';
import '../about_page.dart';
import '../main.dart';
import 'favourite_outfit_pg.dart';
import 'outfit_builder.dart';
import 'outfit_editer.dart';
import 'outfit_screen.dart';

class OutfitDashboardPage extends StatefulWidget {
  const OutfitDashboardPage({super.key});

  @override
  _OutfitDashboardPageState createState() => _OutfitDashboardPageState();
}

class _OutfitDashboardPageState extends State<OutfitDashboardPage> {
  final List<String> categories = [
    'All Categories',
    'Formal',
    'Casual',
    'Dresses',
    'Accessories',
    'Winter/Fall',
    'Summer/Spring'
  ];
  String selectedCategory = 'All Categories';
  bool editMode = false;
  List<Map<String, dynamic>> outfits = [
    {
      'title': ' Casual Outfit',
      'category': 'Casual',
      'image': 'assets/Outfit.jpg',
      'isFavorite': false
    },
    {
      'title': 'Collage',
      'category': 'Formal',
      'image': 'assets/collage.jpg',
      'isFavorite': true
    },
    {
      'title': 'Heels',
      'category': 'Shoes',
      'image': 'assets/shoes.jpg',
      'isFavorite': true
    }
  ];

  List<Map<String, dynamic>> favoriteOutfits =
      []; // List to store favorite outfits

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
    final filteredOutfits = selectedCategory == 'All Categories'
        ? outfits
        : outfits
            .where((outfit) => outfit['category'] == selectedCategory)
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Outfit Dashboard')),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        actions: [
          // Search Button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              showSearch(
                  context: context,
                  delegate: OutfitSearchDelegate(outfits: outfits));
            },
          ),
          // Favorite Button
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteOutfitsPage(favoriteOutfits: favoriteOutfits),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              );
            },
          )
        ],
      ),
      body: Column(children: [
        SizedBox(height: 10),
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.8,
            ),
            itemCount: outfits
                .where((outfit) =>
                    selectedCategory == 'All Categories' ||
                    outfit['category'] == selectedCategory)
                .toList()
                .length,
            itemBuilder: (context, index) {
              // Filter the outfits based on selectedCategory
              final filteredOutfits = outfits
                  .where((outfit) =>
                      selectedCategory == 'All Categories' ||
                      outfit['category'] == selectedCategory)
                  .toList();

              final outfit = filteredOutfits[index];
              if (selectedCategory != 'All Categories' &&
                  outfit['category'] != selectedCategory) {
                return Container(); // Empty container for filtered-out items
              }

              return GestureDetector(
                onTap: () {
                  // Navigate to OutfitScreen when tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OutfitScreen(
                        outfit: outfit, // Provide the outfit object
                        onDeleteOutfit: () {
                          // Handle delete action will implement later
                        },
                        onToggleFavorite: (bool isFavorite) {
                          // Handle toggle favorite action
                        },
                        onUpdateOutfit: (updatedOutfit) {
                          // Handle update action
                        },
                      ),
                    ),
                  );
                },
                onLongPress: () {
                  // Navigate to EditOutfitPage when long pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditOutfitPage(
                        outfit: outfit, // Pass the outfit being edited
                        onSave: (updatedOutfit) {
                          // Handle save action
                        },
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Image.network(
                                outfit['image'] as String? ?? '',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(outfit['title'] as String? ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(outfit['category'] as String? ?? '',
                                        style: const TextStyle(
                                            color: Colors.grey)),
                                  ],
                                ),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  IconButton(
                                    icon: Icon(
                                      outfit['isFavorite']
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: outfit['isFavorite']
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        outfit['isFavorite'] =
                                            !outfit['isFavorite'];
                                        if (outfit['isFavorite']) {
                                          favoriteOutfits.add(outfit);
                                        } else {
                                          favoriteOutfits.remove(outfit);
                                        }
                                      });
                                    },
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (editMode)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: PopupMenuButton<String>(
                          onSelected: (String option) {
                            if (option == 'Edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditOutfitPage(
                                    outfit: outfit,
                                    // Pass the outfit being edited
                                    onSave: (updatedOutfit) {
                                      // Handle save action
                                      setState(() {
                                        final index = outfits.indexOf(outfit);
                                        outfits[index] = updatedOutfit;
                                      });
                                    },
                                  ),
                                ),
                              );
                            } else if (option == 'Delete') {
                              setState(() {
                                outfits.remove(outfit);
                                favoriteOutfits.remove(
                                    outfit); // Remove from favorites if present
                              });
                            } else if (option == 'Toggle Favorite') {
                              setState(() {
                                outfit['isFavorite'] = !outfit['isFavorite'];
                                if (outfit['isFavorite']) {
                                  favoriteOutfits.add(outfit);
                                } else {
                                  favoriteOutfits.remove(outfit);
                                }
                              });
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: 'Edit', child: Text('Edit')),
                            const PopupMenuItem(
                                value: 'Delete', child: Text('Delete')),
                            PopupMenuItem(
                              value: 'Toggle Favorite',
                              child: Text(outfit['isFavorite']
                                  ? 'Remove from Favorites'
                                  : 'Add to Favorites'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Outfit'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit), label: 'Edit Wardrobe'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (content) => HomeScreen()),
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
      floatingActionButton: editMode
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  editMode = false; // Exit edit mode
                });
              },
              child: const Icon(Icons.done),
            )
          : null,
    );
  }
}

// Outfit Card Widget
class OutfitCard extends StatelessWidget {
  final Map<String, dynamic> outfit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const OutfitCard({
    super.key,
    required this.outfit,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          // Image and Title Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
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
                    Text(
                      outfit['title'] as String? ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      outfit['category'] as String? ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Heart Icon
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: onToggleFavorite,
              child: Icon(
                outfit['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                color: outfit['isFavorite'] ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
          ),
          // Three-Dot Menu
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'Edit':
                    onEdit();
                    break;
                  case 'Delete':
                    onDelete();
                    break;
                  case 'ToggleFavorite':
                    onToggleFavorite();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
                PopupMenuItem(
                  value: 'ToggleFavorite',
                  child: Text(
                    outfit['isFavorite'] ? 'Remove from Liked' : 'Add to Liked',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//outfit searching in outfit dashboard page
class OutfitSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> outfits;

  OutfitSearchDelegate({required this.outfits});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        //search bar icons
        icon: Icon(query.isEmpty ? Icons.search : Icons.clear),
        onPressed: () {
          if (query.isNotEmpty) {
            query = ''; // Clear search query
          } else {
            showSuggestions(context); // Focus on search suggestions
          }
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
    final results = outfits
        .where((outfit) =>
            outfit['title']
                .toLowerCase()
                .contains(query.toLowerCase()) || // Exact match
            outfit['title']
                .toLowerCase()
                .startsWith(query.toLowerCase()) || // Partial match
            query.split(' ').any((word) => outfit['title']
                .toLowerCase()
                .contains(word.toLowerCase()))) // Word by word match
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          "Item with name '$query' doesn't exist. Try searching something else.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

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
              MaterialPageRoute(
                builder: (context) => OutfitScreen(
                  outfit: outfit, // Provide the outfit object
                  onDeleteOutfit: () {
                    // Handle delete action
                  },
                  onToggleFavorite: (bool isFavorite) {
                    //  toggle favorite action
                  },
                  onUpdateOutfit: (updatedOutfit) {
                    //  update action
                  },
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
    final suggestions = outfits
        .where((outfit) =>
            outfit['title']
                .toLowerCase()
                .startsWith(query.toLowerCase()) || // Partial match
            outfit['title']
                .toLowerCase()
                .contains(query.toLowerCase())) // Fuzzy match
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final outfit = suggestions[index];
        return ListTile(
          title: Text(outfit['title'] as String? ?? ''),
          trailing: const Text(
            '↖', //icon to complete the word instead of typing it all
            style: TextStyle(
              fontSize: 24, // Adjust size as needed
              color: Colors.black, // Adjust color if necessary
            ),
          ),
          // title: Text(outfit['title'] as String? ?? ''),
          //trailing: Icon(Icons.arrow_right),
          onTap: () {
            query = outfit['title'];
            showResults(
                context); // Show results directly when suggestion is tapped
          },
        );
      },
    );
  }
}
