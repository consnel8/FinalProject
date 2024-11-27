import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class account_page extends StatefulWidget {
  const account_page({super.key});

  @override
  State<account_page> createState() => _AccountPageState();
}

class _AccountPageState extends State<account_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: TextStyle(
            fontFamily: 'Teko',
            fontSize: 50,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  "Delete Data?",
                  style: TextStyle(
                    fontFamily: 'Lora',
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: deletionAlert,
                child: const Text(
                  "Begin Data Deletion",
                  style: TextStyle(
                    fontFamily: 'Lora',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deletionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          "Delete Data?",
          style: TextStyle(
            fontFamily: 'Lora',
            fontSize: 18,
          ),
        ),
        content: const Text(
          "Are you sure you'd like to delete your data? This action cannot be undone.",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 18,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteUserData();
            },
            child: Text(
              "Proceed",
              style: TextStyle(
                fontFamily: 'Lora',
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUserData() async {
    final user = _auth.currentUser;

    if (user == null) {
      _showMessage("No user is logged in.");
      return;
    }

    try {
      final userDocRef = _firestore.collection('users').doc(user.uid);

      // Delete subcollections and documents
      final subcollections = ['recipes', 'journal', 'wardrobe'];
      for (String subcollection in subcollections) {
        final querySnapshot = await userDocRef.collection(subcollection).get();
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      }

      // Delete the main document
      await userDocRef.delete();

      // Optionally, delete the user's authentication record
      await user.delete();

      _showMessage("Your data has been successfully deleted.");
    } catch (e) {
      _showMessage("An error occurred while deleting data: $e");
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
