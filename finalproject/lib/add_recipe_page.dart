import 'package:flutter/material.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final List<String> mealTypes = ['Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Dessert'];
  List<String> selectedMealTypes = [];

  void saveRecipe() {
    final newRecipe = {
      'name': nameController.text.isNotEmpty ? nameController.text : 'Untitled Recipe',
      'description': descriptionController.text,
      'ingredients': ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      'instructions': instructionsController.text,
      'image': imageUrlController.text.isNotEmpty ? imageUrlController.text : null,
      'mealTypes': selectedMealTypes,
      'favorite': false, // Default favorite status
    };

    Navigator.pop(context, newRecipe); // Return the new recipe to the parent
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Recipe Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(labelText: 'Ingredients (comma separated)'),
            ),
            TextField(
              controller: instructionsController,
              decoration: const InputDecoration(labelText: 'Instructions'),
              maxLines: 4,
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Meal Types:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: mealTypes.map((type) {
                return CheckboxListTile(
                  title: Text(type),
                  value: selectedMealTypes.contains(type),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        selectedMealTypes.add(type);
                      } else {
                        selectedMealTypes.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveRecipe,
              child: const Text('Save Recipe'),
            ),
          ],
        ),
      ),
    );
  }
}
