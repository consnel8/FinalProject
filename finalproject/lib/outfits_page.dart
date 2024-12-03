
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../SettingsPage.dart';
import 'favourite_outfit_pg.dart';
import 'outfit_builder.dart' as builder;
import 'outfit_editer.dart';
import 'outfit_screen.dart';
import 'outfit_service.dart';
import 'outfit_model.dart';


class OutfitDashboardPage extends StatefulWidget {
  const OutfitDashboardPage({super.key});

  @override
  _OutfitDashboardPageState createState() => _OutfitDashboardPageState();
}

class _OutfitDashboardPageState extends State<OutfitDashboardPage> {
  int checkcount = 0;
  bool isAscending = true;
  final OutfitService _outfitService = OutfitService();

  List<Outfit> outfits = []; //this list is to store fetched outfit from fb
  @override
  void initState(){
    super.initState();
    _loadOutfits();

  }
  Future<void> _loadOutfits() async{
    final fetchedOutfits = await _outfitService.fetchOutfits();
    setState(() {
      outfits = fetchedOutfits.cast<Outfit>();
    });
  }

  final List<String> categories = [
    'All Categories',
    'Formal',
    'Casual',
    'Individual Item',
    'Accessories',
    'Winter/Fall',
    'Summer/Spring'
  ];
  String selectedCategory = 'All Categories';
  bool editMode = false;

  List<Outfit> favoriteOutfits = [];

