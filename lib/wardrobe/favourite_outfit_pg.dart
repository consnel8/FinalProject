import 'package:flutter/material.dart';
import 'outfit_model.dart';
import 'outfit_service.dart';

class FavoriteOutfitsPage extends StatefulWidget {
  @override
  _FavoriteOutfitsPageState createState() => _FavoriteOutfitsPageState();
}

class _FavoriteOutfitsPageState extends State<FavoriteOutfitsPage> {
  List<Outfit> favoriteOutfits = []; // Initialize the favoriteOutfits list
  bool isLoading = true; // To show a loading indicator while fetching data
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    fetchFavoriteOutfits(); // Fetch favorites from Firestore
  }

  Future<void> fetchFavoriteOutfits() async {
    try {
      // Fetch favorite outfits from Firestore
      final outfits = await OutfitService().fetchFavoriteOutfits(); // Make sure this method exists in your service
      setState(() {
        favoriteOutfits = outfits;
        isLoading = false; // Data has been fetched
      });
    } catch (e) {
      print('Error fetching favorite outfits: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void onDeleteOutfit(int index) async {
    try {
      final outfit = favoriteOutfits[index];

      // Confirm before deleting
      final confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Outfit'),
          content: const Text('Are you sure you want to delete this outfit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // Delete from Firestore
        await OutfitService().deleteOutfit(outfit.id);

        // Remove from local list
        setState(() {
          favoriteOutfits.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Outfit deleted successfully!')),
        );
      }
    } catch (e) {
      print('Error deleting outfit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete outfit.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Outfits'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loader while fetching data
          : favoriteOutfits.isEmpty
          ? const Center(child: Text('No favorite outfits found.'))
          : isGridView
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: favoriteOutfits.length,
        itemBuilder: (context, index) {
          return buildOutfitTile(favoriteOutfits[index], index);
        },
      )
          : ListView.builder(
        itemCount: favoriteOutfits.length,
        itemBuilder: (context, index) {
          return buildOutfitTile(favoriteOutfits[index], index);
        },
      ),
    );
  }

  Widget buildOutfitTile(Outfit outfit, int index) {
    return Dismissible(
      key: ValueKey(outfit.id),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.orange,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.remove_circle, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onDeleteOutfit(index);
          return false; // Prevent automatic dismissal
        } else {
          return false; // Add other functionality if needed
        }
      },
      child: Card(
        child: isGridView
            ? Column(
          children: [
            Image.network(outfit.imageUrl, height: 100, fit: BoxFit.cover),
            Text(outfit.title),
          ],
        )
            : Row(
          children: [
            Image.network(outfit.imageUrl, width: 100, fit: BoxFit.cover),
            Expanded(child: Text(outfit.title)),
          ],
        ),
      ),
    );
  }
}


