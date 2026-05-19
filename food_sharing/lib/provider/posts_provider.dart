// POSTS_PROVIDER.DART

// ---------------------------------------------------------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_sharing/api/firebase_posts_api.dart';
import '../models/post.dart';
// ---------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------
// CRUD operations for posts
class PostsProvider with ChangeNotifier {
  final FirebasePostsApi firebaseService = FirebasePostsApi();

  Stream<QuerySnapshot> getPostsByInterests(List<String> interests) {
    // if there are no interests, it returns all posts
    if (interests.isEmpty) {
      return firebaseService.getAllPosts(); 
    }

    // indexing, order by createdAt (date/time)
    return FirebaseFirestore.instance
        .collection('posts')
        .where('tags', arrayContainsAny: interests)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // real-time object tracking
  // if a post is updated, the ui updates instantly
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamPostById(String id) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .snapshots();
  }

  // keeps hte app in sync
  Stream<QuerySnapshot> getAllPosts() {
    return firebaseService.getAllPosts();
  }

  Stream<QuerySnapshot> getPostsByUser(String uid) {
    return firebaseService.getPostsByUser(uid);
  }

  Stream<List<QueryDocumentSnapshot<Object?>>> getPostsByTransaction(String uid) {
    return firebaseService.getPostsByTransaction(uid);
  }

  // data deserialization
  // fetch raw map data and onverts into post instance
  Future<Post?> getPostById(String id) async {
    final doc = await firebaseService.getPost(id);
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Post.fromJson(data);
  }

  // write operation
  // add ----------------------------------------
  Future<void> addPost(Post post, String? uid) {
    return firebaseService.addPost(post.toJson(), uid);
  }

  // edit ---------------------------------------
  Future<void> editPost(String id, Map<String, dynamic> updates) {
    return firebaseService.editPost(id, updates);
  }

  // delete --------------------------------------
  Future<void> deletePost(String id) {
    return firebaseService.deletePost(id);
  }

  // update ---------------------------------------
  Future<void> updatePostStatus(String id, PostStatus status) {
    return firebaseService.updatePostStatus(id, status);
  }
}
// ---------------------------------------------------------------------------------------