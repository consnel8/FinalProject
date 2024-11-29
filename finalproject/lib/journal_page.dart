import 'package:flutter/material.dart';
import 'edit_journal_page.dart';
import 'journal_entry_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For encoding/decoding the list
import 'notifications_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<JournalEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries(); // Load entries from storage when the page is created
    PermissionHandler.requestNotificationPermission();
  }

  // Load journal entries from SharedPreferences
  Future<void> _loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? entriesString = prefs.getString('journal_entries');

      if (entriesString != null) {
        final List<dynamic> entriesJson = json.decode(entriesString);
        setState(() {
          _entries =
              entriesJson.map((entry) => JournalEntry.fromJson(entry)).toList();
        });
      } else {
        _entries = [];
      }

      // Ensure at least one sample entry is present
      if (_entries.isEmpty) {
        _addSampleEntry();
      }
    }
    catch (e) {
    // Show error message via Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text('Error loading journal entries: $e'),
    backgroundColor: Colors.red,
    ),
    );
    }
  }

// Add a sample entry
  void _addSampleEntry() {
    _entries.addAll([
      JournalEntry(
        title: 'Welcome!',
        content: 'This is a sample entry to help you begin journaling! Select your mood, capture a picture and tap the save icon.',
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
    ]);

    _saveEntries(); // Save the updated entries list to storage
  }

  // Save journal entries to SharedPreferences
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> entriesJson =
        _entries.map((entry) => entry.toJson()).toList();
    await prefs.setString('journal_entries', json.encode(entriesJson));
  }

  // Method to get mood icon
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

  // Method to get mood color
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

  void _searchByDate(DateTime selectedDate) {
    setState(() {
      _entries = _entries.where((entry) {
        return entry.date.year == selectedDate.year &&
            entry.date.month == selectedDate.month &&
            entry.date.day == selectedDate.day;
      }).toList();
    });
  }

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

  int checkcount2 = 0;

  void scheduleAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "Schedule Daily Notifications",
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 18,
          ),
        ),
        content: const Text(
          "Would you like to schedule daily notifications to journal?",
          style: TextStyle(
            fontFamily: 'Lora',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              checkcount2 = 2;
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
              PermissionHandler.enableDaily();
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
                        checkcount2 = 1;
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
                            child: Image.asset(
                              entry.imageUrl!,
                              height: 150,
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
                onPressed: () {}),
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
