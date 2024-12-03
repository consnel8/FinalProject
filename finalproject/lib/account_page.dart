// imports
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // firebase
import 'package:firebase_auth/firebase_auth.dart'; // firebase

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState(); // create state
} // end AccountPage

class _AccountPageState extends State<AccountPage> {
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
          // padding and alignment consistent with other settings pages
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
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
                ], // end children
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: deletionAlert, // alert requiring confirmation from the user about deleting their data
                    child: const Text(
                      "Begin Data Deletion",
                      style: TextStyle(
                        fontFamily: 'Lora',
                      ),
                    ),
                  ),
                ], // end children
              ),
              const Row(
                children: [
                  Text(" "), // spacer
                ], // end children
              ),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text( // explains what the button will do
                    // explanation and warning for the user
                    "By clicking the above button, you agree to the complete deletion of\n"
                    "your data off the Life Palette"
                    " app. All saved cloud data will be\ncompletely wiped. This data "
                    "will not be able to be recovered.\n",
                    style: TextStyle(
                      fontFamily: 'Lora',
                      fontSize: 10,
                    ),
                  ),
                ], // end children
              )
            ], // end children
          ),
        ),
      ),
    );
  } // end build

  void deletionAlert() { // creates a pop up alert informing the user of impending
    // deletion and confirms their intent
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
          style: TextStyle(
            fontFamily: 'Lora',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, // end onPressed
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
            }, // end onPresed
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
    ); // end showDialogue
  } // end deletionAlert

  Future<void> _checkAndDeleteData() async {
    final user = _auth.currentUser;

    if (user == null) {
      // If no user is logged in, show a prompt.
      _showLoginRequiredMessage(); // user must be logged in
      return;
    } // end if

    try {
      await _deleteUserData(user.uid);
    } catch (e) {
      _showMessage("An error occurred: $e");
    } // end try-catch
  } // end _checkAndDeleteData

  void _showLoginRequiredMessage() { 
    // pop up for the user, informing of the requirement to log in to delete the cloud data
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Login Required",
            style: TextStyle(
              fontFamily: 'Lora',
            ),
          ),
          content: const Text(
            "You need to be logged in to delete your data. Please log in and try again.",
            style: TextStyle(
              fontFamily: 'Lora',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontFamily: 'Lora',
                ),
              ),
            ),
          ], // end actions
        );
      }, // end builder
    ); // end showDialogue
  } // _showLoginRequiredMessage

  Future<void> _deleteUserData(String uid) async {
    try {
      final userDocRef = _firestore.collection('users').doc(uid);

      // Delete subcollections and documents
      final subcollections = ['recipes', 'journal', 'wardrobe'];
      for (String subcollection in subcollections) {
        final querySnapshot = await userDocRef.collection(subcollection).get();
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        } // end for
      } // end for

      // Delete the main document
      await userDocRef.delete();

      // Optionally, delete the user's authentication record
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } // end for

      _showMessage("Your data has been successfully deleted.");
    } catch (e) {
      _showMessage("An error occurred while deleting data: $e");
    } // end catch
  } // end _deleteUserData

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK",
                style: TextStyle(
                  fontFamily: 'Lora',
                ),
              ),
            ),
          ], // end actions
        );
      }, // end builder
    ); // end showDialogue
  } // end _showMessage
} // _AccountPageState
