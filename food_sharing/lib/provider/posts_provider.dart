import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_sharing/api/firebase_posts_api.dart';
import '../models/post.dart';

class PostsProvider with ChangeNotifier {
  final FirebasePostsApi firebaseService = FirebasePostsApi();

  Stream<QuerySnapshot> getPostsByInterests(List<String> interests) {
    if (interests.isEmpty) {
      return firebaseService.getAllPosts(); 
    }

    return FirebaseFirestore.instance
        .collection('posts')
        .where('tags', arrayContainsAny: interests)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllPosts() {
    return firebaseService.getAllPosts();
  }

  Stream<QuerySnapshot> getPostsByUser(String uid) {
    return firebaseService.getPostsByUser(uid);
  }

  Stream<List<QueryDocumentSnapshot<Object?>>> getPostsByTransaction(String uid) {
    return firebaseService.getPostsByTransaction(uid);
  }

  Future<Post?> getPostById(String id) async {
    final doc = await firebaseService.getPost(id);
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Post.fromJson(data);
  }

  Future<void> addPost(Post post, String? uid) {
    return firebaseService.addPost(post.toJson(), uid);
  }

  Future<void> editPost(String id, Map<String, dynamic> updates) {
    return firebaseService.editPost(id, updates);
  }

  Future<void> deletePost(String id) {
    return firebaseService.deletePost(id);
  }

  Future<void> updatePostStatus(String id, PostStatus status) {
    return firebaseService.updatePostStatus(id, status);
  }
}