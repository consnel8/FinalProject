import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import 'outfit_model.dart';

class EditOutfitPage extends StatefulWidget {
  final Outfit outfit;
  final Function(Map<String, dynamic>) onSave;

  const EditOutfitPage({super.key, required this.outfit, required this.onSave});

  @override
  _EditOutfitPageState createState() => _EditOutfitPageState();
}

class _EditOutfitPageState extends State<EditOutfitPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String? _selectedImage;
  late String selectedItemType;
  late String selectedCategory;
  late String imageUrl;

  @override
  void initState() {
    super.initState();

    // Initialize controllers and fields from the passed outfit
    _titleController = TextEditingController(text: widget.outfit.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.outfit.description ?? '',
    );
    selectedItemType = widget.outfit.typeOfItem ?? '';
    selectedCategory = widget.outfit.category ?? '';
    imageUrl = widget.outfit.imageUrl ?? '';
  }

  /// Method to upload an image to Firebase Storage
  Future<String> _uploadImage(String imagePath) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toIso8601String()}');
      final uploadTask = storageRef.putFile(File(imagePath));
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit ${widget.outfit.title ?? 'Outfit'}',
          style: const TextStyle(fontFamily: 'Teko', fontSize: 30),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Center(
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _selectedImage != null
                        ? Image.file(
                      File(_selectedImage!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                        : imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                        : const Icon(Icons.image, size: 100, color: Colors.grey),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description Section
            const Text(
              'Description',
              style: TextStyle(fontSize: 22, fontFamily: 'Teko'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description',
                helperText: '180 characters max',
              ),
              maxLength: 180,
            ),
            const SizedBox(height: 20),

            // Type of Item Dropdown
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Type of Item',
                  style: TextStyle(fontFamily: 'Teko', fontSize: 18)),
              subtitle: const Text('Clothing, Shoe, Jewellery, etc.',
                  style: TextStyle(fontFamily: 'Lora')),
              trailing: DropdownButtonFormField<String>(
                value: ['Clothing', 'Shoe', 'Jewellery'].contains(selectedItemType)
                    ? selectedItemType
                    : null,
                onChanged: (value) {
                  setState(() {
                    selectedItemType = value ?? '';
                  });
                },
                items: ['Clothing', 'Shoe', 'Jewellery']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Type of Item'),
              ),
            ),

            // Category Dropdown
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Category',
                  style: TextStyle(fontFamily: 'Teko', fontSize: 18)),
              subtitle: const Text('Winters, Casual, Formal, etc.',
                  style: TextStyle(fontFamily: 'Lora')),
              trailing: DropdownButtonFormField<String>(
                value: ['Winters', 'Casual', 'Formal'].contains(selectedCategory)
                    ? selectedCategory
                    : null,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value ?? '';
                  });
                },
                items: ['Winters', 'Casual', 'Formal']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ),
            const Spacer(),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel, color: Colors.grey),
                  label: const Text('Cancel', style: TextStyle(fontFamily: 'Lora')),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_descriptionController.text.isNotEmpty &&
                        selectedItemType.isNotEmpty &&
                        selectedCategory.isNotEmpty) {
                      try {
                        // Upload image if a new one is selected
                        if (_selectedImage != null) {
                          imageUrl = await _uploadImage(_selectedImage!);
                        }

                        // Updated outfit data
                        final updatedOutfit = {
                          'title': _titleController.text,
                          'description': _descriptionController.text,
                          'category': selectedCategory,
                          'typeOfItem': selectedItemType,
                          'imageUrl': imageUrl,
                        };

                        // Save changes
                        await FirebaseFirestore.instance
                            .collection('outfits')
                            .doc(widget.outfit.id)
                            .update(updatedOutfit);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Changes saved successfully!',
                                style: TextStyle(fontFamily: 'Lora')),
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to save changes: $e',
                              style: const TextStyle(fontFamily: 'Lora'),
                            ),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please fill all the fields',
                              style: TextStyle(fontFamily: 'Lora')),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(fontFamily: 'Lora'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


