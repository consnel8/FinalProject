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
      'image': 'https://passportmagazine.com/wp-content/uploads/2024/07/Bolognese-Sauce-photo-by-Tatiana-Goskova-585x390.jpg',
      'mealTypes': ['Dinner'],
      'favorite': false,
      'ingredients': [
        '1 1/2 tbsp olive oil',
        '2 garlic cloves, minced',
        '1 onion, finely chopped',
        '1 lb ground beef or pork',
        '1/2 cup red wine',
        '2 beef bouillon cubes, crumbled',
        '800g can crushed tomatoes',
        '2 tbsp tomato paste',
        '2 tsp Worcestershire sauce',
      ],
      'cookingInstructions': '''
        Sauté: Heat oil in a large pot or deep skillet over medium high heat. Add onion and garlic cook for 3 minutes or until light golden and softened, 
        Cook beef: Turn heat up to high and add beef. Cook. breaking it up as your go. until browned,
        Reduce wine: Add red wine. Bring to simmer and cook for 1 minute. scraping the bottom of the pot. until the alcohol smell is gone,
        Simmer: Add the remaining ingredients. Stir. bring to a simmer then turn down to medium so it bubbles gently. Cook for 20 to 30 minutes (no lid). adding water if the sauce gets too thick for your taste. Stir occasionally,
        Slow simmer option: really takes this to another level. if you have the time! Add 3/4 cup of water. cover with lid and simmer on very low for 2 to 2.5 hours. stirring every 30 minutes or so. (Note 5) Uncover. simmer 20 minutes to thicken sauce. (Note 6 for slow cooker),
        Taste and add more salt it desired. Serve over spaghetti though if you have the time. I recommend tossing the sauce and pasta per steps below'
    '''
    },
    {
      'name': 'Chicken Salad',
      'description': 'A healthy salad with grilled chicken.',
      'image': 'https://cdn.apartmenttherapy.info/image/upload/f_jpg,q_auto:eco,c_fill,g_auto,w_1500,ar_16:9/k%2FPhoto%2FRecipes%2F2024-03-chicken-salad-190%2Fchicken-salad-190-261',
      'mealTypes': ['Lunch'],
      'favorite': false,
      'ingredients': [
        '2 cups cooked chopped chicken',
        '½ cup mayonnaise',
        '1 rib celery, diced',
        '1 green onion, sliced',
        '1 tsp Dijon mustard',
        '½ tsp seasoned salt',
        '1 tsp chopped fresh dill',
      ],
      'cookingInstructions': '''
        In a medium bowl add chicken mayonnaise celery green onion mustard salt pepper and dill if using. Mix well to combine,
        Taste and season with additional salt and pepper if desired,
        Serve as a sandwich or over salad
      '''
      },
    {
      'name': 'Pancakes',
      'description': 'Fluffy pancakes for breakfast.',
      'image': 'https://img.sndimg.com/food/image/upload/f_auto,c_thumb,q_55,w_744,ar_5:4/v1/img/recipes/65/04/9/picIXtWig.jpg',
      'mealTypes': ['Breakfast', 'Brunch'],
      'favorite': false,
      'ingredients': [
        '1 ½ cups all-purpose flour',
        '3 ½ teaspoons baking powder',
        '1 tablespoon white sugar',
        '¼ teaspoon salt, or more to taste',
        '1 ¼ cups milk',
        '3 tablespoons butter, melted',
        '1 large egg',
      ],
      'cookingInstructions':''' 
        Melt the butter and set it aside. In a medium bowl whisk together the flour sugar baking powder and salt,
        In a separate bowl whisk together milk egg melted butter and vanilla extract,
        Create a well in the center of your dry ingredients. Pour in the milk mixture and stir gently with a fork until the flour is just incorporated. A few small lumps are okay. As the batter sits it should start to bubble,
        Place a large skillet or griddle over medium heat. Sprinkle in a few drops of water to test if its ready. You want them to dance around a bit and evaporate,
        Brush the skillet with melted butter,
        Scoop the batter onto the skillet using a 1/4 cup measure or large cookie scoop and spread each pancake into a 4-inch circle,
        After 1 to 2 minutes the edges will look dry and bubbles will form and pop on the surface. Flip the pancakes and cook for another 1 to 2 minutes until lightly browned and cooked in the middle,
        Serve immediately with warm syrup butter and berries,
        '''
        },
  ];

  List<Map<String, dynamic>> filteredRecipes = [];
  final TextEditingController searchController = TextEditingController();
  final List<String> mealTypes = ['All', 'Breakfast', 'Brunch', 'Lunch', 'Dinner', 'Dessert'];
  String selectedMealType = 'All';
  bool showOnlyFavorites = false;

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
        final matchesFavorite = !showOnlyFavorites || (recipe['favorite'] ?? false);
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
      showOnlyFavorites = !showOnlyFavorites;
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
    //final Color backgroundColor = Colors.brown[100]!;

    return Scaffold(
      //backgroundColor: backgroundColor,
      appBar: AppBar(
        //backgroundColor: Colors.brown[800],
        title: const Text('Recipe Book',
            //style: TextStyle(color: Colors.white)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back
              //, color: Colors.white
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Image.asset(
            'assets/recipe_icon.png',
            height: 40,
            width: 40,
          ),
          const SizedBox(width: 16),
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
                        //borderSide: const BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      //fillColor: backgroundColor,
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
                    color: showOnlyFavorites ? Color(0xfff485b1) : Colors.grey,
                    // above was formerly 'Colors.red', changed to better fit colour scheme
                  ),
                  onPressed: _toggleFavoriteFilter,
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
                          //color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              //color: Colors.grey,
                              width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 50,
                                //color: Colors.grey[600]
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Add Recipe",
                              style: TextStyle(
                                //color: Colors.purple,
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
                          //color: backgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                              //color: Colors.grey,
                              width: 1),
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
                                          //color: Colors.brown,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ),
                            Container(
                              //color: backgroundColor,
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                recipe['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  //color: Colors.pink,
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