  void navigateToOutfitBuilder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => builder.OutfitBuilderPage(
          onSave: (newOutfit) {
            setState(() {
              outfits.add(newOutfit as Outfit);
            });
          },
        ),
      ),
    );
  }

  void toggleFavorite(Outfit outfit) async {
    setState(() {
      outfit.isFavorite = !outfit.isFavorite;

      if (outfit.isFavorite) {
        favoriteOutfits.add(outfit); // Add the Outfit object directly
      } else {
        favoriteOutfits.remove(outfit); // Remove the Outfit object
      }
    });

    try {
      // Update Firestore
      await _outfitService.toggleFavorite(outfit.id, outfit.isFavorite);
    } catch (e) {
      // Revert the UI change if Firestore update fails
      setState(() {
        outfit.isFavorite = !outfit.isFavorite;

        if (outfit.isFavorite) {
          favoriteOutfits.add(outfit);
        } else {
          favoriteOutfits.remove(outfit);
        }
      });

      print('Failed to update favorite status: $e');
    }
  }


  void _showConfirmationDialog(
      BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                onConfirm(); // Perform the action
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }



  void addOutfit(Map<String, dynamic> outfit) {
    setState(() {
      outfits.add(outfit as Outfit); // Adding new outfit to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredOutfits = selectedCategory == 'All Categories'
        ? outfits
        : outfits
            .where((outfit) => outfit.category  == selectedCategory)
            .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Outfit Dashboard'), ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
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
                      FavoriteOutfitsPage(),
                ),
              );
            },
          ),
         IconButton(onPressed: (){
           handleReminderIconPress();
         }, icon:  Icon(Icons.alarm_add),)

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
          child: StreamBuilder<List<Outfit>>(
            stream: _outfitService.getOutfitsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No outfits found.'));
              }

              final outfits = snapshot.data!;
              final filteredOutfits = outfits.where((outfit) {
                return selectedCategory == 'All Categories' ||
                    outfit.category == selectedCategory;
              }).toList();

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredOutfits.length,
                itemBuilder: (context, index) {
                  final outfit = filteredOutfits[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutfitScreen(outfit: outfit),
                        ),
                      );
                    },
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditOutfitPage(
                            outfit: outfit,
                            onSave: (updatedOutfit) async {
                              await _outfitService.saveOutfit(updatedOutfit);
                              setState(() {
                                filteredOutfits[index] = updatedOutfit;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        // Main Card Design
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Section
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: Image.network(
                                    outfit.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              // Title, Category, and Favorite Button
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          outfit.title,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text(
                                          outfit.category,
                                          style:
                                          const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                        //Text(outfit.dateAdded.toString()),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        outfit.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: outfit.isFavorite ? Colors.red : Colors.grey,
                                      ),
                                      onPressed: () async {
                                        await _outfitService.toggleFavorite(
                                            outfit.id, !outfit.isFavorite);
                                        setState(() {
                                          outfit.isFavorite = !outfit.isFavorite;
                                        });

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(outfit.isFavorite
                                                ? 'Added to Favorites'
                                                : 'Removed from Favorites'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Popup Menu for Edit and Delete
                        if (editMode)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: PopupMenuButton<String>(
                              onSelected: (String option) async {
                                if (option == 'Edit') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditOutfitPage(
                                        outfit: outfit,
                                        onSave: (updatedOutfit) async {
                                          await _outfitService.saveOutfit(updatedOutfit);
                                          setState(() {
                                            final index = filteredOutfits
                                                .indexWhere((o) => o.id == updatedOutfit.id);
                                            if (index != -1) {
                                              filteredOutfits[index] = updatedOutfit;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                } else if (option == 'Delete') {
                                  _showConfirmationDialog(
                                    context,
                                    "Delete Outfit",
                                    "Are you sure you want to delete this outfit? This action cannot be undone.",
                                        () async {
                                      await _outfitService.deleteOutfit(outfit.id);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Outfit deleted")),
                                      );
                                    },
                                  );

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
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );

            },
          ),
        ),
      ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.edit, color: Colors.lightBlueAccent,), label: 'Edit Wardrobe'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Outfit'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          ],

          onTap: (index) {
            if (index == 0) {
              setState(() {
                editMode = !editMode;
              });
            } else if (index == 1) {
              navigateToOutfitBuilder();
            } else if(index ==2){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            }
          },
        ),

        floatingActionButton: editMode
            ? FloatingActionButton(
          onPressed: () {
            // Exit edit mode and refresh UI
            setState(() {
              editMode = false;
            });
          },
          child: const Icon(Icons.done_outline_rounded),
        )
            : null,


    );
  }

  int reminderStatus = 0; // 0: Not set, 1: Set

  void handleReminderIconPress() {
    if (reminderStatus == 1) {
      // Notify the user that the reminder is already set
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(
            "Your reminder is already set.",
            style: TextStyle(
              fontFamily: 'Lora',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  fontFamily: 'Lora',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Prompt the user to confirm setting the reminder
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(
            "Do you want to set the reminder to log outfits?",
            style: TextStyle(
              fontFamily: 'Lora',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: 'Lora',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Set the reminder and notify the user
                scheduleAlert();
                reminderStatus = 1; // Update the status to "set"
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontFamily: 'Lora',
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void scheduleAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder successfully set!')),
    );
  }



}

// Outfit Card Widget
class OutfitCard extends StatelessWidget {
  final Outfit outfit; // Changed from Map<String, dynamic> to Outfit
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const OutfitCard({
    super.key,
    required this.outfit,
    this.onEdit,
    this.onDelete,
    this.onToggleFavorite,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
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
                    child: outfit.imageUrl.isNotEmpty
                        ? Image.network(
                      outfit.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                        : Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outfit.title.isNotEmpty ? outfit.title : 'No Title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        outfit.category.isNotEmpty ? outfit.category : 'No Category',
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
                onTap: onToggleFavorite, // Calls Firestore toggle functionality
                child: Icon(
                  outfit.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: outfit.isFavorite ? Colors.red : Colors.grey,
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
                      if (onEdit!= null) onEdit; // Opens edit functionality
                      break;
                    case 'Delete':
                      if(onDelete != null) onDelete; // Deletes from Firestore
                      break;
                    case 'ToggleFavorite':
                      if(onToggleFavorite != null) onToggleFavorite; // Toggles favorite in Firestore
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if(onEdit != null)
                    const PopupMenuItem(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                  if(onDelete != null)
                    const PopupMenuItem(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                  if(onToggleFavorite !=null)
                    PopupMenuItem(
                    value: 'ToggleFavorite',
                    child: Text(
                      outfit.isFavorite ? 'Remove from Liked' : 'Add to Liked',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//outfit searching in outfit dashboard page
class OutfitSearchDelegate extends SearchDelegate {
  final List<Outfit> outfits;

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
    final suggestions = outfits
        .where((outfit) =>
    outfit.title.toLowerCase().contains(query.toLowerCase()) ||
        outfit.title.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final outfit = suggestions[index];
        return ListTile(
          title: Text(outfit.title, style: const TextStyle(fontFamily: 'Lora')),
          subtitle: Text(outfit.typeOfItem, style: const TextStyle(fontFamily: 'Lora')),
          onTap: () {
            // Navigate to OutfitScreen with the specific outfit
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
    final suggestions = outfits
        .where((outfit) =>
    outfit.title.toLowerCase().startsWith(query.toLowerCase()) ||
        outfit.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final outfit = suggestions[index];
        return ListTile(
          title: Text(outfit.title, style: const TextStyle(fontFamily: 'Lora')),
          subtitle: Text(outfit.typeOfItem, style: const TextStyle(fontFamily: 'Lora')),
          onTap: () {
            // Navigate to OutfitScreen with the specific outfit
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


}
