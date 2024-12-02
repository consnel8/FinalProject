

import 'package:flutter/material.dart';
import 'outfit_model.dart';
import 'outfit_service.dart';
import 'outfit_screen.dart';

class FavoriteOutfitsPage extends StatefulWidget {
  @override
  _FavoriteOutfitsPageState createState() => _FavoriteOutfitsPageState();
}

class _FavoriteOutfitsPageState extends State<FavoriteOutfitsPage> {
  List<Outfit> favoriteOutfits = []; // Initialize the favoriteOutfits list
  bool isLoading = true; // To show a loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    fetchFavoriteOutfits(); // Fetch favorites from Firestore
  }

  Future<void> fetchFavoriteOutfits() async {
    try {
      // Fetch favorite outfits from Firestore
      final outfits = await OutfitService().fetchFavoriteOutfits();
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

  void toggleFavorite(Outfit outfit, int index) async {
    try {
      // Toggle favorite status in Firestore
      await OutfitService().toggleFavorite(outfit.id, false);

      // Remove from local list
      setState(() {
        favoriteOutfits.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites!')),
      );
    } catch (e) {
      print('Error toggling favorite: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update favorite status.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Outfits'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loader while fetching data
          : favoriteOutfits.isEmpty
          ? const Center(child: Text('No favorite outfits found.'))
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.8, // Adjust tile size
        ),
        itemCount: favoriteOutfits.length,
        itemBuilder: (context, index) {
          return buildOutfitTile(favoriteOutfits[index], index);
        },
      ),
    );
  }

  Widget buildOutfitTile(Outfit outfit, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to OutfitScreen to display full outfit details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OutfitScreen(outfit: outfit),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  outfit.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                outfit.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    outfit.category,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () => toggleFavorite(outfit, index),
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



