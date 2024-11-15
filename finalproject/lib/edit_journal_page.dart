import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker package
import 'journal_entry_model.dart'; // Your model

class EditJournalPage extends StatefulWidget {
  final JournalEntry? entry;

  const EditJournalPage({Key? key, this.entry}) : super(key: key);

  @override
  _EditJournalPageState createState() => _EditJournalPageState();
}

class _EditJournalPageState extends State<EditJournalPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _imageFile; // To hold the picked image file
  DateTime? _selectedDate; // To store the selected date

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the existing journal entry (if any)
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;
      _imageFile = widget.entry!.imageUrl != null
          ? File(widget.entry!.imageUrl!)
          : null; // Load existing image if present
      _selectedDate = widget.entry!.date; // Load existing date if present
    } else {
      _selectedDate = DateTime.now(); // Default to the current date if no entry is provided
    }
  }

  // Method to pick an image from the camera
  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the captured image file
      });
    }
  }

  // Method to show the DatePicker and select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = _selectedDate ?? DateTime.now();
    final DateTime firstDate = DateTime(2000);
    final DateTime lastDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Update the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Keep the background transparent
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove the shadow for the diary look
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back navigation
          },
        ),
        title: const Text('Edit Entry'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/journal_diary_icon.jpg'), // Background image
            fit: BoxFit.cover, // Ensure the image covers the screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none, // No border for the diary look
                  filled: true,
                  fillColor: Colors.transparent, // Transparent input box
                ),
              ),
              const SizedBox(height: 16),
              // Date Picker Text Field
              GestureDetector(
                onTap: () => _selectDate(context), // Trigger date picker on tap
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                        text: _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : 'Select Date'),
                    decoration: InputDecoration(
                      labelText: 'Date',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Your journal entry...',
                  hintStyle: TextStyle(height: 1.5),
                  border: InputBorder.none, // No border for the diary look
                  filled: true,
                  fillColor: Colors.transparent, // Transparent input box
                  contentPadding: EdgeInsets.only(left: 15.0, top: 20.0),
                ),
              ),
              const SizedBox(height: 16),
              // Display the picked or captured image if any
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 200, // You can adjust the height based on your preference
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF393634), // Brown color for the bottom bar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Camera Button to capture an image
            IconButton(
              icon: const Icon(Icons.camera_alt),
              iconSize: 35.0,
              onPressed: _captureImage, // Capture an image
            ),
            // Save Entry Button
            IconButton(
              icon: const Icon(Icons.save),
              iconSize: 35.0,
              onPressed: () {
                // Save the journal entry with title, content, image, and selected date
                final updatedEntry = JournalEntry(
                  title: _titleController.text,
                  content: _contentController.text,
                  imageUrl: _imageFile?.path, // Save the file path as the image URL
                  date: _selectedDate ?? DateTime.now(), // Use selected date or default to now
                );

                Navigator.pop(context, updatedEntry); // Return the updated entry
              },
            ),
          ],
        ),
      ),
    );
  }
}
