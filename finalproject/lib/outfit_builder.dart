import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'outfit_model.dart';
import 'outfit_service.dart';

class OutfitBuilderPage extends StatefulWidget {
  final Function(Outfit) onSave;


  OutfitBuilderPage({required this.onSave});

  @override
  _OutfitBuilderPageState createState() => _OutfitBuilderPageState();
}

class _OutfitBuilderPageState extends State<OutfitBuilderPage> {
  final ImagePicker _picker = ImagePicker();
  bool showOutfitOptions = false;
  String? selectedItemType;
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Map<String, String?> outfitParts = {
    'Top': null,
    'Bottom': null,
    'Accessories': null,
  };
  TextEditingController urlController = TextEditingController();
  String  pastedImageUrl = '';

  final OutfitService _outfitService = OutfitService();
  //final Map<String, String> outfitParts = {};
  bool isSaving = false;




  Future<bool> isValidImageUrl(String url) async {
    try {
      final response = await HttpClient().headUrl(Uri.parse(url)).then((request) => request.close());
      return response.statusCode == 200 &&
          (response.headers.contentType?.mimeType.startsWith('image/') ?? false);
    } catch (e) {
      // If there's an error (e.g., invalid URL), return false
      return false;
    }
  }


  Future<bool> requestPermissions() async {
    PermissionStatus storageStatus = await Permission.storage.request();
    PermissionStatus cameraStatus = await Permission.camera.request();

    return storageStatus.isGranted && cameraStatus.isGranted;
  }



