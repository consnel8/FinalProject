
import 'package:flutter/material.dart';
import 'package:icon_forest/icon_forest.dart';


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

  void selectImage(String part) {
    setState(() {
      outfitParts[part] ='https://www.pinterest.com/pin/693234627056275160/'; // Placeholder
    });
  }

  void saveOutfit() {
    if (descriptionController.text.isNotEmpty &&
        selectedItemType != null &&
        selectedCategory != null &&
        outfitParts.values.every((image) => image != null)) {
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
        SnackBar(content: Text('Please fill all fields and select images for each part')),
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
            Text(
              'Select Images for Outfit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
                                ? Image.network(
                              outfitParts[part]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                                : Icon(Icons.image, size: 100, color: Colors.grey),
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
            ),
            SizedBox(height: 20),
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
          ],
        ),
      ),
    );
  }
}
