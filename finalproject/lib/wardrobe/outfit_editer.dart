import 'package:flutter/material.dart';

class EditOutfitPage extends StatefulWidget {
  final Map<String, dynamic> outfit;
  final Function(Map<String, dynamic>) onSave;
  const EditOutfitPage({super.key, required this.outfit, required this.onSave});

  @override
  _EditOutfitPageState createState() => _EditOutfitPageState();
}

class _EditOutfitPageState extends State<EditOutfitPage> {
  late TextEditingController _titleController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late String _imageUrl;
  String? selectedItemType;
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.outfit['title']);
    _categoryController = TextEditingController(text: widget.outfit['category']);
    _descriptionController = TextEditingController(text: widget.outfit['description'] ?? '');
    _imageUrl = widget.outfit['image'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit  Outfit'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.image), onPressed: () {
            // Will implement image selection functionality here
          }),
         // IconButton(icon: Icon(Icons.share), onPressed: () {
            //  Will implement share functionality here
         // }),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {
            //this gives option to delete entire outfit
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
         // crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Icon(Icons.image, size: 100, color: Colors.grey),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            //  Will implement image adding functionality here
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Name (Description)',
                helperText: '180 characters max',
              ),
              maxLength: 180,
            ),
            const SizedBox(height: 20),
            // Type of Item Dropdown
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Type of Item'),
              subtitle: const Text('Clothing, Shoe, Jewellery, etc.'),
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
                hint: const Text('Select'),
              ),
            ),
            // Category Dropdown
            ListTile(
              leading: const Icon(Icons.star_border),
              title: const Text('Category'),
              subtitle: const Text('Winters, Casual, Formal, etc.'),
              trailing: DropdownButton<String>(
                value: selectedCategory,
                items: <String>['Winters', 'Casual', 'Formal']
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
                hint: const Text('Select'),
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
                  label: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // will be adding a  saving logic here
                    if (descriptionController.text.isNotEmpty &&
                        selectedItemType != null &&
                        selectedCategory != null) {
                      // Saving outfit details and pop the page
                      Navigator.pop(context);
                    } else {
                      //if fields empty throw error
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all the fields'),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Save Changes'),
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
