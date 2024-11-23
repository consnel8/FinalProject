import 'package:flutter/material.dart';
import 'edit_journal_page.dart';
import 'journal_entry_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';  // For encoding/decoding the list

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
  }

  // Load journal entries from SharedPreferences
  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesString = prefs.getString('journal_entries');

    if (entriesString != null) {
      final List<dynamic> entriesJson = json.decode(entriesString);
      setState(() {
        _entries = entriesJson.map((entry) => JournalEntry.fromJson(entry)).toList();
      });
    } else {
      _entries = [];
    }

    // Ensure at least one sample entry is present
    if (_entries.isEmpty) {
      _addSampleEntry();
    }
  }

// Add a sample entry
  void _addSampleEntry() {
    _entries.addAll([
      JournalEntry(
        title: 'Welcome!',
        content: 'This is a sample entry to help you get started.',
        date: DateTime.now(),
        imageUrl: 'assets/journal_icon.png', // First pre-written entry
      ),
      JournalEntry(
        title: 'Journal Entry 2',
        content: 'Today felt like a small victory. I finally finished that coding project '
            'I have been working on for weeks. It was not perfect, but seeing it all come together gave me a huge sense'
            'of accomplishment. I took some time to celebrate this milestone by treating myself to my favourite coffee at the cute cafe nearby.'
            'I cannot wait to see what next week has to offer for me!',
        date: DateTime.now().subtract(Duration(days: 1)),
        imageUrl: 'assets/journal_entry2.jpg',
      ),
    ]);

    _saveEntries(); // Save the updated entries list to storage
  }


  // Save journal entries to SharedPreferences
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> entriesJson = _entries.map((entry) =>
        entry.toJson()).toList();
    await prefs.setString('journal_entries', json.encode(entriesJson));
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
      /*
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFbe3b88), // Header color and selected date
              onPrimary: Colors.white,    // Text color on the header
              surface: Colors.white,      // Background color of the picker
              onSurface: Colors.black,    // Text color in the calendar grid
              onSecondary: Color(0xFFbe3b88), // For active elements like buttons
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFDCB65D)), // Button color
            ),
          ),
          child: child!,
        );
      },

       */
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

    String formattedDate = "${getMonthAbbreviation(date.month)} ${date.day}, ${date.year}";

    return "$daysAgoText | $formattedDate";
  }

  String getMonthAbbreviation(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
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
                  style: TextStyle(fontSize: 20),
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
          child: Text('Start your journey by adding a new entry.'))
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
                  Text(entry.title,
                      style: const TextStyle(
                          color: Color(0xFFBE3B88),
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(shortContent,
                      style: const TextStyle(
                          color: Color(0xFF787878), fontSize: 16)),
                  // Display the image below the entry content if available
                  if (entry.imageUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Image.asset(
                        entry.imageUrl!,
                        height: 150, // Set a fixed height for the image
                        fit: BoxFit.cover,
                      ),
                    )
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(formatDate(entry.date),
                    style: const TextStyle(color: Color(0xFF2e2e2e))),
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
                  _searchByDate(selectedDate);  // Filter entries by selected date
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
