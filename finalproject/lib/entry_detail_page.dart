import 'package:flutter/material.dart';
import 'journal_page.dart';

class EntryDetailPage extends StatefulWidget {
  final JournalEntry? entry;

  const EntryDetailPage({Key? key, this.entry}) : super(key: key);

  @override
  _EntryDetailPageState createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      titleController = TextEditingController(text: widget.entry!.title);
      contentController = TextEditingController(text: widget.entry!.content);
      selectedDate = widget.entry!.date;
    } else {
      titleController = TextEditingController();
      contentController = TextEditingController();
      selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New Entry' : 'Edit Entry'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/journal_entry_icon.png'), // Background texture (like a paper)
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Overlay for title and content
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Slight dark overlay for readability
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(  // Added to make the content scrollable
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title TextField
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(fontFamily: 'DancingScript', fontSize: 24), // A cursive font for diary style
                        border: InputBorder.none,
                        hintText: 'Enter your diary title',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      style: TextStyle(fontFamily: 'DancingScript', fontSize: 28), // Match the font for the content
                    ),
                    const Divider(color: Colors.white, thickness: 1), // Divider between title and content

                    // Content TextField
                    TextField(
                      controller: contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: InputBorder.none,
                        hintText: 'Start typing your diary entry...',
                        hintStyle: TextStyle(fontSize: 18, color: Color(0xFF757575)),
                      ),
                      maxLines: null, // Allow for multiline input
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 20, fontFamily: 'DancingScript'), // Diary-style font
                    ),

                    const SizedBox(height: 20),

                    // Date Picker
                    ListTile(
                      title: Text(
                        'Date: ${selectedDate.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontFamily: 'DancingScript', fontSize: 18),
                      ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
