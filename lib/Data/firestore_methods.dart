import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spendee/Data/user.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

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

  Future<void> addUserToFirestore( SignedinUser user) async {
    try {
      // Convert User object to map
      Map<String, dynamic> userData = user.toJson();
      
      // Set user data in Firestore
      await usersCollection.doc(user.email).set(userData);
    } catch (e) {
      throw 'Error adding user to Firestore. Please try again.';
    }
  }

  // Future<void> storeUserInfo(SignedinUser user) async {
  //   try {
  //     Map<String, dynamic> userInfo = user.toJson();
  //     await _firestore.collection('users').doc(userInfo['uid']).set({
  //       'displayName': displayName,
  //       // Add more fields as needed
  //     });
  //   } catch (e) {
  //     print('Error storing user info: $e');
  //     throw e; // Rethrow the exception to handle it elsewhere if needed
  //   }
  // }
}
