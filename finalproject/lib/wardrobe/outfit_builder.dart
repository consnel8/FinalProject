import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'glimmering_star_icon.dart';

class OutfitBuilderPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  OutfitBuilderPage({required this.onSave});

  @override
  _OutfitBuilderPageState createState() => _OutfitBuilderPageState();
}

class _OutfitBuilderPageState extends State<OutfitBuilderPage> {
  String? selectedItemType;
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  Map<String, String?> outfitParts = {
    'Top': null,
    'Bottom': null,
    'Accessories': null,
  };
  bool showOutfitOptions = false;
  final ImagePicker _picker = ImagePicker();

  // Select image from gallery or camera
  Future<void> selectImage(String part) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // Or ImageSource.camera for capturing
    );
    if (image != null) {
      setState(() {
        outfitParts[part] = image.path; // Store the image path
      });
    }
  }

  // Generate preview of the outfit collage
  Widget buildCollagePreview() {
    return Column(
      children: [
        if (outfitParts['Top'] != null) Image.asset(outfitParts['Top']!),
        if (outfitParts['Bottom'] != null) Image.asset(outfitParts['Bottom']!),
        if (outfitParts['Accessories'] != null)
          Image.asset(outfitParts['Accessories']!),
      ],
    );
  }

  // Save outfit to the dashboard
  void saveOutfit() {
    if (descriptionController.text.isNotEmpty &&
        selectedItemType != null &&
        selectedCategory != null &&
        outfitParts.values.any((image) => image != null)) {
      final newOutfit = {
        'title': descriptionController.text,
        'category': selectedCategory,
        'type': selectedItemType,
        'parts': outfitParts,
        'isFavorite': false, // Default favorite state
      };

      widget.onSave(newOutfit); // Passing the new outfit back to the dashboard
      Navigator.pop(context); // Navigate back to the dashboard page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please fill all fields and select images for at least one part')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outfit Builder'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveOutfit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show the two main options
            Text(
              'Select Outfit Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          children: [
                            ListTile(
                              title: Text('Upload from Photo Gallery'),
                              onTap: () => selectImage('Complete Outfit'),
                            ),
                            ListTile(
                              title: Text('Capture Image'),
                              onTap: () => selectImage('Complete Outfit'),
                            ),
                            ListTile(
                              title: Text('Upload file'),
                              onTap: () => selectImage('Complete Outfit'),
                            )
                          ],
                        ),
                      );
                    },
                    child: Card(
                      child: Container(
                        width: double.infinity, // Make the card stretch within Expanded
                        height: 150,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file, size: 40),
                            SizedBox(height: 8),
                            Text('Upload Complete Outfit'),
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
                        showOutfitOptions = true;
                      });
                    },
                    child: Card(
                      child: Container(
                        width: double.infinity, // Make the card stretch within Expanded
                        height: 150,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GlitteringIcon(
                              icon: Icons.star,  // Use your desired icon here// Use your desired icon here
                              size: 50,           // Main icon size
                              cardHeight: 300,    // Pass the card height as a non-null value
                              cardWidth: 300,    // Pass the card height as a non-null value
                            ),
                           // Icon(Icons.star, size: 50, color: Colors.yellow,),

                            SizedBox(height: 8),
                            Text('Build an Outfit'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (showOutfitOptions)
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
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
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Name (Description)',
                helperText: '180 characters max',
              ),
              maxLength: 180,
            ),
            SizedBox(height: 20),
            // Item type dropdown
            ListTile(
              leading: Icon(Icons.shopping_cart_outlined),
              title: Text('Type of Item'),
              subtitle: Text('Clothing, Shoe, Jewellery, etc.'),
              trailing: DropdownButton<String>(
                value: selectedItemType,
                items: <String>['Clothing', 'Shoe', 'Jewellery']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItemType = newValue;
                  });
                },
                hint: Text('Select'),
              ),
            ),
            // Category dropdown
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text('Category'),
              subtitle: Text('Winter, Casual, Formal, etc.'),
              trailing: DropdownButton<String>(
                value: selectedCategory,
                items: <String>['Winter', 'Casual', 'Formal']
                    .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                },
                hint: Text('Select'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
