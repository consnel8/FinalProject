import 'package:flutter/material.dart';

class EditOutfitPage extends StatefulWidget {
  @override
  _EditOutfitPageState createState() => _EditOutfitPageState();
}

class _EditOutfitPageState extends State<EditOutfitPage> {
  String? selectedItemType;
  String? selectedCategory;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit your Outfit'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: Icon(Icons.image), onPressed: () {
            // Will implement image selection functionality here
          }),
          IconButton(icon: Icon(Icons.share), onPressed: () {
            //  Will implement share functionality here
          }),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {
            // optional when needed
          }),
        ],
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
                    Icon(Icons.image, size: 100, color: Colors.grey),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.add),
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
            SizedBox(height: 20),
            // Description Section
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
            // Type of Item Dropdown
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
            // Category Dropdown
            ListTile(
              leading: Icon(Icons.star_border),
              title: Text('Category'),
              subtitle: Text('Winters, Casual, Formal, etc.'),
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
                hint: Text('Select'),
              ),
            ),
            Spacer(),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.cancel, color: Colors.grey),
                  label: Text('Cancel'),
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Save'),
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
