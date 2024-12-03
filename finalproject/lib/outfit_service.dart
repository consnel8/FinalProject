

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'outfit_model.dart';
import 'package:http/http.dart' as http;

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
          : _firestore.collection('outfits').doc(outfit.id); // Use provided ID

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
        'typeOfItem': typeOfItem,
        'imageUrl': imageUrl,
        'isFavorite': false,
        'dateLiked': DateTime.now(), // Current date
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

   Future<String?> uploadImage(File imageFile) async {
     try {
       final fileName = DateTime.now();
       final storageRef = FirebaseStorage.instance.ref().child('outfit_images/$fileName');
       final uploadTask = storageRef.putFile(imageFile);

       final snapshot = await uploadTask;
       return await snapshot.ref.getDownloadURL();
     } catch (e) {
       print("Firebase upload failed: $e");
       return null;
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


   Future<bool> isValidImageUrl(String url) async {
     try {
       final uri = Uri.parse(url);
       if (!uri.hasAbsolutePath) return false;

       final response = await HttpClient().headUrl(uri).then((request) => request.close());
       return response.statusCode == 200 &&
           (response.headers.contentType?.mimeType.startsWith('image/') ?? false);
     } catch (e) {
       print("Error validating image URL: $e");
       return false;
     }
   }

}



