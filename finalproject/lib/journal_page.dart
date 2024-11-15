import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // List to hold journal entries
  List<JournalEntry> _entries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe8dcd4),
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
            SizedBox(width: 16),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: const Text(
                  'PERSONAL JOURNAL',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(width: 16),
            Container(
              height: 60,
              width: 2,
              color: Colors.black,
            ),
            SizedBox(width: 16),
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
        child: Text('Start your journey by adding a new entry.'),
      )
          : ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          String shortContent = entry.content.length > 200
              ? entry.content.substring(0, 200) + '...'
              : entry.content; // Shortened entry
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
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  shortContent,  // Display shortened entry
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                "${entry.date.toLocal()}".split(' ')[0],
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            onTap: () {
              // Show full entry when tapped
              _showEntryDetails(context, entry);
            },
          );
        },
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
                _showInsights(context);
              },
            ),
            Container(
              height: 60,
              width: 2,
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              iconSize: 35.0,
              onPressed: () {
                _addNewEntry(context);
              },
            ),
            Container(
              height: 60,
              width: 2,
              color: Colors.black,
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              iconSize: 35.0,
              onPressed: () {
                _searchByDate(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showInsights(BuildContext context) {
    // insights functionality here
  }

  void _searchByDate(BuildContext context) {
    // date search functionality here
  }

  // Show the full journal entry
  void _showEntryDetails(BuildContext context, JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            entry.title,
            style: const TextStyle(
              color: Color(0xFFBE3B88),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            entry.content,
            style: const TextStyle(
              color: Colors.grey, //entry color
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Add a new journal entry
  void _addNewEntry(BuildContext context) async {
    final newEntry = await _showAddEntryDialog(context);
    if (newEntry != null) {
      setState(() {
        _entries.add(newEntry);
        // Sort the entries by date (newest first)
        _entries.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }

  // Placeholder dialog for adding a new journal entry
  Future<JournalEntry?> _showAddEntryDialog(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return showDialog<JournalEntry>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Journal Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 4,
              ),
              ListTile(
                title: Text('Date: ${selectedDate.toLocal()}'.split(' ')[0]),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                  final newEntry = JournalEntry(
                    title: titleController.text,
                    content: contentController.text,
                    date: selectedDate,
                  );
                  Navigator.of(context).pop(newEntry);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

// Journal Entry model
class JournalEntry {
  final String title;
  final String content;
  final DateTime date;

  JournalEntry({
    required this.title,
    required this.content,
    required this.date,
  });
}
