

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


import 'outfit_model.dart';
import 'package:uuid/uuid.dart';  // For unique ID generation
import 'package:intl/intl.dart';

class OutfitService {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;




  Future<void> updateOutfit(Outfit outfit) async {
    await _firestore.collection('outfits').doc(outfit.id).update(outfit.toMap());
  }



  Future<void> saveOutfit(Outfit outfit) async {
    try {
      // Use Firestore's auto-generated ID if the outfit's ID is empty
      final docRef = (outfit.id.isEmpty)
          ? _firestore.collection('outfits').doc() // Auto-generate ID
          : _firestore.collection('outfits').doc(outfit.id); // Use provided ID if any

      // Save the outfit to Firestore
      await docRef.set(outfit.toMap());

      print('Outfit saved successfully!');
    } catch (e) {
      print('Error saving outfit: $e');
      rethrow;
    }
  }








  Stream<List<Outfit>> getOutfitsStream() {
    return FirebaseFirestore.instance
        .collection('outfits')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Outfit.fromDocumentSnapshot(doc))
        .toList());
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
  // outfit_service.dart

  Future<void> addOutfit({
    required String title,
    required String description,
    required String category,
    required String typeOfItem,
    required String imageUrl,
  }) async {
    try {
      final docRef = _firestore.collection('outfits').doc();  // Auto-generated ID
      final newOutfit = {
        'id': docRef.id,
        'title': title,
        'description': description,
        'category': category,
        'typeOfItem': typeOfItem, // New field
        'imageUrl': imageUrl,
        'isFavorite': false,
        'dateLiked': DateTime.now().toIso8601String(), // Current date
      };
      await docRef.set(newOutfit);
    } catch (e) {
      print('Error adding outfit: $e');
    }
  }

  // Toggle favorite status in Firestore
  Future<void> toggleFavorite(String outfitId, bool isFavorite) async {
    try {
      await _firestore.collection('outfits').doc(outfitId).update({
        'isFavorite': isFavorite,
      });
      print('Favorite status updated successfully!');
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow; // Optionally rethrow the error to handle it in the UI
    }
  }

   Future<List<Outfit>> fetchFavoriteOutfits() async {
     try {
       final querySnapshot = await FirebaseFirestore.instance
           .collection('outfits')
           .where('isFavorite', isEqualTo: true)
           .get();

       return querySnapshot.docs
           .map((doc) => Outfit.fromDocumentSnapshot(doc))
           .toList();
     } catch (e) {
       print('Error fetching favorite outfits: $e');
       return [];
     }
   }



   // Upload image to Firebase Storage and return the URL
  /*Future<String?> uploadImage(File imageFile) async {
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
  }*/
   Future<String?> uploadImage(File imageFile) async {
     try {
       final fileName = DateTime.now().toIso8601String(); // Unique name
       final ref = FirebaseStorage.instance.ref().child('outfit_images/$fileName');
       final uploadTask = await ref.putFile(imageFile);
       return await uploadTask.ref.getDownloadURL(); // Return the image URL
     } catch (e) {
       print('Error uploading image: $e');
       return null; // Handle error gracefully
     }
   }





   Future<void> deleteOutfit(String outfitId) async {
     try {
       await _firestore.collection('outfits').doc(outfitId).delete();
       print('Outfit deleted successfully.');
     } catch (e) {
       print('Error deleting outfit: $e');
       throw e; // Re-throw the error to handle it in the UI
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



