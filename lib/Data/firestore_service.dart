import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spendee/Data/user.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

class FirebaseService {
  FirebaseService();

  Future<String> uploadImageToFirebase(File imageSelected) async {
    try {
      // Create a reference to the image location in Firebase Storage
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageSelected);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (e) {
      throw "Error uploading profile picture.";
    }
  }

  Future<void> addUserToFirestore(SignedinUser user) async {
    try {
      // Convert User object to map
      Map<String, dynamic> userData = user.toJson();

      // Set user data in Firestore
      await usersCollection.doc(user.email).set(userData);
    } catch (e) {
      throw 'Error adding user to Firestore. Please try again.';
    }
  }

  Future<Map<String, dynamic>?> getDocument(
      String collection, String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection(collection)
              .doc(documentId)
              .get();

      if (documentSnapshot.exists) {
        // Document exists, return its data
        Map<String, dynamic> data = documentSnapshot.data()!;
        return data;
      } else {
        // Document does not exist
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error retrieving document: $e");
      return null;
    }
  }
}
