import  'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'outfit_model.dart';
import 'outfit_service.dart';

class EditOutfitPage extends StatefulWidget {
  final Outfit outfit;
  final Function(Outfit) onSave;

  const EditOutfitPage({required this.outfit, required this.onSave});

  @override
  _EditOutfitPageState createState() => _EditOutfitPageState();
}

class _EditOutfitPageState extends State<EditOutfitPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String selectedCategory;
  late String selectedItemType;
  String? imageUrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.outfit.title);
    descriptionController = TextEditingController(text: widget.outfit.description);
    selectedCategory = widget.outfit.category;
    selectedItemType = widget.outfit.typeOfItem;
    imageUrl = widget.outfit.imageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() => isSaving = true);

      try {
        final File imageFile = File(pickedImage.path);
        final String? uploadedUrl = await OutfitService().uploadImage(imageFile);
        setState(() {
          imageUrl = uploadedUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      } finally {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedCategory.isEmpty ||
        selectedItemType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final updatedOutfit = widget.outfit.copyWith(
        title: titleController.text,
        description: descriptionController.text,
        category: selectedCategory,
        typeOfItem: selectedItemType,
        imageUrl: imageUrl ?? widget.outfit.imageUrl,
      );

      await OutfitService().updateOutfit(updatedOutfit);
      widget.onSave(updatedOutfit);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Outfit updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update outfit: $e')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.outfit.title}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickAndUploadImage,
              child: Container(
                height: imageHeight,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: imageUrl != null
                    ? Image.network(imageUrl!, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 100, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            // Title Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Description Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Category Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    onChanged: (value) => setState(() => selectedCategory = value!),
                    items: ['Formal', 'Casual', 'Winter/Fall', 'Summer/Spring']
                        .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                        .toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Item Type Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Type of Item',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: selectedItemType,
                    onChanged: (value) => setState(() => selectedItemType = value!),
                    items: ['Clothing', 'Shoe', 'Jewellery']
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                        .toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Save Changes Button
            ElevatedButton(
              onPressed: isSaving ? null : _saveChanges,
              child: isSaving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



