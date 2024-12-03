// Importing necessary libraries for various functionalities
import 'dart:io'; // For handling file operations like picking images
import 'package:flutter/material.dart'; // Core Flutter package for UI components
import 'package:image_picker/image_picker.dart'; // To pick images from camera or gallery
import 'journal_entry_model.dart'; // Importing the model for journal entries (custom class)
import 'package:timeago/timeago.dart' as timeago; // To format time as "time ago" (e.g., 5 minutes ago)
import 'package:intl/intl.dart'; // For formatting dates in various formats


// Stateful widget that enables dynamic updates for the journal entry page (creating/editing)
class EditJournalPage extends StatefulWidget {
  final JournalEntry? entry; // Optional journal entry to edit. If null, it means we're creating a new entry.

  const EditJournalPage({Key? key, this.entry}) : super(key: key); // Constructor to initialize the widget with optional entry

  @override
  _EditJournalPageState createState() => _EditJournalPageState(); // Creates state for the widget (for managing dynamic content)
}

class _EditJournalPageState extends State<EditJournalPage> {
  // Controllers to manage the input fields for title and content
  final _titleController = TextEditingController(); // To store the image file that is picked by the user
  final _contentController = TextEditingController(); // To hold the selected date for the journal entry
  File? _imageFile; // To hold the picked image file
  DateTime? _selectedDate; // To store the selected date
  String? _selectedMood; // Store the selected mood

  @override
  void initState() {
    super.initState();

    // If an existing journal entry is passed for editing, prepopulate the fields for sake of demo
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title; // Set the title from the passed entry
      _contentController.text = widget.entry!.content;// Set the content from the passed entry

      // Only set _imageFile if the image URL is not an asset
      if (widget.entry!.imageUrl != null &&
          !widget.entry!.imageUrl!.startsWith('assets/')) {
        _imageFile = File(widget.entry!.imageUrl!); // Load image if it's from file system
      }

      _selectedDate = widget.entry!.date; // Set the date for the journal entry from the passed entry
      _selectedMood = widget.entry!.mood;// Set the mood from the passed entry
    } else {
      _selectedDate = DateTime.now(); // Set the default date to current date
    }
  }

  // Method to format the selected date
  String _formatSelectedDate(DateTime? date) {
    // If no date is selected, return a default prompt
    if (date == null) return 'Select Date';

    // Format the date as "time ago" (e.g., "5 minutes ago") using the timeago package
    final timeAgo = timeago.format(date);

    // Format the date as "MMM dd, yyyy" (e.g., "Dec 02, 2024") using intl package
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);

    // Return the formatted date as a string with both "time ago" and the date
    return '$timeAgo | $formattedDate';
  }

  // Method to capture an image from the camera
  Future<void> _captureImage() async {
    final picker = ImagePicker(); // Create an ImagePicker instance to access camera or gallery
    final pickedFile = await picker.pickImage(source: ImageSource.camera); // Pick an image using the camera

    // If the user picks an image, store it in the _imageFile variable
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the captured image file in the state
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
            primaryColor: Color(0xFF55acee), // Header color
            colorScheme: ColorScheme.light(primary: Color(0xFF55acee)),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFBE3B88),
              ),),
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


