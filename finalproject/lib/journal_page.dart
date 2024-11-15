import 'package:flutter/material.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  // List holds journal entries
  List<JournalEntry> _entries = [];

  // Utility function to format the date
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    // Calculate how many days ago
    String daysAgoText = difference == 0
        ? "Today"
        : difference == 1
        ? "1 day ago"
        : "$difference days ago";

    // Format the date as "MMM D, YYYY"
    String formattedDate = "${getMonthAbbreviation(date.month)} ${date.day}, ${date.year}";

    return "$daysAgoText | $formattedDate";
  }

  // Helper function to get the month abbreviation
  String getMonthAbbreviation(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

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
        child: Text('Start your journey by adding a new entry.'),
      )
          : Scrollbar(
        thumbVisibility: false,
        thickness: 8.0,
        radius: const Radius.circular(10),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shortContent,
                    style: const TextStyle(
                      color: Color(0xFF787878),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  formatDate(entry.date),
                  style: const TextStyle(
                    color: Color(0xFF4e4e4e),
                  ),
                ),
              ),
              onTap: () {
                _navigateToEditPage(context, entry);
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: Color(0xFFcfcfcf), // Separator between entries
            thickness: 1,
          ),
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
                _navigateToEditPage(context, null); // Pass null for a new entry
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

  // Navigation for editing or adding a new entry
  void _navigateToEditPage(BuildContext context, JournalEntry? entry) async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditJournalPage(entry: entry),
      ),
    );
    if (updatedEntry != null) {
      setState(() {
        if (entry == null) {
          // Add a new entry
          _entries.add(updatedEntry);
        } else {
          // Edit the existing entry
          final index = _entries.indexOf(entry);
          if (index != -1) {
            _entries[index] = updatedEntry;
          }
        }
        // Sort the entries by date (newest first)
        _entries.sort((a, b) => b.date.compareTo(a.date));
      });
    }
  }
}

// Edit/Adding journal entry
class EditJournalPage extends StatefulWidget {
  final JournalEntry? entry;

  const EditJournalPage({Key? key, this.entry}) : super(key: key);

  @override
  _EditJournalPageState createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _titleController = TextEditingController(text: widget.entry!.title);
      _contentController = TextEditingController(text: widget.entry!.content);
      _selectedDate = widget.entry!.date;
    } else {
      _titleController = TextEditingController();
      _contentController = TextEditingController();
      _selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'Add New Entry' : 'Edit Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 4,
            ),
            ListTile(
              title: Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _selectedDate) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  final entry = JournalEntry(
                    title: _titleController.text,
                    content: _contentController.text,
                    date: _selectedDate,
                  );
                  Navigator.of(context).pop(entry);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
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
