
import 'package:cloud_firestore/cloud_firestore.dart';
class Outfit {
  final String id;
  final String title;
  final String description;
  final String category;
  final String typeOfItem; // New field
  final String imageUrl;
   bool isFavorite;
   final DateTime dateLiked;

  Outfit({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.typeOfItem, // Initialize the new field
    required this.imageUrl,
    required this.isFavorite,
    required this.dateLiked,
  });


  // Update the factory constructor for Firestore
  factory Outfit.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Outfit(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      typeOfItem: data['typeOfItem'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      dateLiked: data['dateLiked'] != null
          ? (data['dateLiked'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }


  factory Outfit.fromMap(Map<String, dynamic> map, String id) {
    return Outfit(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      typeOfItem: map['typeOfItem'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      dateLiked: map['dateLiked'] != null
          ? (map['dateLiked'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'typeOfItem': typeOfItem,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'dateLiked': Timestamp.fromDate(dateLiked),
    };
  }



}








