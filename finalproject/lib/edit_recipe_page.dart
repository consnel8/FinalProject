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
  late TextEditingController prepTimeController;

  final List<String> mealTypes = [
    'Breakfast',
    'Brunch',
    'Lunch',
    'Dinner',
    'Dessert'
  ];
  late List<String> selectedMealTypes;
  late int selectedDifficulty;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.recipe['name']);
    descriptionController =
        TextEditingController(text: widget.recipe['description']);
    ingredientsController = TextEditingController(
      text: (widget.recipe['ingredients'] as List<dynamic>? ?? []).join(', '),
    );
    instructionsController =
        TextEditingController(text: widget.recipe['instructions']);
    imageUrlController = TextEditingController(text: widget.recipe['image']);
    prepTimeController =
        TextEditingController(text: widget.recipe['prepTime'] ?? '');

    selectedMealTypes = List<String>.from(widget.recipe['mealTypes'] ?? []);
    selectedDifficulty = widget.recipe['difficulty'] ?? 3; // Default difficulty
  }

  void saveEditedRecipe() {
    final editedRecipe = {
      'id': widget.recipe['id'],
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'ingredients':
          ingredientsController.text.split(',').map((e) => e.trim()).toList(),
      'instructions': instructionsController.text.trim(),
      'image': imageUrlController.text.trim(),
      'prepTime': prepTimeController.text.trim(),
      'mealTypes': selectedMealTypes,
      'difficulty': selectedDifficulty,
      'favorite': widget.recipe['favorite'],
    };

    Navigator.pop(context, editedRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Recipe',
          style: TextStyle(fontFamily: 'Teko', fontSize: 38),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Recipe Name',
                labelStyle: TextStyle(fontFamily: 'Lora'),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(fontFamily: 'Lora'),
              ),
            ),
            TextField(
              controller: ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingredients (comma separated)',
                labelStyle: TextStyle(fontFamily: 'Lora'),
              ),
            ),
            TextField(
              controller: instructionsController,
              decoration: const InputDecoration(
                labelText: 'Instructions',
                labelStyle: TextStyle(fontFamily: 'Lora'),
              ),
              maxLines: 4,
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                labelStyle: TextStyle(fontFamily: 'Lora'),
              ),
            ),
            TextField(
              controller: prepTimeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Preparation Time (in minutes)',
                labelStyle: TextStyle(fontFamily: 'Lora'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Difficulty:',
              style: TextStyle(fontSize: 18, fontFamily: 'Teko'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(
                    index < selectedDifficulty ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedDifficulty = index + 1;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '(1 = Easy, 5 = Hard)',
              style: TextStyle(
                  fontFamily: 'Lora', fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Meal Types:',
              style: TextStyle(fontSize: 18, fontFamily: 'Teko'),
            ),
            Column(
              children: mealTypes.map((type) {
                return CheckboxListTile(
                  title: Text(
                    type,
                    style: const TextStyle(
                      color: Color(0xff757575),
                      fontFamily: 'Lora',
                    ),
                  ),
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
              child: const Text(
                'Save Changes',
                style: TextStyle(fontFamily: 'Lora'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
