import 'package:flutter/material.dart';

class EditRecipePage extends StatefulWidget {
  final Map<String, dynamic> recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController ingredientsController;
  late TextEditingController instructionsController;
  late TextEditingController imageUrlController;

  final List<String> mealTypes = ['Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Dessert'];
  late List<String> selectedMealTypes;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing recipe data
    nameController = TextEditingController(text: widget.recipe['name']);
    descriptionController = TextEditingController(text: widget.recipe['description']);
    ingredientsController = TextEditingController(
      text: (widget.recipe['ingredients'] as List<dynamic>? ?? []).join(', '),
    );
    instructionsController = TextEditingController(text: widget.recipe['instructions']);
    imageUrlController = TextEditingController(text: widget.recipe['image']);
    
    // Initialize selectedMealTypes with a default empty list if it's null
    selectedMealTypes = List<String>.from(widget.recipe['mealTypes'] ?? []);
  }

  void saveEditedRecipe() {
    final editedRecipe = {
      'name': nameController.text,
      'description': descriptionController.text,
      'ingredients': ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      'instructions': instructionsController.text,
      'image': imageUrlController.text,
      'mealTypes': selectedMealTypes,
      'favorite': widget.recipe['favorite'],
    };
    Navigator.pop(context, editedRecipe); // Return the edited recipe to the previous
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.brown[100]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Recipe'),
        backgroundColor: Colors.brown[800],
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
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
            const Text('Select Meal Types:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              onPressed: saveEditedRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                foregroundColor: Colors.white, // Set text color to white
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
