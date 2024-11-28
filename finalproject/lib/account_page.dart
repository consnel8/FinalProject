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
        title: const Text(
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
                child: const Text(
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
            child: const Text(
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
              await _checkAndDeleteData();
            },
            child: const Text(
              "Delete",
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

  Future<void> _checkAndDeleteData() async {
    final user = _auth.currentUser;

    if (user == null) {
      // If no user is logged in, show a prompt.
      _showLoginRequiredMessage();
      return;
    }

    try {
      await _deleteUserData(user.uid);
    } catch (e) {
      _showMessage("An error occurred: $e");
    }
  }

  void _showLoginRequiredMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text(
            "You need to be logged in to delete your data. Please log in and try again.",
          ),
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

  Future<void> _deleteUserData(String uid) async {
    try {
      final userDocRef = _firestore.collection('users').doc(uid);

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
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      }

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