  // Select image from gallery or camera and optionally upload
  Future<void> selectImage(String part, {bool uploadToStorage = true}) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for capturing
    );

    if (image != null) {
      if (uploadToStorage) {
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
        setState(() {
          outfitParts[part] = image.path; // Store local path
        });
      }
    } else {
      print("No image selected.");
    }
  }



  Future<void> selectAndUploadImage(String part, ImageSource source) async {
    try {
      File? selectedFile;

      if (source == ImageSource.gallery || source == ImageSource.camera) {
        final XFile? pickedImage = await _picker.pickImage(source: source);
        if (pickedImage != null) selectedFile = File(pickedImage.path);
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
        final String? imageUrl = await _outfitService.uploadImage(selectedFile);
        if (imageUrl != null) {
          setState(() {
            outfitParts[part] = imageUrl; // Update URL
          });
        } else {
          throw Exception('Failed to upload image');
        }
      }
    } catch (e) {
      print("Error selecting/uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting/uploading image: $e')),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }





  // Generate preview of the outfit collage

  Widget buildCollagePreview() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (outfitParts['Top'] != null)
                Image.network(outfitParts['Top']!, height: 100, width: 100),
              if (outfitParts['Bottom'] != null)
                Image.network(outfitParts['Bottom']!, height: 100, width: 100),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (outfitParts['Accessories'] != null)
                Image.network(outfitParts['Accessories']!, height: 100, width: 100),
            ],
          ),
        ],
      ),
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
        dateLiked: DateTime.now(),
        dateAdded: DateTime.now(),
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
               TextButton(
              onPressed: isSaving
                  ? null
                  : () async {
                try {
                  String title = titleController.text.trim();
                  String description = descriptionController.text.trim();
                  String category = selectedCategory ?? '';
                  String typeOfItem = selectedItemType ?? '';
                 // String imageUrl = outfitParts['Complete Outfit'] ?? '';

                  String imageUrl = pastedImageUrl.isNotEmpty
                      ? pastedImageUrl
                      : outfitParts['Complete Outfit'] ?? '';

                  if (pastedImageUrl.isNotEmpty && !(await isValidImageUrl(pastedImageUrl))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid image URL.')),
                    );
                    return;
                  }

                  if (urlController.text.isNotEmpty) {
                    final isValid = await isValidImageUrl(urlController.text);
                    if (!isValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid Image URL')),
                      );
                      return;
                    }
                  }


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
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collage Preview Section
              if (outfitParts.values.any((path) => path != null))
                Container(
                  height: 150,
                  margin: EdgeInsets.only(bottom: 20),
                  child: buildCollagePreview(), // Builds a collage preview
                ),
          
              // Section Title
              Text(
                'Select Outfit Type',
                style: TextStyle(fontSize: 22, fontFamily: 'Teko'),
              ),
              SizedBox(height: 10),
          
              // 3  Options: Upload Complete Outfit & Build Outfit & add imge url
              Row(
                children: [
                  // Upload Complete Outfit Option
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
                                },
                              ),
                              ListTile(
                                title: Text('Capture Image', style: TextStyle(fontFamily: 'Lora')),
                                onTap: () {
                                  Navigator.pop(context); // Close the modal
                                  selectAndUploadImage('Complete Outfit', ImageSource.camera);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          height: 120,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file, size: 40),
                              SizedBox(height: 8),
                              Text('Upload Outfit', style: TextStyle(fontFamily: 'Lora')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Build Outfit Option
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showOutfitOptions = !showOutfitOptions;
                        });
                      },
                      child: Card(
                        elevation: 4,
                        child: Container(
                          height: 120,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.design_services, size: 40),
                              SizedBox(height: 8),
                              Text('Build Outfit', style: TextStyle(fontFamily: 'Lora')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
          
              // Conditionally Show Build Outfit Options
              if (showOutfitOptions)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: outfitParts.keys.map((part) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => selectImage(part),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              outfitParts[part] != null
                                  ? Image.network(
                                outfitParts[part]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                                  : Icon(Icons.image, size: 50, color: Colors.grey),
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
                                child: Text(part, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
          
              // Paste Image URL Section
              Text(
                'Paste Image URL',
                style: TextStyle(fontSize: 22, fontFamily: 'Teko'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    pastedImageUrl = value;
                  });
                },
              ),
              SizedBox(height: 10),
              if (pastedImageUrl.isNotEmpty)
                Image.network(
                  pastedImageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Invalid URL', style: TextStyle(color: Colors.red));
                  },
                ),
              SizedBox(height: 20),
          
              // Title & Description Section
              Text('Title', style: TextStyle(fontSize: 22, fontFamily: 'Teko')),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Add Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Text('Description', style: TextStyle(fontSize: 22, fontFamily: 'Teko')),
              TextField(
                controller: descriptionController,
                maxLength: 180,
                decoration: InputDecoration(
                  hintText: 'Add Description',
                  border: OutlineInputBorder(),
                  helperText: '180 characters max',
                ),
              ),
              SizedBox(height: 20),
          
              // Dropdowns for Item Type and Category
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 400) {
                    // Use a Column if the screen width is too small
                    return Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: selectedItemType,
                          decoration: InputDecoration(labelText: 'Type of Item'),
                          items: ['Clothing', 'Shoe', 'Jewellery', 'Accessories']
                              .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontFamily: 'Lora', color: Colors.blueAccent)),
                          ))
                              .toList(),
                          onChanged: (value) => setState(() => selectedItemType = value),
                        ),
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: InputDecoration(labelText: 'Category'),
                          items: ['Winter/Fall', 'Summer/Spring', 'Casual', 'Formal', 'Individual Item']
                              .map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(fontFamily: 'Lora', color: Colors.blueAccent)),
                          ))
                              .toList(),
                          onChanged: (value) => setState(() => selectedCategory = value),
                        ),
                      ],
                    );
                  } else {
                    // Use a Row for larger screens
                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedItemType,
                            decoration: InputDecoration(labelText: 'Type of Item'),
                            items: ['Clothing', 'Shoe', 'Jewellery', 'Accessories']
                                .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(fontFamily: 'Lora')),
                            ))
                                .toList(),
                            onChanged: (value) => setState(() => selectedItemType = value),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(labelText: 'Category'),
                            items: ['Winter/Fall', 'Summer/Spring', 'Casual', 'Formal', 'Individual Item']
                                .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(fontFamily: 'Lora', color: Colors.blueAccent)),
                            ))
                                .toList(),
                            onChanged: (value) => setState(() => selectedCategory = value),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),

            ],
          ),
        ),

      ),

    );

  }





}



