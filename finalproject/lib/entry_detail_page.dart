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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final newEntry = JournalEntry(
                  title: titleController.text,
                  content: contentController.text,
                  date: selectedDate,
                );
                Navigator.of(context).pop(newEntry); // Return the new entry to the previous page
              },
              child: Text(widget.entry == null ? 'Add Entry' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
