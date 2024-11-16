import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker package
import 'journal_entry_model.dart';

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
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFbe3b88), // Primary color for the header
              onPrimary: Colors.white,    // Text color for the header
              surface: Colors.white,      // Background color of the picker
              onSurface: Colors.black,    // Text color for calendar grid
              secondary: Color(0xFFbe3b88), // Active date selection color
              onSecondary: Colors.white,   // Text color for active date
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFDCB65D)), // Updated to use foregroundColor
            ),
          ),
          child: child!,
        );
      },
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
        backgroundColor: Color(0xFF393634),
        elevation: 0, // Remove the shadow for the diary look
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back navigation
          },
        ),
        title: const Text('Edit Entry'),
        actions: widget.entry != null
            ? [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Confirm before deleting
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Entry'),
                  content: const Text('Are you sure you want to delete this entry?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Cancel
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.pop(context, 'delete'); // Signal deletion to parent
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ]
            : null,
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
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none, // No border for the diary look
                  filled: true,
                  fillColor: Colors.transparent, // Transparent input box
                ),
                style: TextStyle(
                  fontSize: 30, // Make the font size large
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFbe3b88),
                  fontFamily: 'RobotoMono',
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
                      labelText: 'Select Date',
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Color(0xFFbe3b88), // Style the text in the field
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
                  hintStyle: TextStyle(height: 3),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 20.0),
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IndieFlower',
                ),
              ),
              const SizedBox(height: 16),
              // Display the picked or captured image if any
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              // Check if image is a local file or asset path
              if (widget.entry?.imageUrl != null && _imageFile == null)
                widget.entry!.imageUrl!.startsWith('assets/')
                    ? Image.asset(widget.entry!.imageUrl!) // For asset images
                    : Image.file(File(widget.entry!.imageUrl!)), // For file images
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF393634),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Camera Button to capture an image
            IconButton(
              icon: const Icon(Icons.camera_alt),
              iconSize: 35.0,
              onPressed: _captureImage, // Capture an image
            ),
            Container(
              height: 60, // Height of the separator
              width: 2, // Width of the separator
              color: Colors.black, // Color of the separator
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