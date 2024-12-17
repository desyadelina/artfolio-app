


import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instanceFor(bucket: "gs://artfolio-app.appspot.com");
  final _auth = FirebaseAuth.instance;

  Future<void> create(Portfolio portfolio, List<Uint8List> images) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        String imageUrl = await _uploadImage(images[i]);
        imageUrls.add(imageUrl);
      }

      await _firestore.collection('portfolio').add({
        'title': portfolio.title,
        'description': portfolio.description,
        'link': portfolio.link,
        'images': imageUrls,
        'user_id': user.uid,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String> _uploadImage(Uint8List imageData) async {
    try {
      var uuid = Uuid();
      String uniqueFileName = uuid.v4(); // Generate a unique ID for the image
      final ref = storage.ref().child('portfolio_images/$uniqueFileName');
      await ref.putData(imageData);
      return await ref.getDownloadURL();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> deletePortfolio(String portfolioId) async {
    try {
      await _firestore.collection('portfolio').doc(portfolioId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> addComment(String portfolioId, String comment) async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      await _firestore.collection('portfolio').doc(portfolioId).collection('comments').add({
        'comment': comment,
        'username': user.displayName,
        'profileImageUrl': user.photoURL,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

class Portfolio {
  final String title;
  final String description;
  final String link;

  Portfolio({
    required this.title,
    required this.description,
    required this.link,
  });
}
