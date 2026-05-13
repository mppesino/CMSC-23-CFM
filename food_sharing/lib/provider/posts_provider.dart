import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart'; // Import the model from the file above

class PostsProvider extends ChangeNotifier {

  // Stream used by the _PostsFeed in PantryPage
  Stream<QuerySnapshot> get post {
    return _firestore
        .collection('posts')
        .orderBy('expiration', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> userPost(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('expiration', descending: false)
        .snapshots();
  }

  // Method to add a new post to Firestore
  Future<void> addPost(Post post, String? uid) async {
    try {
      // Create a new document reference to get a generated ID
      final docRef = _firestore.collection('posts').doc();
      
      // Update the post object with the new ID
      post.id = docRef.id;
      post.userId = uid;

      // Save to Firestore
      await docRef.set(post.toJson());
      
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding post: $e");
      rethrow;
    }
  }

  // Optional: Method to update post status (e.g., to 'reserved')
  Future<void> updatePostStatus(String postId, PostStatus newStatus) async {
    await _firestore.collection('posts').doc(postId).update({
      'status': newStatus.name,
    });
    notifyListeners();
  }
}