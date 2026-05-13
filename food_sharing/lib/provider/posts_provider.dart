import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_sharing/api/firebase_posts_api.dart';
import 'package:food_sharing/models/transaction.dart';
import '../models/post.dart';

class PostsProvider with ChangeNotifier {
  final FirebasePostsApi firebaseService = FirebasePostsApi();

  Stream<QuerySnapshot> getAllPosts() {
    return firebaseService.getAllPosts();
  }

  Stream<QuerySnapshot> getPostsByUser(String uid) {
    return firebaseService.getPostsByUser(uid);
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

  Future<void> editPost(String id, Map<String, dynamic> post) {
    return firebaseService.editPost(id, post);
  }

  Future<void> deletePost(String id) {
    return firebaseService.deletePost(id);
  }

  Future<void> updatePostStatus(String id, TransactionStatus status) {
    return firebaseService.updatePostStatus(id, status);
  }
}