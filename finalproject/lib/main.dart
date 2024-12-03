// Import Statements
import 'dart:async'; // For timing and delays
import 'dart:convert'; // For JSON encoding/decoding
import 'package:timezone/data/latest.dart' as tz; // For handling time zones
import 'package:adaptive_theme/adaptive_theme.dart'; // For adaptive themes based on system settings
import 'package:finalproject/outfit_builder.dart'; // For virtual wardrobe functionality
import 'package:flutter/material.dart'; // Flutter framework for building the UI
import 'recipe_book_page.dart'; // For the recipe book page
import 'add_recipe_page.dart'; // For adding new recipes
import 'SettingsPage.dart'; // For the settings page
import 'colour_theme.dart' as colours; // For custom colors and theme
import 'journal_page.dart'; // For the journal page
import 'package:shared_preferences/shared_preferences.dart'; // For storing and retrieving app preferences
import 'journal_entry_model.dart'; // Model for journal entries
import 'edit_journal_page.dart'; // For editing journal entries
import 'outfits_page.dart'; // For managing wardrobe outfits
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
import 'firebase_options.dart'; // For Firebase configuration options
import 'suggestions_page.dart'; // For the suggestions page

// Main function to initialize the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase using options specified in firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();
  runApp(const MyApp());
}

// Main app widget that handles theme and navigation
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
        home: const SplashScreen(),
      ),
    );
  }
}

// Splash screen displayed at the beginning of the app
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer to navigate to HomeScreen after 8 seconds
    Timer(const Duration(seconds: 8), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EDE6),
      body: Center(
        // Display logo image centered on the splash screen
        child: Image.asset(
          'assets/logo.png',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

// Main Home Screen widget with feature cards for navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Generate a greeting message based on the current time
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
            icon: const Icon(Icons.menu), // Menu icon for settings
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feature cards for navigation to different sections
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
                  color: const Color.fromARGB(255, 195, 179, 150),
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
                  _getGreeting(), // Display greeting based on time
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewEntryDialog(context), // Show dialog for creating new entries
        child: const Icon(Icons.add),
      ),
    );
  }

  // Navigation functions for each feature card
  void _navigateToVirtualWardrobe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OutfitDashboardPage()), // Navigate to wardrobe page
    );
  }

  void _navigateToRecipeBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecipeBookPage()), // Navigate to recipe book page
    );
  }

  void _navigateToJournal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JournalPage()), // Navigate to journal page
    );
  }

  void _navigateToSuggestions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuggestionsPage()), // Navigate to suggestions page
    );
  }

  // Function to show the dialog for creating new entries
  void _showNewEntryDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Create New Entry', // Dialog title
            style: TextStyle(
              fontFamily: 'Teko',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // List tiles for different types of new entries
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
                    const SnackBar(content: Text('Creating New Wardrobe Entry...')), // Show snackbar
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(parentContext).push(
                      MaterialPageRoute(
                        builder: (context) => OutfitBuilderPage(onSave: (outfit) {
                          // Add save logic here
                        }), // Navigate to wardrobe page
                      ),
                    );
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
                    const SnackBar(content: Text('Adding New Recipe...')), // Show snackbar
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(parentContext).push(
                      MaterialPageRoute(
                        builder: (context) => const AddRecipePage(), // Navigate to add recipe page
                      ),
                    );
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
                    const SnackBar(content: Text('Creating New Journal Entry...')) // Show snackbar
                  );
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.of(parentContext).push(
                      MaterialPageRoute(
                        builder: (context) => EditJournalPage(), // Navigate to add journal entry page
                      ),
                    )
                        .then((result) async {
                      if (result != null && result is JournalEntry) {
                        // Load the current entries
                        final prefs = await SharedPreferences.getInstance();
                        final String? entriesString =
                            prefs.getString('journal_entries');
                        List<JournalEntry> entries = [];

                        if (entriesString != null) {
                          final List<dynamic> entriesJson =
                              json.decode(entriesString);
                          entries = entriesJson
                              .map((entry) => JournalEntry.fromJson(entry))
                              .toList();
                        }

                        // Add the new entry and save back
                        entries.add(result);
                        entries.sort((a, b) => b.date.compareTo(a.date));
                        await prefs.setString(
                            'journal_entries',
                            json.encode(entries
                                .map((entry) => entry.toJson())
                                .toList()));

                        // Reload the home screen
                        Navigator.of(parentContext).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
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

// Custom card widget for each feature
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
              child: Image.asset(imagePath), // Display the feature icon
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // Display feature title
                    style: const TextStyle(
                      fontFamily: 'Teko',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFD2007C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description, // Display feature description
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