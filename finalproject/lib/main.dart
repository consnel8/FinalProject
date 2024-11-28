// Import statements
import 'dart:async';
import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:finalproject/wardrobe/outfit_builder.dart';
import 'package:flutter/material.dart';
import 'recipe_book_page.dart';
import 'add_recipe_page.dart';
import 'SettingsPage.dart';
import 'colour_theme.dart' as colours;
import 'journal_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'journal_entry_model.dart';
import 'edit_journal_page.dart';
import 'wardrobe/outfits_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'suggestions_page.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
// Initialize Firebase with the options from firebase_options.dart
await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning! A new day brings new opportunities. Step forward with confidence and let your light shine!';
    } else if (hour < 18) {
      return 'Good Afternoon! Let the warmth of the afternoon sun remind you that progress is built moment by moment. Keep going!';
    } else {
      return 'Good Night! Close your eyes, let go of today’s worries, and trust in the magic of a new dawn. Sweet dreams!';
    }
  }

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
              onTap: () => _navigateToVirtualWardrobe(context),
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
              onTap: () => _navigateToSuggestions(context),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16), 
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 195, 179, 150),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                _getGreeting(),
                style: const TextStyle(
                  fontFamily: 'Teko',
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
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

  void _navigateToVirtualWardrobe(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OutfitDashboardPage()),
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

  void _navigateToSuggestions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuggestionsPage()),
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
                        builder: (context) =>  OutfitBuilderPage(onSave: (outfit) {
                          // Add save logic here
                        }), // Navigate to wardrobe page
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