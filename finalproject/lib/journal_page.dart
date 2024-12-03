import 'package:flutter/material.dart';
// Import for editing journal entries
import 'edit_journal_page.dart';
// Import for the journal entry model
import 'journal_entry_model.dart';
// Import for insights page
import 'journal_insights_page.dart';
// SharedPreferences for storage
import 'package:shared_preferences/shared_preferences.dart';
// Import for JSON encoding/decoding
import 'dart:convert';
// Notifications page import
import 'notifications_page.dart';
// Import for handling file operations
import 'dart:io';

// Stateful widget for the journal page
class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // List to store journal entries
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries(); // Load saved entries on initialization
    PermissionHandler.requestNotificationPermission(); // Request notification permission
  }

  // Loads journal entries from SharedPreferences
  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? entriesString = prefs.getString('journal_entries');

      if (entriesString != null) {
        // Decode JSON and convert to list of entries
        final List<dynamic> entriesJson = json.decode(entriesString);
        setState(() {
          _entries =
              entriesJson.map((entry) => JournalEntry.fromJson(entry)).toList();
        });
      } else {
        _entries = []; // Initialize with an empty list if no entries found
      }

      // Add a sample entry if no entries exist
      if (_entries.isEmpty) {
        _addSampleEntry();
      }
    } catch (e) {
      // Show error using a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading journal entries: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Adds sample entries to the journal
  void _addSampleEntry() {
    _entries.addAll([
      JournalEntry(
        title: 'Welcome!',
        content:
        'This is a sample entry to help you begin journaling! We use local storage to log moods, view mood trends and insights, use our built-in camera to capture images and tap the save icon.',
        date: DateTime.now(),
        imageUrl: 'assets/journal_icon.png', // First pre-written entry
      ),
      JournalEntry(
        title: 'Journal Entry 2',
        content:
        'Today felt like a small victory. I finally finished that coding project '
            'I have been working on for weeks. It was not perfect, but seeing it all come together gave me a huge sense'
            'of accomplishment. I took some time to celebrate this milestone by treating myself to my favourite coffee at the cute cafe nearby.'
            'I cannot wait to see what next week has to offer for me!',
        date: DateTime.now().subtract(Duration(days: 1)),
        imageUrl: 'assets/journal_entry2.jpg',
        mood: 'Motivated 🎯',
      ),
      JournalEntry(
        title: 'Rainy Day Reflections',
        content:
        'It’s a gloomy, rainy day outside, and I’ve been feeling a little off today. Sometimes it’s hard to shake off the feeling of '
            'being overwhelmed with everything that’s going on. But I’m reminding myself that it’s okay to have these days. Tomorrow is a '
            'new day, and I’m ready to tackle whatever comes my way.',
        date: DateTime.now().subtract(Duration(days: 3)),
        mood: 'Sad 🌧️',
      ),
      JournalEntry(
        title: 'Productivity Boost',
        content:
        'I woke up early today and started working on my personal projects. It feels amazing to be so productive and focused. '
            'I managed to complete two major tasks that I’ve been procrastinating on. I’m learning to take breaks in between, so I don’t burn '
            'myself out. The balance is key, and today I’ve got it just right.',
        date: DateTime.now().subtract(Duration(days: 4)),
        mood: 'Motivated 🎯',
      ),
      JournalEntry(
        title: 'A Quiet Sunday',
        content:
        'Today was all about taking it slow. I spent the morning reading a book, followed by a long walk in the park. It’s important '
            'to recharge, and today was the perfect opportunity to do that. I feel refreshed and ready to take on the week ahead.',
        date: DateTime.now().subtract(Duration(days: 5)),
        mood: 'Relaxed 🧘',
      ),
      JournalEntry(
        title: 'Challenges at Work',
        content:
        'Today was a challenging day at work. There were some unexpected obstacles in the project I’m working on. It’s moments like these '
            'that really test your patience and problem-solving skills. I know I’ll get through it, but it’s definitely a reminder of how important '
            'it is to stay calm under pressure.',
        date: DateTime.now().subtract(Duration(days: 6)),
        mood: 'Stressed 😓',
      ),
      JournalEntry(
        title: 'Gratitude Check',
        content:
        'I took a moment today to reflect on all the things I’m grateful for: my family, my friends, my health, and the opportunities I have. '
            'Sometimes, we get caught up in what’s not going well, but today I focused on the positives. It made such a difference in my mindset.',
        date: DateTime.now().subtract(Duration(days: 7)),
        mood: 'Grateful 🙏',
      ),
      JournalEntry(
        title: 'Exciting News',
        content:
        'Today was full of excitement! I received great news about a project I’ve been working on for weeks. It’s incredibly fulfilling to see '
            'hard work pay off. Celebrated the achievement with friends!',
        date: DateTime.now().subtract(Duration(days: 2)),
        mood: 'Excited 🎉',
      ),
      JournalEntry(
        title: 'Peaceful Evening',
        content:
        'Had a calm and peaceful evening today. Listened to some soothing music, lit a candle, and just enjoyed the quiet moment.',
        date: DateTime.now().subtract(Duration(days: 7)),
        mood: 'Relaxed 🧘',
      ),
      JournalEntry(
        title: 'Energetic Morning',
        content:
        'Started the day with a quick jog in the park. The fresh air and morning sunlight were rejuvenating. Feeling so energized!',
        date: DateTime.now().subtract(Duration(days: 8)),
        mood: 'Happy 😊',
      ),
      JournalEntry(
        title: 'Tough Decisions',
        content:
        'Faced some tough decisions today. It’s hard to know if I’m making the right call, but I’m trusting my instincts and taking it one step at a time.',
        date: DateTime.now().subtract(Duration(days: 9)),
        mood: 'Stressed 😓',
      ),
      JournalEntry(
        title: 'Simple Joys',
        content:
        'Enjoyed a delicious cup of coffee and an inspiring book. Sometimes it’s the little things that bring the most happiness.',
        date: DateTime.now().subtract(Duration(days: 10)),
        mood: 'Grateful 🙏',
      ),
      JournalEntry(
        title: 'Milestone Achieved',
        content:
        'Reached a significant milestone in my fitness journey today. All the hard work has been worth it!',
        date: DateTime.now().subtract(Duration(days: 11)),
        mood: 'Motivated 🎯',
      ),
      JournalEntry(
        title: 'Catch-Up Day',
        content:
        'Spent the day catching up on emails and chores. Not the most exciting, but necessary to feel organized.',
        date: DateTime.now().subtract(Duration(days: 12)),
        mood: 'Neutral 😐',
      ),
      JournalEntry(
        title: 'Surprise Gift',
        content:
        'Received a thoughtful gift from a friend today. It’s moments like these that remind me of how lucky I am to have amazing people around.',
        date: DateTime.now().subtract(Duration(days: 13)),
        mood: 'Happy 😊',
      ),
      JournalEntry(
        title: 'Teamwork Triumph',
        content:
        'Collaborated with the team today to overcome a major hurdle. Feeling accomplished and grateful for their support.',
        date: DateTime.now().subtract(Duration(days: 14)),
        mood: 'Grateful 🙏',
      ),
      JournalEntry(
        title: 'Weekend Fun',
        content:
        'Had a blast at the amusement park with friends. So much laughter and fun!',
        date: DateTime.now().subtract(Duration(days: 15)),
        mood: 'Excited 🎉',
      ),
    ]);

    _saveEntries(); // Save the updated list to storage
  }

  // Saves journal entries to SharedPreferences
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert entries to JSON before saving
    final List<Map<String, dynamic>> entriesJson =
    _entries.map((entry) => entry.toJson()).toList();
    await prefs.setString('journal_entries', json.encode(entriesJson));
  }

  // Maps a mood string to an appropriate icon
  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_satisfied;
      case 'hungry':
        return Icons.food_bank_outlined;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'excited':
        return Icons.sentiment_very_satisfied_outlined;
      case 'motivated':
        return Icons.snowboarding;
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_very_satisfied;
    }
  }

  // Maps a mood string to a corresponding color
  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.yellow;
      case 'neutral':
        return Colors.grey;
      case 'sad':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  // Filters journal entries by a specific date
  void _searchByDate(DateTime selectedDate) {
    setState(() {
      _entries = _entries.where((entry) {
        return entry.date.year == selectedDate.year &&
            entry.date.month == selectedDate.month &&
            entry.date.day == selectedDate.day;
      }).toList();
    });
  }

  // Opens a date picker dialog
  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: Color(0xFF55acee), // Header color
            colorScheme: ColorScheme.light(primary: Color(0xFF55acee)),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFBE3B88),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    return picked;
  }

  // Formats a date to a string with relative time
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    String daysAgoText = difference == 0
        ? "Today"
        : difference == 1
        ? "1 day ago"
        : "$difference days ago";

    String formattedDate =
        "${getMonthAbbreviation(date.month)} ${date.day}, ${date.year}";

    return "$daysAgoText | $formattedDate";
  }

  // Converts a numeric month to a short name
  String getMonthAbbreviation(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  int checkcount2 = 0; // Tracks the notification dialog state

  // Schedules a notification with a confirmation dialog
  void scheduleAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text(
          "Would you like to schedule daily notifications to journal?",
          style: TextStyle(
            fontFamily: 'Lora',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              checkcount2 = 2; // Cancel action
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
              PermissionHandler.enableDaily(); // Schedule notifications
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: const Text(
                    "Daily Notification Scheduled.",
                    style: TextStyle(fontFamily: 'Lora'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        checkcount2 = 1; // Confirm action
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


  // Display image based on whether it's an asset or file path
  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(imageUrl); // Use asset for asset-based images
    } else {
      // Use file-based images for captured images
      return Image.file(File(imageUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFe8dcd4),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back navigation
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                if ((checkcount2 == 0 || checkcount2 == 2)) {
                  scheduleAlert();
                  checkcount2 = 1;
                } else if ((checkcount2 == 1)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: const Text(
                        "Your daily notification is already scheduled.",
                        style: TextStyle(fontFamily: 'Lora'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "OK",
                            style: TextStyle(fontFamily: 'Lora'),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            checkcount2 = 0;
                            const snackBar = SnackBar(
                                content: Text("Disabled daily notification"));
                            PermissionHandler.disableDaily();
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
        title: Row(
          children: [
            Container(
              height: 60,
              width: 2,
              color: Colors.black,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'PERSONAL JOURNAL',
                  style: TextStyle(fontSize: 28, fontFamily: 'Teko'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              height: 60,
              width: 2,
              color: Colors.black,
            ),
            const SizedBox(width: 16),
            Image.asset(
              'assets/journal_icon.png',
              height: 60,
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text(
              'Start your journey by adding a new entry.',
              style: TextStyle(fontFamily: 'Lora'),
            ))
          : Scrollbar(
              child: ListView.separated(
                itemCount: _entries.length,
                itemBuilder: (context, index) {
                  final entry = _entries[index];
                  String shortContent = entry.content.length > 200
                      ? entry.content.substring(0, 200) + '...'
                      : entry.content;
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: const TextStyle(
                              color: Color(0xFFBE3B88),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoMono'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                shortContent,
                                style: const TextStyle(
                                    color: Color(0xFF787878),
                                    fontSize: 16,
                                    fontFamily: 'Lora'),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        // Display the image below the entry content if available
                        if (entry.imageUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: entry.imageUrl!.startsWith('assets/')
                                ? Image.asset(
                              entry.imageUrl!,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              File(entry.imageUrl!),
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(formatDate(entry.date),
                          style: const TextStyle(
                              color: Color(0xff252525), fontFamily: 'Lora')),
                    ),
                    onTap: () {
                      _navigateToEditPage(context, entry);
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    const Divider(color: Color(0xFFb1b1b1), thickness: 1),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF393634),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(Icons.insights),
                iconSize: 35.0,
                onPressed: () {
                  // Navigate to the insights page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JournalInsightsPage(entries: _entries),
                    ),
                  );
                }),
            Container(
              height: 60, // Height of the separator
              width: 2, // Width of the separator
              color: Colors.black, // Color of the separator
            ),
            IconButton(
                icon: const Icon(Icons.add),
                iconSize: 45.0,
                onPressed: () {
                  _navigateToEditPage(context, null);
                }),
            Container(
              height: 60, // Height of the separator
              width: 2, // Width of the separator
              color: Colors.black, // Color of the separator
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              iconSize: 35.0,
              onPressed: () async {
                final DateTime? selectedDate = await _selectDate(context);
                if (selectedDate != null) {
                  _searchByDate(
                      selectedDate); // Filter entries by selected date
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, JournalEntry? entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditJournalPage(entry: entry)),
    );

    if (result == 'delete' && entry != null) {
      // Remove the entry from the list
      setState(() {
        _entries.remove(entry);
        _saveEntries(); // Save entries after deletion
      });
    } else if (result != null && result is JournalEntry) {
      // Handle entry updates
      setState(() {
        if (entry == null) {
          _entries.add(result);
        } else {
          final index = _entries.indexOf(entry);
          if (index != -1) {
            _entries[index] = result;
          }
        }
        _entries.sort((a, b) => b.date.compareTo(a.date));
        _saveEntries(); // Save entries after they are updated
      });
    }
  }
}
