import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'journal_entry_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

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
  String? _selectedMood; // Store the selected mood

  @override
  void initState() {
    super.initState();

    if (widget.entry != null) {
      _titleController.text = widget.entry!.title;
      _contentController.text = widget.entry!.content;

      // Only set _imageFile if the image URL is not an asset
      if (widget.entry!.imageUrl != null &&
          !widget.entry!.imageUrl!.startsWith('assets/')) {
        _imageFile = File(widget.entry!.imageUrl!);
      }

      _selectedDate = widget.entry!.date;
      _selectedMood = widget.entry!.mood;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  String _formatSelectedDate(DateTime? date) {
    if (date == null) return 'Select Date';

    final timeAgo = timeago.format(date);
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
    return '$timeAgo | $formattedDate';
  }

  // Method to capture image
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


  void _showMoodPicker() async {
    final String? mood = await showDialog<String>(
      context: context,
      builder: (context) {
        return MoodPickerDialog(currentMood: _selectedMood);
      },
    );
    if (mood != null) {
      setState(() {
        _selectedMood = mood;
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(fontFamily: 'Lora'),
                              hintStyle: TextStyle(fontFamily: 'Lora'),
                              hintText: 'Title',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFbe3b88),
                              fontFamily: 'RobotoMono',
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(
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
                                  if (_selectedMood != null)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, bottom: 25.0),
                                      child: Text(
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