import 'package:flutter/material.dart';
import 'add_recipe_page.dart';
import 'recipe_description_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notifications_page.dart';

class RecipeBookPage extends StatefulWidget {
  const RecipeBookPage({super.key});

  @override
  RecipeBookPageState createState() => RecipeBookPageState();
}

class RecipeBookPageState extends State<RecipeBookPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; //firestore instance
  List<Map<String, dynamic>> recipes = []; //list of all recipes
  List<Map<String, dynamic>> filteredRecipes = []; //filtered list of recipes
  final TextEditingController searchController = TextEditingController(); //controller for search input
  final List<String> mealTypes = [ //meal type filter options
    'All',
    'Breakfast',
    'Brunch',
    'Lunch',
    'Dinner',
    'Dessert'
  ];
  String selectedMealType = 'All'; //selected meal type
  bool showOnlyFavorites = false; //toggle to show only favorite recipes

  @override
  void initState() {
    super.initState();
    searchController.addListener(_searchRecipe);
    _fetchRecipes(); //get recipes from Firestore
  }

  @override
  void dispose() {
    searchController.removeListener(_searchRecipe);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecipes() async {
    try {
      final snapshot = await _firestore.collection('recipes').get(); //retrieve all recipes from the collection
      final List<Map<String, dynamic>> fetchedRecipes = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; //save document ID for reference
        return data;
      }).toList();
      setState(() {
        recipes = fetchedRecipes;
        filteredRecipes = recipes; //initialize filtered recipes to all recipes
      });
    } catch (e) {
      print('Error fetching recipes: $e'); //error handling
    }
  }

  Future<void> _addRecipe(Map<String, dynamic> newRecipe) async {
    try {
      final docRef = await _firestore.collection('recipes').add(newRecipe); //add recipe to Firestore
      newRecipe['id'] = docRef.id; //save the document ID
      setState(() {
        recipes.add(newRecipe); //add to local recipes list
        _searchRecipe();
      });
    } catch (e) {
      print('Error adding recipe: $e');
    }
  }

  void _searchRecipe() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredRecipes = recipes.where((recipe) {
        final recipeName = recipe['name'].toLowerCase(); //recipe name in lowercase
        final matchesQuery = recipeName.contains(query); //check if recipe name contains query
        final matchesMealType = selectedMealType == 'All' ||
            (recipe['mealTypes'] as List).contains(selectedMealType); //check meal type
        final matchesFavorite =
            !showOnlyFavorites || (recipe['favorite'] ?? false); //check if it matches favorite filter
        return matchesQuery && matchesMealType && matchesFavorite;
      }).toList();
    });
  }

  //updates the filter based on selected meal type
  void _filterByMealType(String? mealType) {
    setState(() {
      selectedMealType = mealType!; //update selected meal type
      _searchRecipe();
    });
  }

  //toggles the favorite filter
  void _toggleFavoriteFilter() {
    setState(() {
      showOnlyFavorites = !showOnlyFavorites; //toggle favorite filter
      _searchRecipe();
    });
  }

  //navigates to the AddRecipePage and adds the new recipe if provided
  void navigateToAddRecipe() async {
    final newRecipe = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipePage()),
    );
    if (newRecipe != null) {
      _addRecipe(newRecipe); //adds recipe if returned
    }
  }

  void navigateToRecipeDescription(Map<String, dynamic> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDescriptionPage(
          recipe: recipe, 
          onUpdateRecipe: (updatedRecipe) async { 
            await _firestore
                .collection('recipes')
                .doc(updatedRecipe['id'])
                .set(updatedRecipe); //update recipe in Firestore
            setState(() {
              final index = recipes.indexWhere((r) => r['id'] == recipe['id']); //find the recipe index
              if (index != -1) {
                recipes[index] = updatedRecipe; //update the recipe locally
                _searchRecipe(); 
              }
            });
          },
          onDeleteRecipe: () async { 
            await _firestore.collection('recipes').doc(recipe['id']).delete(); //delete from Firestore
            setState(() {
              recipes.removeWhere((r) => r['id'] == recipe['id']); //remove from local list
              _searchRecipe();
            });
          },
        ),
      ),
    );
  }

  int checkcount = 0;

  void scheduleAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text(
          "Would you like to schedule weekly notifications to try a new recipe?",
          style: TextStyle(fontFamily: 'Lora'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              checkcount = 2; //notifications not set
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 18,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              PermissionHandler.enableWeekly();
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: const Text(
                    "Weekly Notifications Scheduled.",
                    style: TextStyle(fontFamily: 'Lora'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        checkcount = 1;
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(fontFamily: 'Lora'),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              "Proceed",
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipe Book',
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 38,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: showOnlyFavorites ? const Color(0xfff485b1) : Colors.grey,
            ),
            onPressed: _toggleFavoriteFilter, //toggle favorite filter
          ),
          IconButton(
              onPressed: () {
                if ((checkcount == 0 || checkcount == 2)) {
                  scheduleAlert();
                  checkcount = 1; 
                } else if ((checkcount == 1)) { 
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: const Text(
                        "Your weekly notification is already scheduled.",
                        style: TextStyle(
                          fontFamily: 'Lora',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              fontFamily: 'Lora',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            checkcount = 0; 
                            const snackBar = SnackBar(
                                content: Text("Disabled weekly notifications"));
                            PermissionHandler.disableWeekly();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: const Text(
                            "Disable",
                            style: TextStyle(
                              fontFamily: 'Lora',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.alarm_add)),
        ],
      ),
      body: Column(
        children: [
          //search bar and meal type dropdown
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(fontFamily: 'Lora'),
                      hintStyle: const TextStyle(fontFamily: 'Lora'),
                      hintText: 'Search recipes...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedMealType, //current selected meal type
                  items: mealTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: _filterByMealType, //change meal type filter
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
                itemCount: filteredRecipes.length + 1, //recipes and Add button
                itemBuilder: (context, index) {
                  if (index == 0) { 
                    return GestureDetector(
                      onTap: navigateToAddRecipe,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, size: 50),
                            SizedBox(height: 8),
                            Text(
                              "Add Recipe",
                              style: TextStyle(
                                fontFamily: 'Lora',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else { //recipe items
                    final recipe = filteredRecipes[index - 1];
                    return GestureDetector(
                      onTap: () => navigateToRecipeDescription(recipe), //navigate to recipe description
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: recipe['image'] != null //check if recipe has an image
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        recipe['image'], //display image
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                        'No Image', //placeholder if no image
                                        style: TextStyle(
                                          fontFamily: 'Lora',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                recipe['name'], //display recipe name
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Lora',
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
