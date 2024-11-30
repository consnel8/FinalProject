import 'package:flutter/material.dart';
import 'edit_recipe_page.dart';

class RecipeDescriptionPage extends StatefulWidget {
  final Map<String, dynamic> recipe;
  final Function(Map<String, dynamic>) onUpdateRecipe;
  final Function onDeleteRecipe;

  const RecipeDescriptionPage({
    super.key,
    required this.recipe,
    required this.onUpdateRecipe,
    required this.onDeleteRecipe,
  });

  @override
  _RecipeDescriptionPageState createState() => _RecipeDescriptionPageState();
}

class _RecipeDescriptionPageState extends State<RecipeDescriptionPage> {
  void _navigateToEditRecipe() async {
    final editedRecipe = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipePage(recipe: widget.recipe),
      ),
    );
    if (editedRecipe != null) {
      widget.onUpdateRecipe(editedRecipe); // Update the recipe in Firestore
      setState(() {}); // Refresh the UI with updated recipe
    }
  }

  void _confirmDeleteRecipe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Recipe',
            style: TextStyle(
              fontFamily: 'Lora',
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this recipe?',
            style: TextStyle(fontFamily: 'Lora'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Lora'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFB8170B), fontFamily: 'Lora'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeleteRecipe(); // Delete the recipe from Firestore
                Navigator.of(context).pop(); // Go back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleFavoriteRecipe() {
    setState(() {
      widget.recipe['favorite'] =
          !(widget.recipe['favorite'] ?? false); // Toggle favorite status
    });
    widget.onUpdateRecipe(
        widget.recipe); // Update the favorite status in Firestore
  }

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = widget.recipe['favorite'] ?? false;
    final int starRating = widget.recipe['difficulty'] ?? 3; // Default difficulty
    final String prepTime = widget.recipe['prepTime'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe['name'] ?? 'Recipe',
          style: const TextStyle(fontFamily: 'Teko', fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: const Color(0xfff485b1),
            ),
            onPressed: _toggleFavoriteRecipe,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditRecipe,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDeleteRecipe,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            if (widget.recipe['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.recipe['image'],
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Image not available'));
                  },
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1),
                ),
                child: const Center(
                  child: Text(
                    'No Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Recipe Name
            Text(
              widget.recipe['name'] ?? 'Recipe',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora',
              ),
            ),

            const SizedBox(height: 8),

            // Prep Time
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Prep Time: $prepTime',
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Difficulty Rating with Stars Only
            const Text(
              'Difficulty:',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < starRating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '(1 = Easy, 5 = Hard)',
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Description
            const Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.recipe['description'] ?? 'No description available.',
              style: const TextStyle(fontFamily: 'Lora'),
            ),

            const SizedBox(height: 16),

            // Ingredients
            const Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora',
              ),
            ),
            ...((widget.recipe['ingredients'] as List<dynamic>?)
                    ?.map((ingredient) => Text(
                          '- $ingredient',
                          style: const TextStyle(
                            fontFamily: 'Lora',
                          ),
                        ))
                    .toList() ??
                [
                  const Text(
                    'No ingredients listed.',
                    style: TextStyle(fontFamily: 'Lora'),
                  )
                ]),

            const SizedBox(height: 16),

            // Cooking Instructions
            const Text(
              'Cooking Instructions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora',
              ),
            ),
            ..._buildCookingInstructions(widget.recipe['instructions']),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCookingInstructions(String? instructions) {
    if (instructions == null || instructions.isEmpty) {
      return [
        const Text(
          'No instructions provided.',
          style: TextStyle(fontFamily: 'Lora'),
        )
      ];
    }

    final steps = instructions.split(','); // Split the string by commas
    return List<Widget>.generate(steps.length, (index) {
      return Text('${index + 1}. ${steps[index].trim()}');
    });
  }
}
