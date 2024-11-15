import 'package:flutter/material.dart';
import 'edit_journal_page.dart';
import 'journal_entry_model.dart';
import 'dart:io';
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
    _loadEntries();  // Load entries from storage when the page is created
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
    }
  }

  // Save journal entries to SharedPreferences
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> entriesJson = _entries.map((entry) => entry.toJson()).toList();
    await prefs.setString('journal_entries', json.encode(entriesJson));
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
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
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
          ? const Center(child: Text('Start your journey by adding a new entry.'))
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
                      child: Image.file(
                        File(entry.imageUrl!),
                        height: 200, // Set a fixed height for the image
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(formatDate(entry.date),
                    style: const TextStyle(color: Color(0xFF4e4e4e))),
              ),
              onTap: () {
                _navigateToEditPage(context, entry);
              },
            );
          },
          separatorBuilder: (context, index) =>
          const Divider(color: Color(0xFFcfcfcf), thickness: 1),
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
            IconButton(
                icon: const Icon(Icons.add),
                iconSize: 35.0,
                onPressed: () {
                  _navigateToEditPage(context, null);
                }),
            IconButton(
                icon: const Icon(Icons.calendar_today),
                iconSize: 35.0,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, JournalEntry? entry) async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditJournalPage(entry: entry)),
    );
    if (updatedEntry != null) {
      setState(() {
        if (entry == null) {
          _entries.add(updatedEntry);
        } else {
          final index = _entries.indexOf(entry);
          if (index != -1) {
            _entries[index] = updatedEntry;
          }
        }
        _entries.sort((a, b) => b.date.compareTo(a.date));
        _saveEntries(); // Save entries after they are updated
      });
    }
  }
}
