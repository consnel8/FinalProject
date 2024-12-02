import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'outfit_model.dart';
import 'glimmering_star_icon.dart';
import 'outfit_service.dart';
import 'package:finalproject/main.dart';

class OutfitBuilderPage extends StatefulWidget {
  final Function(Outfit) onSave;

  OutfitBuilderPage({required this.onSave});

  @override
  _OutfitBuilderPageState createState() => _OutfitBuilderPageState();
}

class _OutfitBuilderPageState extends State<OutfitBuilderPage> {
  String? selectedItemType;
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Map<String, String?> outfitParts = {
    'Top': null,
    'Bottom': null,
    'Accessories': null,
  };

  // bool showOutfitOptions = false;
  final ImagePicker _picker = ImagePicker();
  final OutfitService _outfitService = OutfitService();
  //final Map<String, String> outfitParts = {};
  bool isSaving = false;


  /* Select image from gallery or camera
  Future<void> selectImage(String part) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // Or ImageSource.camera for capturing
    );
    if (image != null) {
      setState(() {
        outfitParts[part] = image.path; // Store the image path
      });
    }
  }*/
  // Select image from gallery or camera and optionally upload
  Future<void> selectImage(String part, {bool uploadToStorage = true}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for capturing
    );

    if (image != null) {
      if (uploadToStorage) {
        // Upload the image to Firebase Storage
        setState(() => isSaving = true);
        final imageUrl = await _outfitService.uploadImage(File(image.path));
        if (imageUrl != null) {
          setState(() {
            outfitParts[part] = imageUrl; // Store the uploaded image URL
            isSaving = false;
          });
        } else {
          setState(() => isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image')),
          );
        }
      } else {
        // Simply store the local image path
        setState(() {
          outfitParts[part] = image.path;
        });
      }
    }
  }

  Future<void> selectAndUploadImage(String part, ImageSource source) async {
    try {
      File? selectedFile;

      if (source == ImageSource.gallery || source == ImageSource.camera) {
        final XFile? pickedImage = await _picker.pickImage(source: source);
        if (pickedImage != null) {
          selectedFile = File(pickedImage.path);
        }
      } else {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );
        if (result != null && result.files.single.path != null) {
          selectedFile = File(result.files.single.path!);
        }
      }

      if (selectedFile != null) {
        setState(() => isSaving = true);

        // Upload image to Firebase Storage and get the URL
        final String? imageUrl = await _outfitService.uploadImage(selectedFile);

        if (imageUrl != null) {
          setState(() {
            outfitParts[part] = imageUrl; // Update the corresponding part's URL
            isSaving = false;
          });
        } else {
          setState(() => isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting/uploading image: $e')),
      );
    }
  }


  /* Future<void> selectAndUploadImage(String part, ImageSource source) async {
    try {
      File? selectedFile;

      if (source == ImageSource.gallery || source == ImageSource.camera) {
        final XFile? pickedImage = await _picker.pickImage(source: source);
        if (pickedImage != null) {
          selectedFile = File(pickedImage.path);
        }
      } else {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );
        if (result != null && result.files.single.path != null) {
          selectedFile = File(result.files.single.path!);
        }
      }

      if (selectedFile != null) {
        setState(() => isSaving = true);

        final imageUrl = await _outfitService.uploadImage(selectedFile);

        if (imageUrl != null) {
          setState(() {
            outfitParts[part] = imageUrl;
            isSaving = false;
          });
        } else {
          setState(() => isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image')),
          );
        }
      }
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting/uploading image: $e')),
      );
    }
  }*/

  // Generate preview of the outfit collage
  Widget buildCollagePreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: outfitParts.keys.map((part) {
        return outfitParts[part] != null
            ? Image.asset(
                outfitParts[part]!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
            : Icon(Icons.image, size: 50, color: Colors.grey);
      }).toList(),
    );
  }



  Future<void> saveOutfit({
    required String title,
    required String description,
    required String category,
    required String typeOfItem,
    required String imageUrl,
  }) async {
    final outfitService = OutfitService(); // Initialize the service

    try {
      final newOutfit = Outfit(
        id: '', // Auto-generated ID from Firestore
        title: title,
        description: description,
        category: category,
        typeOfItem: typeOfItem,
        imageUrl: imageUrl,
        isFavorite: false, // Default value
        dateLiked: DateTime.now(), // Setting the current date
      );

      // Use the service to save the outfit
      await outfitService.saveOutfit(newOutfit);

      print('Outfit saved successfully!');
    } catch (e) {
      print('Error saving outfit: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outfit Builder',
            style: TextStyle(fontFamily: 'Teko', fontSize: 30)),
        actions: [
          IconButton(
            icon: isSaving
                ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Icon(Icons.save),
            onPressed: isSaving
                ? null
                : () async {
              try {
                String title = titleController.text.trim();
                String description = descriptionController.text.trim();
                String category = selectedCategory ?? '';
                String typeOfItem = selectedItemType ?? '';
                String imageUrl = outfitParts['Complete Outfit'] ?? '';

                // Validate required fields
                if (title.isEmpty || description.isEmpty || imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields.')),
                  );
                  return;
                }

                await saveOutfit(
                  title: title,
                  description: description,
                  category: category,
                  typeOfItem: typeOfItem,
                  imageUrl: imageUrl,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Outfit saved successfully!')),
                );

                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving outfit: $e')),
                );
              }
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show the two main options
            if (outfitParts.values.any((path) => path != null))
              Container(
                height: 200,
                child: buildCollagePreview(),
              ),
            Text(
              'Select Outfit Type',
              style: TextStyle(fontSize: 22, fontFamily: 'Teko'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Show the image picker for complete outfit upload
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text('Upload from Photo Gallery',
                                  style: TextStyle(fontFamily: 'Lora')),
                              onTap: () {
                                Navigator.pop(context);
                                selectAndUploadImage('Complete Outfit', ImageSource.gallery);
                              }
                            ),
                            ListTile(
                              title: Text('Capture Image',
                                  style: TextStyle(fontFamily: 'Lora')),
                              onTap: () {
                                Navigator.pop(context); // Close the modal
                                selectAndUploadImage('Complete Outfit', ImageSource.camera);
                              },
                             // onTap: () => selectImage('Complete Outfit'),
                            ),
                            ListTile(
                              title: Text('Upload file',
                                  style: TextStyle(fontFamily: 'Lora')),
                              onTap: () {
                                Navigator.pop(context); // Close the modal
                                selectAndUploadImage('Complete Outfit', ImageSource.gallery);
                              },
                              //onTap: () => selectImage('Complete Outfit'),
                            )
                          ],
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        // Make the card stretch within Expanded
                        height: 150,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, size: 40),
                            SizedBox(height: 8),
                            Text('Upload Complete Outfit',
                                style: TextStyle(fontFamily: 'Lora')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        //
                      });
                    },
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        // Make the card stretch within Expanded
                        height: 150,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GlitteringIcon(
                              icon: Icons.star,
                              // Use your desired icon here// Use your desired icon here
                              size: 50,
                              // Main icon size
                              cardHeight: 300,
                              // Pass the card height as a non-null value
                              cardWidth:
                                  300, // Pass the card height as a non-null value
                            ),
                            // Icon(Icons.star, size: 50, color: Colors.yellow,),

                            SizedBox(height: 8),
                            Text('Build an Outfit',
                                style: TextStyle(fontFamily: 'Lora')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: outfitParts.keys.map((part) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () => selectImage(part),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            outfitParts[part] != null
                                ? Image.asset(
                                    outfitParts[part]!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                : Icon(Icons.image,
                                    size: 100, color: Colors.grey),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => selectImage(part),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Text(part,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Description field
            Text(
              'Title',
              style: TextStyle(fontSize: 22, fontFamily: 'Teko'),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontFamily: 'Lora'),
                hintText: 'Add Title',
              ),
            ),
            Text(
              'Description',
              style: TextStyle(fontSize: 22, fontFamily: 'Teko'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontFamily: 'Lora'),
                hintText: 'Add Description',
                helperStyle: TextStyle(fontFamily: 'Lora'),
                helperText: '180 characters max',
              ),
              maxLength: 180,
            ),
            SizedBox(height: 20),
            // Item type dropdown
            ListTile(
              leading: Icon(Icons.shopping_cart_outlined),
              title: Text('Type of Item',
                  style: TextStyle(fontFamily: 'Teko', fontSize: 20)),
              subtitle: Text('Clothing, Shoe, Jewellery, etc.',
                  style: TextStyle(fontFamily: 'Lora')),
              trailing: DropdownButton<String>(
                value: selectedItemType,
                items: <String>['Clothing', 'Shoe', 'Jewellery', 'Dresses']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: TextStyle(fontFamily: 'Lora')),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItemType = newValue;
                  });
                },
                hint: Text('Select', style: TextStyle(fontFamily: 'Lora')),
              ),
            ),
            // Category dropdown
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text('Category',
                  style: TextStyle(fontFamily: 'Teko', fontSize: 20)),
              subtitle: Text('Winter, Casual, Formal, etc.',
                  style: TextStyle(fontFamily: 'Lora')),
              trailing: DropdownButton<String>(
                value: selectedCategory,
                items: <String>[
                  'Winter/Fall',
                  'Summer/Spring',
                  'Casual',
                  'Formal',
                  'Accessories'
                ]
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child:
                              Text(value, style: TextStyle(fontFamily: 'Lora')),
                        ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                hint: Text('Select', style: TextStyle(fontFamily: 'Lora')),
              ),
            ),



          ],
        ),
      ),
    );

  }


}
