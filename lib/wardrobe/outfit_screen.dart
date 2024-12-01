import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'outfit_editer.dart';
import 'outfit_model.dart';

class OutfitScreen extends StatelessWidget {
  final String outfitId;

  const OutfitScreen({
    Key? key,
    required this.outfitId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('outfits').doc(outfitId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Outfit not found.'));
          }

          final outfitData = snapshot.data!.data() as Map<String, dynamic>;
          final outfit = Outfit.fromDocumentSnapshot(snapshot.data!);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(),
                          body: Center(
                            child: Image.network(
                              outfit.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 100, color: Colors.grey);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(outfit.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outfit.title,
                        style: const TextStyle(fontSize: 32, fontFamily: 'Teko'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        outfit.category,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.grey, fontFamily: 'Lora'),
                      ),
                      Text(
                        outfit.typeOfItem,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.grey, fontFamily: 'Lora'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        outfit.description ?? 'No description available.',
                        style: const TextStyle(fontSize: 16, fontFamily: 'Lora'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              outfit.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: outfit.isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              final updatedFavorite = !outfit.isFavorite;
                              await FirebaseFirestore.instance
                                  .collection('outfits')
                                  .doc(outfit.id)
                                  .update({'isFavorite': updatedFavorite});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    updatedFavorite
                                        ? 'Added to favorites'
                                        : 'Removed from favorites',
                                    style: const TextStyle(fontFamily: 'Lora'),
                                  ),
                                ),
                              );
                            },
                          ),
                          const Text('Favorite', style: TextStyle(fontFamily: 'Lora')),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Outfit',
                                        style: TextStyle(fontFamily: 'Lora')),
                                    content: const Text(
                                        'Are you sure you want to delete this outfit?',
                                        style: TextStyle(fontFamily: 'Lora')),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the dialog
                                        },
                                        child: const Text('Cancel',
                                            style: TextStyle(fontFamily: 'Lora')),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('outfits')
                                              .doc(outfit.id)
                                              .delete();
                                          Navigator.pop(context); // Close the dialog
                                          Navigator.pop(context); // Go back
                                        },
                                        child: const Text('Delete',
                                            style: TextStyle(fontFamily: 'Lora')),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          const Text('Delete', style: TextStyle(fontFamily: 'Lora')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



