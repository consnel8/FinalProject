import 'package:flutter/material.dart';
import 'edit_recipe_page.dart';

class RecipeDescriptionPage extends StatefulWidget {
  final Map<String, dynamic> recipe; //recipe data to be displayed
  final Function(Map<String, dynamic>) onUpdateRecipe; //callback to update the recipe
  final Function onDeleteRecipe; //callback to delete the recipe

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
  //navigate to the edit recipe page
  void _navigateToEditRecipe() async {
    final editedRecipe = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditRecipePage(recipe: widget.recipe),
      ),
    );
    if (editedRecipe != null) {
      widget.onUpdateRecipe(editedRecipe); //update the recipe in Firestore
      setState(() {}); //refresh the UI with updated recipe data
    }
  }

  //show confirmation dialog before deleting the recipe
  void _confirmDeleteRecipe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Recipe', //title of the dialog
            style: TextStyle(
              fontFamily: 'Lora',
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this recipe?', //confirmation message
            style: TextStyle(fontFamily: 'Lora'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel', //option to cancel
                style: TextStyle(fontFamily: 'Lora'),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Delete', //option to delete
                style: TextStyle(color: Color(0xFFB8170B), fontFamily: 'Lora'),
              ),
              onPressed: () {
                Navigator.of(context).pop(); //close the dialog
                widget.onDeleteRecipe(); //delete the recipe in Firestore
                Navigator.of(context).pop(); //return to the previous screen
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
          !(widget.recipe['favorite'] ?? false); //change the favorite status
    });
    widget.onUpdateRecipe(
        widget.recipe); //update the favorite status in Firestore
  }

  @override
  Widget build(BuildContext context) {
    final bool isFavorite = widget.recipe['favorite'] ?? false; //check if recipe is a favorite
    final int starRating = widget.recipe['difficulty'] ?? 3; //default difficulty level
    final String prepTime = widget.recipe['prepTime'] ?? 'N/A'; //default prep time if not provided

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe['name'] ?? 'Recipe', //display the recipe name
          style: const TextStyle(fontFamily: 'Teko', fontSize: 28),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border, 
              color: const Color(0xfff485b1),
            ),
            onPressed: _toggleFavoriteRecipe, //toggle favorite status
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _navigateToEditRecipe,
          ),
          //delete recipe button
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
                    'No Image', //message for missing image
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

            Text(
              widget.recipe['name'] ?? 'Recipe', //display the recipe name
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora',
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.timer, color: Colors.grey), //timer icon
                const SizedBox(width: 8),
                Text(
                  'Prep Time: $prepTime', //display preparation time
                  style: const TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

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
                  index < starRating ? Icons.star : Icons.star_border, //display stars based on difficulty
                  color: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '(1 = Easy, 5 = Hard)', //explanation for the difficulty rating
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

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
              widget.recipe['description'] ?? 'No description available.', //recipe description
              style: const TextStyle(fontFamily: 'Lora'),
            ),

            const SizedBox(height: 16),

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
                          '- $ingredient', //display each ingredient
                          style: const TextStyle(
                            fontFamily: 'Lora',
                          ),
                        ))
                    .toList() ??
                [
                  const Text(
                    'No ingredients listed.', //message for missing ingredients
                    style: TextStyle(fontFamily: 'Lora'),
                  )
                ]),

            const SizedBox(height: 16),

            const Text(
              'Cooking Instructions:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lora',
              ),
            ),
            ..._buildCookingInstructions(widget.recipe['instructions']), //display cooking instructions
          ],
        ),
      ),
    );
  }

  //helper function to build the list of cooking instructions
  List<Widget> _buildCookingInstructions(String? instructions) {
    if (instructions == null || instructions.isEmpty) {
      return [
        const Text(
          'No instructions provided.', //message for missing instructions
          style: TextStyle(fontFamily: 'Lora'),
        )
      ];
    }

    final steps = instructions.split(','); //split instructions into steps
    return List<Widget>.generate(steps.length, (index) {
      return Text('${index + 1}. ${steps[index].trim()}'); //display each step with numbering
    });
  }
}
