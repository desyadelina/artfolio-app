
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: "gs://artfolio-app.appspot.com");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateProfile({
    required String displayName,
    required String username,
    required String description,
    XFile? profileImage,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(profileImage);
      } else {
        var currentProfile = await getProfile();
        profileImageUrl = currentProfile?['profileImageUrl'];
      }

      await _firestore.collection('profiles').doc(user.uid).set({
        'displayName': displayName,
        'username': username,
        'description': description,
        'profileImageUrl': profileImageUrl,
        'user_id': user.uid,
      }, SetOptions(merge: true));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    DocumentSnapshot doc = await _firestore.collection('profiles').doc(user.uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<String> _uploadProfileImage(XFile profileImage) async {
    try {
      final file = File(profileImage.path);
      if (!file.existsSync()) {
        throw Exception('Profile image does not exist at path: ${profileImage.path}');
      }

      log('Uploading profile image from path: ${profileImage.path}');
      final ref = _storage.ref().child('profile_images').child('${_auth.currentUser!.uid}.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      log('Error uploading profile image: $e');
      rethrow;
    }
  }
}
