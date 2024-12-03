import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproject/shop_similiar_item.dart';
import 'shop_similiar_item.dart';
import 'package:flutter/material.dart';
import 'outfit_model.dart';

class OutfitScreen extends StatefulWidget {
  final Outfit outfit;

  const OutfitScreen({Key? key, required this.outfit}) : super(key: key);

  @override
  State<OutfitScreen> createState() => _OutfitScreenState();
}

class _OutfitScreenState extends State<OutfitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(widget.outfit.title, style: const TextStyle(fontFamily: 'Teko')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Favorite Icon
          IconButton(
            icon: Icon(
              widget.outfit.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: widget.outfit.isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () async {
              // Toggle favorite status in Firestore
              await FirebaseFirestore.instance
                  .collection('outfits')
                  .doc(widget.outfit.id)
                  .update({'isFavorite': !widget.outfit.isFavorite});
              // Update UI
              setState(() {
                widget.outfit.isFavorite = !widget.outfit.isFavorite;
              });
              },
          ),
          // Delete Icon
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
                              .doc(widget.outfit.id)
                              .delete();
                          Navigator.pop(context); // Close the dialog
                          Navigator.pop(context); // Go back to previous screen
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Center(
                child: widget.outfit.imageUrl.isNotEmpty
                    ? Image.network(
                  widget.outfit.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 500,
                )
                    : Container(
                  height: 300,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.outfit.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Teko',
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                widget.outfit.description,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lora',
                ),
              ),
              const SizedBox(height: 8),
              // Category and Type of Item
              Column(
                children: [
                  Chip(
                    label: Text(
                      widget.outfit.typeOfItem,
                      style: const TextStyle(fontFamily: 'Lora'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      widget.outfit.category,
                      style: const TextStyle(fontFamily: 'Lora'),
                    ),
                  ),
                ],
              ),
              const SizedBox(width : 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimilarOutfitsPage(outfitImageUrl: widget.outfit.imageUrl),
                    ),
                  );
                },
                child: const Text('Find Similar Outfits'),
              ),
        
        
        
            ],
          ),
        ),
      ),
    );
  }
}







