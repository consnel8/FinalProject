import 'package:flutter/material.dart';

import 'outfit_editer.dart';

class OutfitScreen extends StatelessWidget {
  final Map<String, dynamic> outfit;
  final Function(Map<String, dynamic>) onUpdateOutfit;
  final Function() onDeleteOutfit;
  final Function(bool) onToggleFavorite;

  const OutfitScreen({
    super.key,
    required this.outfit,
    required this.onUpdateOutfit,
    required this.onDeleteOutfit,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController descriptionController = TextEditingController(
      text: outfit['description'] ?? '',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(outfit['title']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Edit') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Edit Outfit'),
                      content: const Text('Are you sure you want to edit this outfit?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditOutfitPage(
                                  outfit: outfit,
                                  onSave: (updatedOutfit) {
                                    onUpdateOutfit(updatedOutfit);
                                  },
                                ),
                              ),
                            );
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Edit',
                child: Text('Edit Outfit'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Outfit image covering 70% of screen height
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(),
                    body: Center(
                      child: Image.network(outfit['image'], fit: BoxFit.contain),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(outfit['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Outfit title and category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(outfit['title'], style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 8),
                Text(outfit['category'], style: const TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 16),
                // Description section
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        outfit['description'] ?? 'No description available.',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Edit Description',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  TextField(
                                    controller: descriptionController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter description',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      onUpdateOutfit({
                                        ...outfit,
                                        'description': descriptionController.text,
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          // Favorite and delete buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        outfit['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                        color: outfit['isFavorite'] ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(outfit['isFavorite']
                                  ? 'Remove from Favorites'
                                  : 'Add to Favorites'),
                              content: Text(outfit['isFavorite']
                                  ? 'Are you sure you want to remove this outfit from your favorites list?'
                                  : 'Are you sure you want to add this outfit to your favorites list?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                    onToggleFavorite(!outfit['isFavorite']);
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const Text('Favorite'),
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
                              title: const Text('Delete Outfit'),
                              content: const Text('Are you sure you want to delete this outfit?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onDeleteOutfit();
                                    Navigator.pop(context); // Close the dialog
                                    Navigator.pop(context); // Go back to previous screen
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const Text('Delete'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
