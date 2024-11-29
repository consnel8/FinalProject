import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../models/outfit_model.dart';

class EditOutfitPage extends StatefulWidget {
  final Map<String, dynamic> outfit;
  final Function(Map<String, dynamic>) onSave;

  const EditOutfitPage({super.key, required this.outfit, required this.onSave});

  @override
  _EditOutfitPageState createState() => _EditOutfitPageState();
}

class _EditOutfitPageState extends State<EditOutfitPage> {
  late TextEditingController _descriptionController;
  late String selectedItemType;
  late String selectedCategory;
  late String imageUrl;

  @override
  void initState() {
    super.initState();


    // Initialize controllers and fields from the passed outfit
    _descriptionController = TextEditingController(
      text: widget.outfit['description'] ?? '',
    );
    selectedItemType = widget.outfit['typeOfItem'] ?? '';
    selectedCategory = widget.outfit['category'] ?? '';
    imageUrl = widget.outfit['imageUrl'] ?? '';

  }

  Future<void> _fetchOutfitDetails(String outfitId) async {
    final doc = await FirebaseFirestore.instance.collection('outfits').doc(
        outfitId).get();
    final outfit = Outfit.fromDocumentSnapshot(doc);

    setState(() {
      _descriptionController = TextEditingController(text: outfit.description);
      selectedItemType =
          outfit.typeOfItem; // Assuming typeOfItem exists in the model
      selectedCategory =
          outfit.category; // Assuming category exists in the model
      imageUrl = outfit.imageUrl;
    });
  }


  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit  Outfit',
          style: TextStyle(fontFamily: 'Teko', fontSize: 30),
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
          //mage Section
        children: [
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
                  // const Icon(Icons.image, size: 100, color: Colors.grey),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          imageUrl.isEmpty
                              ? Container(
                            color: Colors.pink.shade100,
                            height: 200,
                            width: double.infinity,
                            child: Icon(
                                Icons.image, size: 50, color: Colors.grey),
                          )
                              : Image.network(
                            imageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
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
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Name (Description)',
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
              value: selectedItemType.isNotEmpty ? selectedItemType : null,
              onChanged: (value) {
                setState(() {
                  selectedItemType = value!;
                });
              },
              items: ['Clothing', 'Shoe', 'Jewellery']
                  .map((type) =>
                  DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Type of Item',
              ),
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
              value: selectedCategory.isNotEmpty ? selectedCategory : null,
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
              items: ['Winters', 'Casual', 'Formal']
                  .map((cat) =>
                  DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Category',
              ),
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
                label: const Text('Cancel',
                    style: TextStyle(fontFamily: 'Lora')),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validate input fields
                  if (_descriptionController.text.isNotEmpty &&
                      selectedItemType != null &&
                      selectedCategory != null) {
                    try {
                      // Upload image if a new image is selected
                      String? imageUrl = outfit.imageUrl; // Keep the existing image URL
                       if (_selectedImage != null) {
                         imageUrl = await _uploadImage(_selectedImage!);
                       }
                      // Prepare updated outfit data
                      final updatedOutfit = {
                       // 'description': _descriptionController.text,
                       // 'typeOfItem': selectedItemType,
                        //'category': selectedCategory,
                       // 'imageUrl': imageUrl,
                        // Ensure this is updated if user changes image
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'category': selectedCategory,
                        'typeOfItem': selectedItemType,
                        'imageUrl': imageUrl ?? ''
                      };

                      // Save the changes to Firestore
                      await FirebaseFirestore.instance
                          .collection('outfits')
                          .doc(widget
                          .outfit['id']) // Use the outfit ID passed to the editor
                          .update(updatedOutfit);

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Changes saved successfully!',
                          style: TextStyle(fontFamily: 'Lora'),
                        ),
                      ));

                      // Return to the previous page
                      Navigator.pop(context);
                    } catch (e) {
                      // Handle any errors during the save process
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Failed to save changes: $e',
                          style: const TextStyle(fontFamily: 'Lora'),
                        ),
                      ));
                    }
                  } else {
                    // If fields are empty, show error
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please fill all the fields',
                          style: TextStyle(fontFamily: 'Lora')),
                    ));
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


