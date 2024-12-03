import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final TextEditingController prepTimeController = TextEditingController();

  final List<String> mealTypes = [
    'Breakfast',
    'Brunch',
    'Lunch',
    'Dinner',
    'Dessert'
  ];
  List<String> selectedMealTypes = []; //list of selected meal types
  int selectedDifficulty = 3; //default difficulty level (1 to 5)
  bool isLoading = false; //state variable to show a loading indicator

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; //firestore instance

  //saves the recipe to Firestore
  Future<void> saveRecipe() async {
    //check if required fields are filled
    if (nameController.text.isEmpty || ingredientsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill out all required fields.', //error message for empty fields
            style: TextStyle(fontFamily: 'Lora'),
          ),
        ),
      );
      return;
    }

    //create a recipe object to save
    final newRecipe = {
      'name': nameController.text.trim(), //recipe name
      'description': descriptionController.text.trim(), //recipe description
      'ingredients': ingredientsController.text
          .split(',') // Split ingredients by comma
          .map((e) => e.trim())
          .toList(),
      'instructions': instructionsController.text.trim(), //recipe instructions
      'image': imageUrlController.text.isNotEmpty
          ? imageUrlController.text.trim() //optional image URL
          : null,
      'prepTime': prepTimeController.text.trim(), //preparation time
      'mealTypes': selectedMealTypes, //selected meal types
      'difficulty': selectedDifficulty, //selected difficulty level
      'favorite': false, //default favorite status
      'createdAt': FieldValue.serverTimestamp(), //timestamp for creation
    };

    setState(() {
      isLoading = true;
    });

    try {
      //save the recipe to Firestore
      await _firestore.collection('recipes').add(newRecipe);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Recipe saved successfully!', 
            style: TextStyle(fontFamily: 'Lora'),
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error saving recipe: $e',
            style: TextStyle(fontFamily: 'Lora'),
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Recipe',
          style: TextStyle(fontFamily: 'Teko', fontSize: 38),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
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
                      labelText: 'Instructions  (comma separated)',
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
                          index < selectedDifficulty
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedDifficulty = index + 1; //set difficulty
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '(1 = Easy, 5 = Hard)', //difficulty guide
                    style: TextStyle(
                        fontFamily: 'Lora', fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  //meal type selection
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
                              color: Color(0xff757575), fontFamily: 'Lora'),
                        ),
                        value: selectedMealTypes.contains(type), //check state
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              selectedMealTypes.add(type); //add meal type
                            } else {
                              selectedMealTypes.remove(type); //remove meal type
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Save recipe button
                  ElevatedButton(
                    onPressed: saveRecipe, //save recipe to Firestore
                    child: const Text(
                      'Save Recipe',
                      style: TextStyle(fontFamily: 'Lora'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