// Method to display a mood picker dialog and update the selected mood
  void _showMoodPicker() async {
    // Show the MoodPickerDialog and wait for the user to select a mood
    final String? mood = await showDialog<String>(
      context: context,
      builder: (context) {
        // Return the MoodPickerDialog widget, passing the current selected mood
        return MoodPickerDialog(currentMood: _selectedMood);
      },
    );

    // If a mood is selected, update the _selectedMood state variable
    if (mood != null) {
      setState(() {
        _selectedMood = mood; // Store the new mood in the state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              elevation: 1,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context); // Handle back navigation
                },
              ),
              title: const Text('Journal Entry',
                  style: TextStyle(fontFamily: 'RobotoMono', fontSize: 25)),
              actions: widget.entry != null
                  ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  iconSize: 30,
                  color: Colors.red,
                  onPressed: () {
                    // Confirm before deleting
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Entry',
                            style: TextStyle(fontFamily: 'Teko', color:Colors.black,)),
                        content: const Text(
                          'Are you sure you want to delete this entry?',),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            // Cancel
                            child: const Text('Cancel',),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              Navigator.pop(context,
                                  'delete'); // Signal deletion to parent
                            },
                            child: const Text('Delete',),
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
                  fit: BoxFit.cover, // Ensure the image covers the entire screen
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    // Expanded widget to make the content take the available space
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),// Add padding to the scroll view
                      child: Column(
                        children: [
                          // Title TextField to input the journal title
                          TextField(
                            controller: _titleController, // Controller to manage text input
                            decoration: InputDecoration(
                              labelStyle: TextStyle(fontFamily: 'Lora'),
                              hintStyle: TextStyle(fontFamily: 'Lora'),
                              hintText: 'Title', // Placeholder text
                              border: InputBorder.none, // Remove the border
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(
                              // Set font size, weight, color, style and family
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFbe3b88),
                              fontFamily: 'RobotoMono',
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(height: 16), // Add space between widgets
                          // GestureDetector to open date picker when tapped
                          GestureDetector(
                            onTap: () => _selectDate(context), // Trigger date selection
                            child: AbsorbPointer(
                              child: Row(
                                children: [
                                  // TextField for displaying the selected date
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
                                        // Format date as "time ago | formatted date"
                                        text: _formatSelectedDate(_selectedDate),
                                      ),
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(fontFamily: 'Lora', fontSize: 30,),
                                        labelText: 'Select Date',
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: Color(0xFF444444),
                                        fontFamily: 'Lora',
                                      ),
                                    ),
                                  ),
                                  // Display mood if selected
                                  if (_selectedMood != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, bottom: 25.0),
                                      child: Text(
                                        // Display selected mood and its formatting
                                        'Mood: $_selectedMood',
                                        style: TextStyle(
                                          fontFamily: 'IndieFlower',
                                          fontSize: 20,
                                          color: Color(0xFFbe3b88),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _contentController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Your journal entry...',
                              hintStyle: TextStyle(
                                height: 3,
                                fontFamily: 'Lora',
                              ),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.only(left: 15.0, top: 1.0),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'FuzzyBubbles',
                              color: Colors.black,
                              height: 1.70, // line spacing
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Display the picked or captured image if any
                          if (_imageFile != null)
                            Image.file(
                              _imageFile!,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          if (widget.entry?.imageUrl != null && _imageFile == null)
                            widget.entry!.imageUrl!.startsWith('assets/')
                                ? Image.asset(
                              widget.entry!.imageUrl!,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              File(widget.entry!.imageUrl!),
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            bottomNavigationBar: BottomAppBar(
              color: const Color(0xFF393634),
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Image.asset('assets/mood.png'),
                      iconSize: 50,
                      onPressed: _showMoodPicker,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 2,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Image.asset('assets/camera.png'),
                      iconSize: 50,
                      onPressed: _captureImage,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 2,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Image.asset('assets/save.png'),
                      iconSize: 50,
                      onPressed: () {
                        final updatedEntry = JournalEntry(
                          title: _titleController.text,
                          content: _contentController.text,
                          imageUrl: _imageFile?.path ?? widget.entry?.imageUrl,
                          date: _selectedDate ?? DateTime.now(),
                          mood: _selectedMood,
                        );

                        // Snackbar when saving edited/new entry
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '✨ Entry saved! Time to reflect',
                              style: TextStyle(fontFamily: 'Lora', ),
                            ),
                            duration: Duration(seconds: 5),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xffc5c5c5),
                            margin: EdgeInsets.all(16.0),
                          ),
                        );

                        Navigator.pop(context, updatedEntry);
                      },
                    ),
                  ),
                ],
              ),
            )

        )
    );
  }
}

// Mood Picker Dialog
class MoodPickerDialog extends StatelessWidget {
  final String? currentMood;

  const MoodPickerDialog({Key? key, this.currentMood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log Mood', style: TextStyle(fontFamily: 'Teko', color:Colors.black, fontSize: 30),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Happy 😊', 'Motivated 🎯', 'Sad 🌧️',
          'Stressed 😓', 'Relaxed 🧘', 'Grateful 🙏',
          'Excited 🎉'].map((mood) {
          return RadioListTile<String>(
            title: Text(
              mood,
              style: TextStyle(color: Color(0xFFbe3b88), fontFamily: 'Lora'),
            ),
            value: mood,
            groupValue: currentMood,
            onChanged: (String? value) {
              Navigator.pop(context, value); // Return the selected mood
            },
          );
        }).toList(),
      ),
    );
  }
}