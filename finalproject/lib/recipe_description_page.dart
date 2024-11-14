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
      widget.onUpdateRecipe(editedRecipe); // Update the recipe in the main list
      setState(() {}); // Refresh the UI with updated recipe 
    }
  }

  void _confirmDeleteRecipe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeleteRecipe(); // Call the delete function in the main list
                Navigator.of(context).pop(); // Go back to the previous 
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleFavoriteRecipe() {
    setState(() {
      widget.recipe['favorite'] = !(widget.recipe['favorite'] ?? false); // Toggle favorite status
    });
    widget.onUpdateRecipe(widget.recipe); // Update the recipe in the main list
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.brown[100]!;
    final bool isFavorite = widget.recipe['favorite'] ?? false;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.recipe['name'] ?? 'Recipe'),
        backgroundColor: Colors.brown[800],
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavoriteRecipe,
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _navigateToEditRecipe,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _confirmDeleteRecipe,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.recipe['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.recipe['image'],
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Center(
                  child: Text(
                    'PICTURE\nOF\nCOOKED\nFOOD',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              widget.recipe['name'] ?? 'Recipe',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.recipe['description'] ?? 'No description available.'),
            const SizedBox(height: 16),
            const Text(
              'Ingredients:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...((widget.recipe['ingredients'] as List<dynamic>?)?.map((ingredient) => Text('- $ingredient')).toList() ?? [const Text('No ingredients listed.')]),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(widget.recipe['instructions'] ?? 'No instructions provided.'),
          ],
        ),
      ),
    );
  }
}
