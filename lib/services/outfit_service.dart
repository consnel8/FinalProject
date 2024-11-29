

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


import '../models/outfit_model.dart';


class OutfitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Stream<List<Outfit>> getOutfitsStream() {
    return _firestore.collection('outfits').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Outfit.fromDocumentSnapshot(doc);
      }).toList();
    });
  }


  // Fetch all outfits
  Future<List<Outfit>> fetchOutfits() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('outfits').get();
      return querySnapshot.docs
          .map((doc) => Outfit.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching outfits: $e');
      return [];
    }
  }

  // Add or update an outfit
  Future<void> saveOutfit(Outfit outfit) async {
    try {
      await FirebaseFirestore.instance
          .collection('outfits')
          .doc(outfit.id)
          .set(outfit.toMap());
    } catch (e) {
      print('Error saving outfit: $e');
    }
  }



  // Toggle favorite status
  Future<void> toggleFavorite(String outfitId, bool isFavorite) async {
    try {
      await _firestore.collection('outfits').doc(outfitId).update(
          {'isFavorite': isFavorite});
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }


  // Upload image to Firebase Storage and return the URL
  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = imageFile.path
          .split('/')
          .last;
      final ref = _storage.ref().child('outfit_images/$fileName');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> addOutfit({
    required String title,
    required String description,
    required String category,
    required String typeOfItem,
    required String imageUrl,
  }) async {
    try {
      final docRef = _firestore.collection('outfits').doc();
      final newOutfit = {
        'id': docRef.id,
        'title': title,
        'description': description,
        'category': category,
        'typeOfItem': typeOfItem, // New field
        'imageUrl': imageUrl,
        'isFavorite': false,
      };
      await docRef.set(newOutfit);
    } catch (e) {
      print('Error adding outfit: $e');
    }
  }


  Future<void> deleteOutfit(String id) async {
    try {
      await _firestore.collection('outfits').doc(id).delete();
    } catch (e) {
      print('Error deleting outfit: $e');
    }
  }
  Future<String?> _uploadImage(File imageFile) async {
    final fileName = DateTime.now().toIso8601String(); // Use a unique filename
    final storageRef = FirebaseStorage.instance.ref().child('outfit_images/$fileName');

    try {
      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl; // Return the URL of the uploaded image
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Handle the error
    }
  }





}



