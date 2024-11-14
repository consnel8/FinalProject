import 'dart:async';
import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'recipe_book_page.dart'; // Import the recipe book page
import 'SettingsPage.dart';
import 'colour_theme.dart' as colours;
//import virtual wardrobe page here
//import journal page here

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: colours.AppTheme.light,
        dark: colours.AppTheme.dark,
        initial: AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          theme: colours.AppTheme.light,
          darkTheme: colours.AppTheme.dark,
          themeMode: theme == colours.AppTheme.light ? ThemeMode.light : ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
    ));
  }
}

// Splash screen that leads to the HomeScreen after a delay
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 8 seconds before navigating to HomeScreen
    Timer(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3A3A),
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

// Main Home Screen with Feature Cards for different functionalities
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: const Color(0xFF3A3A3A), // Dark header color
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40), // Logo image
            const SizedBox(width: 20),
            const Text(
              'Life Palette',
              style: TextStyle(
                fontFamily: 'Teko',
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
                fontSize: 30,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu,
                //color: Colors.white
            ), // Three-line menu icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeatureCard(
              imagePath: 'assets/wardrobe_icon.png', // Virtual Wardrobe icon
              title: 'VIRTUAL WARDROBE',
              description: 'Effortlessly manage your clothing collection and plan outfits.',
              onTap: () => _navigateToBlankPage(context, 'Virtual Wardrobe'),
            ),
            FeatureCard(
              imagePath: 'assets/recipe_icon.png', // Recipe Book icon
              title: 'RECIPE BOOK',
              description: 'Catalog your favorite meals.',
              onTap: () => _navigateToRecipeBook(context), // Navigate to Recipe Book
            ),
            FeatureCard(
              imagePath: 'assets/journal_icon.png', // Journal icon
              title: 'JOURNAL',
              description: 'Reflect on your day by writing entries, tracking moods, and capturing your thoughts.',
              onTap: () => _navigateToBlankPage(context, 'Journal'),
            ),
            FeatureCard(
              imagePath: 'assets/suggestions_icon.png', // Suggestions icon
              title: 'SUGGESTIONS',
              description: 'Get recommendations based on your location for places near you to eat, shop, and explore.',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SuggestionsPage())),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewEntryDialog(context),
        //backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToRecipeBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecipeBookPage()), // Navigate to RecipeBookPage
    );
  }

  void _navigateToBlankPage(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlankPage(title: title),
      ),
    );
  }

  void _showNewEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Entry', style: TextStyle(fontFamily: 'Teko', fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.checkroom), // Wardrobe icon
                title: const Text('Virtual Wardrobe', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Creating New Virtual Wardrobe Entry...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.restaurant), // Recipe icon
                title: const Text('Recipe', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Creating New Recipe Entry...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.book), // Journal icon
                title: const Text('Journal', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Creating New Journal Entry...')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Custom card widget for different features
class FeatureCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final VoidCallback onTap;

  const FeatureCard({super.key, 
    required this.imagePath,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: Image.asset(imagePath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Teko',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFD2007C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Lora',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      //color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  final String title;

  const BlankPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Teko', fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Text('This is a blank page for $title.', style: const TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
      ),
    );
  }
}

/*
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontFamily: 'Teko', fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('This is the settings page.', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
      ),
    );
  }
}
*/

// Suggestions page that fetches nearby places
class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  List<dynamic> nearbyPlaces = [];
  bool isLoading = true;
  String errorMessage = '';

  final String foursquareApiKey = "fsq3GOZ7uhN/MS2jobaLIO0xPFO8b5M7gVzLp3YK79MmSU0=";

  @override
  void initState() {
    super.initState();
    _fetchNearbyPlaces();
  }

  Future<void> _fetchNearbyPlaces() async {
    try {
      Position position = await _determinePosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      String url =
          'https://api.foursquare.com/v3/places/nearby?ll=$latitude,$longitude&radius=5000&limit=20';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": foursquareApiKey,
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['results'] != null) {
          Set<dynamic> allPlaces = {};

          for (var place in data['results']) {
            allPlaces.add(place);
          }

          setState(() {
            nearbyPlaces = allPlaces.toList();
            isLoading = false;
          });
        }
      } else {
        throw 'Failed to load data with status code ${response.statusCode}';
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places to Eat, Shop & Explore', style: TextStyle(fontFamily: 'Teko', fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: nearbyPlaces.length,
                  itemBuilder: (context, index) {
                    var place = nearbyPlaces[index];
                    String name = place['name'] ?? 'Unknown Name';
                    String address = place['location']?['address'] ?? 'Unknown Address';
                    String category = place['categories'] != null
                        ? place['categories'][0]['name'] ?? 'Unknown Category'
                        : 'Unknown Category';

                    return ListTile(
                      title: Text(name),
                      subtitle: Text('$category\n$address'),
                    );
                  },
                ),
    );
  }
}
