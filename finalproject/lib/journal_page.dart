import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back navigation
          },
        ),
        title: Row(
          children: [
            // Vertical black separator before the title
            Container(
              height: 60, // Height of the separator line
              width: 2, // Thickness of the line
              color: Colors.black, // Line color
            ),
            SizedBox(width: 16), // Space between the separator and the title
            // Title
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the title
                children: [
                  const Text(
                    'PERSONAL JOURNAL',
                    style: TextStyle(
                      fontSize: 20, // Set font size for the title
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16), // Space between the title and the next separator
            // Vertical black separator after the title
            Container(
              height: 60, // Height of the separator line
              width: 2, // Thickness of the line
              color: Colors.black, // Line color
            ),
            SizedBox(width: 16), // Space between the separator and the logo
            // Right-aligned logo image
            Image.asset(
              'assets/journal_icon.png', // Add your logo image in the assets folder
              height: 70, // Set the size of your logo
            ),
          ],
        ),
        toolbarHeight: 80, // Increase the height of the AppBar
      ),
      body: const Center(
        child: Text('Start your journey by adding a new entry.'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.insights), // Insights button
              onPressed: () {
                _showInsights(context); // Show insights
              },
            ),
            IconButton(
              icon: const Icon(Icons.add), // Add entry button
              onPressed: () {
                _addNewEntry(context); // Add new journal entry
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today), // Calendar button
              onPressed: () {
                _searchByDate(context); // Search by date
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showInsights(BuildContext context) {
    // Implement insights functionality here
  }

  void _addNewEntry(BuildContext context) {
    // Implement add new entry functionality here
  }

  void _searchByDate(BuildContext context) {
    // Implement date search functionality here
  }
}