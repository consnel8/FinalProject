import 'package:flutter/material.dart';
import 'add_recipe_page.dart';
import 'recipe_description_page.dart';

class RecipeBookPage extends StatefulWidget {
  const RecipeBookPage({super.key});

  @override
  _RecipeBookPageState createState() => _RecipeBookPageState();
}

class _RecipeBookPageState extends State<RecipeBookPage> {
  List<Map<String, dynamic>> recipes = [
    {
      'name': 'Spaghetti Bolognese',
      'description': 'A delicious Italian pasta dish.',
      'image': 'https://example.com/spaghetti.jpg',
      'mealTypes': ['Dinner'],
      'favorite': false,
    },
    {
      'name': 'Chicken Salad',
      'description': 'A healthy salad with grilled chicken.',
      'image': 'https://example.com/chicken_salad.jpg',
      'mealTypes': ['Lunch'],
      'favorite': false,
    },
    {
      'name': 'Pancakes',
      'description': 'Fluffy pancakes for breakfast.',
      'image': 'https://example.com/pancakes.jpg',
      'mealTypes': ['Breakfast', 'Brunch'],
      'favorite': false,
    },
  ];

  List<Map<String, dynamic>> filteredRecipes = [];
  final TextEditingController searchController = TextEditingController();
  final List<String> mealTypes = ['All', 'Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Dessert'];
  String selectedMealType = 'All';
  bool showOnlyFavorites = false; // Add a boolean flag to toggle favorite recipes view

  @override
  void initState() {
    super.initState();
    filteredRecipes = recipes;
    searchController.addListener(_searchRecipe);
  }

  @override
  void dispose() {
    searchController.removeListener(_searchRecipe);
    searchController.dispose();
    super.dispose();
  }

  void _searchRecipe() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredRecipes = recipes.where((recipe) {
        final recipeName = recipe['name'].toLowerCase();
        final matchesQuery = recipeName.contains(query);
        final matchesMealType = selectedMealType == 'All' || (recipe['mealTypes'] as List).contains(selectedMealType);
        final matchesFavorite = !showOnlyFavorites || (recipe['favorite'] ?? false); // Check if it matches favorite filter
        return matchesQuery && matchesMealType && matchesFavorite;
      }).toList();
    });
  }

  void _filterByMealType(String? mealType) {
    setState(() {
      selectedMealType = mealType!;
      _searchRecipe();
    });
  }

  void _toggleFavoriteFilter() {
    setState(() {
      showOnlyFavorites = !showOnlyFavorites; // Toggle favorite recipes filter
      _searchRecipe();
    });
  }

  void navigateToAddRecipe() async {
    final newRecipe = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipePage()),
    );
    if (newRecipe != null) {
      setState(() {
        recipes.add(newRecipe);
        _searchRecipe();
      });
    }
  }

  void navigateToRecipeDescription(Map<String, dynamic> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDescriptionPage(
          recipe: recipe,
          onUpdateRecipe: (updatedRecipe) {
            setState(() {
              final index = recipes.indexOf(recipe);
              if (index != -1) {
                recipes[index] = updatedRecipe;
                _searchRecipe();
              }
            });
          },
          onDeleteRecipe: () {
            setState(() {
              recipes.remove(recipe);
              _searchRecipe();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Colors.brown[100]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        title: const Text('Recipe Book', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Image.asset(
            'assets/recipe_icon.png', // Path to your logo
            height: 40,               // Set height as needed
            width: 40,                // Optional: set width for consistent dimensions
          ),
          const SizedBox(width: 16), // Add spacing if needed
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search recipes...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: backgroundColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedMealType,
                  items: mealTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: _filterByMealType,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
                    color: showOnlyFavorites ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleFavoriteFilter, // Toggle favorite filter
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredRecipes.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: navigateToAddRecipe,
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 50, color: Colors.grey[600]),
                            const SizedBox(height: 8),
                            const Text(
                              "Add Recipe",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final recipe = filteredRecipes[index - 1];
                    return GestureDetector(
                      onTap: () => navigateToRecipeDescription(recipe),
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: recipe['image'] != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        recipe['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Center(
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
                            Container(
                              color: backgroundColor,
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                recipe['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.pink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
