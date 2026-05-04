import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/api/firebase_posts_api.dart';
import 'package:food_sharing/models/transaction.dart';
import '../models/post.dart';

class PostsProvider with ChangeNotifier{

  late Stream<QuerySnapshot> _postsStream;
  final FirebasePostsApi firebaseService = FirebasePostsApi();

  PostsProvider(String? uid){
    fetchPosts(uid);
  }

  Stream<QuerySnapshot> get post => _postsStream;

  void fetchPosts(String? uid){
    if (uid != null) {
      _postsStream = firebaseService.getPostsByUser(uid);
    } else {
      _postsStream = firebaseService.getAllPosts();
    }
    notifyListeners();
  }

  Future<Post?> getPostById(String id) async {
    try {
      DocumentSnapshot doc = await firebaseService.getPost(id); 
      
      if (doc.exists) {
        return Post.fromJson(doc.data() as Map<String, dynamic>..['id'] = doc.id);
      }
      return null;
    } catch (e) {
      print("Error getting post: $e");
      return null;
    }
  }

  Future<void> addPost(Post post, String? uid) async {
    String message = await firebaseService.addPost(post.toJson(), uid);
    print(message);
    notifyListeners();
  }

  Future<void> editPost(String id, Map<String, dynamic> post) async {
    String message = await firebaseService.editPost(id, post);
    print(message);
    notifyListeners();
  }

  Future<void> deletePost(String id) async {
    String message = await firebaseService.deletePost(id);
    print(message);
    notifyListeners();
  }

  Future<void> updatePostStatus(String id, TransactionStatus status) async {
    String message = await firebaseService.updatePostStatus(id, status);
    print(message);
    notifyListeners();
  }


}