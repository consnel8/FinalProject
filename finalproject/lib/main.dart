import 'dart:async';
import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'recipe_book_page.dart'; // Import the recipe book page
import 'add_recipe_page.dart'; // Import the add recipe page
import 'SettingsPage.dart';
import 'colour_theme.dart' as colours;
import 'journal_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'journal_entry_model.dart';
import 'edit_journal_page.dart';
//import virtual wardrobe page here

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
      ),
    );
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
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
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
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
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
              imagePath: 'assets/wardrobe_icon.png',
              title: 'VIRTUAL WARDROBE',
              description: 'Effortlessly manage your clothing collection and plan outfits.',
              onTap: () => _navigateToBlankPage(context, 'Virtual Wardrobe'),
            ),
            FeatureCard(
              imagePath: 'assets/recipe_icon.png',
              title: 'RECIPE BOOK',
              description: 'Catalog your favorite meals.',
              onTap: () => _navigateToRecipeBook(context),
            ),
            FeatureCard(
              imagePath: 'assets/journal_icon.png',
              title: 'JOURNAL',
              description: 'Reflect on your day by writing entries, tracking moods, and capturing your thoughts.',
              onTap: () => _navigateToJournal(context),
            ),
            FeatureCard(
              imagePath: 'assets/suggestions_icon.png',
              title: 'SUGGESTIONS',
              description: 'Get recommendations based on your location for places near you to eat, shop, and explore.',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SuggestionsPage())),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewEntryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToRecipeBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecipeBookPage()),
    );
  }

  void _navigateToJournal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JournalPage()),
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

  void _showNewEntryDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Create New Entry',
            style: TextStyle(
              fontFamily: 'Teko',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.checkroom,
                  color: Colors.black,
                ),
                title: const Text(
                  'Virtual Wardrobe',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(dialogContext); // Close the dialog
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text('Creating New Wardrobe Entry...')),
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(parentContext).push(
                      MaterialPageRoute(
                        builder: (context) => const AddRecipePage(), // Navigate to wardrobe page
                      ),
                    ).then((result) {
                      if (result != null) {
                        Navigator.of(parentContext).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                    });
                  });
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.restaurant,
                  color: Colors.black,
                ),
                title: const Text(
                  'Recipe',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(dialogContext); // Close the dialog
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text('Creating New Recipe Entry...')),
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(parentContext).push(
                      MaterialPageRoute(
                        builder: (context) => const AddRecipePage(), // Navigate to recipe page
                      ),
                    ).then((result) {
                      if (result != null) {
                        Navigator.of(parentContext).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                    });
                  });
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.book,
                  color: Colors.black,
                ),
                title: const Text(
                  'Journal',
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(dialogContext); // Close the dialog
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    const SnackBar(content: Text('Creating New Journal Entry...')),
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(parentContext).push(
                      MaterialPageRoute(
                        builder: (context) => EditJournalPage(),
                      ),
                    ).then((result) async {
                      if (result != null && result is JournalEntry) {
                        // Load the current entries
                        final prefs = await SharedPreferences.getInstance();
                        final String? entriesString = prefs.getString('journal_entries');
                        List<JournalEntry> entries = [];

                        if (entriesString != null) {
                          final List<dynamic> entriesJson = json.decode(entriesString);
                          entries = entriesJson.map((entry) => JournalEntry.fromJson(entry)).toList();
                        }

                        // Add the new entry and save back
                        entries.add(result);
                        entries.sort((a, b) => b.date.compareTo(a.date));
                        await prefs.setString('journal_entries',
                            json.encode(entries.map((entry) => entry.toJson()).toList()));

                        // Reload the home screen
                        Navigator.of(parentContext).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                    });

                  });
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

  const FeatureCard({
    super.key,
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

// Suggestions Page
class SuggestionsPage extends StatefulWidget {
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
        title: Text(
          'Nearby Places to Eat, Shop & Explore',
          style: TextStyle(
            fontFamily: 'Teko',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(
          errorMessage,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white70,
          ),
        ),
      )
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
            title: Text(
              name,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '$category\n$address',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white70,
              ),
            ),
          );
        },
      ),
    );
  }
}
