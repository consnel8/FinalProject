
import 'package:cloud_firestore/cloud_firestore.dart';
class Outfit {
  final String id;
  final String title;
  final String description;
  final String category;
  final String typeOfItem; // New field
  final String imageUrl;
  final bool isFavorite;

  Outfit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.typeOfItem, // Initialize the new field
    required this.imageUrl,
    required this.isFavorite,
  });

  // Update the `toMap` method
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'typeOfItem': typeOfItem, // Add this field
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  // Update the factory constructor for Firestore

  factory Outfit.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Outfit(
      id: doc.id,
      title: data['title'] is String ? data['title'] : '',
      description: data['description'] is String ? data['description'] : '',
      category: data['category'] is String ? data['category'] : '',
      typeOfItem: data['typeOfItem'] is String ? data['typeOfItem'] : '',
      imageUrl: data['imageUrl'] is String ? data['imageUrl'] : '',
      isFavorite: data['isFavorite'] is bool ? data['isFavorite'] : false,
    );
  }

}






