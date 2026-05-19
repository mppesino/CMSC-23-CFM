import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_sharing/api/firebase_posts_api.dart';
import '../models/post.dart';

import 'package:food_sharing/utils.dart';
import 'package:food_sharing/models/user.dart' as model;

class PostsProvider with ChangeNotifier {
  final FirebasePostsApi firebaseService = FirebasePostsApi();

  Stream<QuerySnapshot> getPostsByInterests(List<String> interests) {
    if (interests.isEmpty) {
      return firebaseService.getAllPosts(); 
    }

    return FirebaseFirestore.instance
        .collection('posts')
        .where('tags', arrayContainsAny: interests)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamPostById(String id) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
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


  Stream<List<Post>> getNearbyPosts({required model.User currentUser, required List<String> interests, bool filterByInterests = false}){
    final Stream<QuerySnapshot> rawStream = (interests.isEmpty || !filterByInterests)? 
      firebaseService.getAllPosts() : FirebaseFirestore.instance.collection('posts').where('tags', arrayContainsAny: interests).snapshots();
  
    return rawStream.map((snapshot){
      List<Post> filteredPosts = [];

      double userLat = currentUser.lat;
      double userLng = currentUser.lng;

      for(var doc in snapshot.docs){
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        final post = Post.fromJson(data);

        //only evaluate active items with valid coordinates:
        if(post.status == PostStatus.available && post.postLat != null && post.postLng != null){
          double distance = calculateDistance(userLat, userLng, post.postLat, post.postLng);

          //check if item is inside user's saved radius boundary:
          if(distance<=currentUser.discoveryRadius) filteredPosts.add(post);
        } 
      }

      return filteredPosts;
    });
  
  }
}