// POSTS_PROVIDER.DART

// ---------------------------------------------------------------------------------------
import 'dart:math'; // Required for distance calculations
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:food_sharing/api/firebase_posts_api.dart';
import '../models/post.dart';
import '../models/user.dart' as model; // Alias to avoid conflict with Firebase User
// ---------------------------------------------------------------------------------------

class PostsProvider with ChangeNotifier {
  final FirebasePostsApi firebaseService = FirebasePostsApi();

  Stream<List<Post>> getNearbyPosts({
    required model.User currentUser, 
    required List<String> interests, 
    bool filterByInterests = false
  }) {
    final Stream<QuerySnapshot> rawStream = (interests.isEmpty || !filterByInterests)
        ? firebaseService.getAllPosts()
        : FirebaseFirestore.instance
            .collection('posts')
            .where('tags', arrayContainsAny: interests)
            .snapshots();

    return rawStream.map((snapshot) {
      List<Post> filteredPosts = [];

      double userLat = currentUser.lat;
      double userLng = currentUser.lng;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        final post = Post.fromJson(data);

        // only evaluate active items with valid coordinates:
        if (post.status == PostStatus.available && post.postLat != null && post.postLng != null) {
          double distance = _calculateDistance(userLat, userLng, post.postLat, post.postLng);

          // check if item is inside user's saved radius boundary:
          if (distance <= currentUser.discoveryRadius) {
            filteredPosts.add(post);
          }
        }
      }

      return filteredPosts;
    });
  }

  // HELPER: Haversine Formula (Math for calculating distance on a sphere)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 - cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

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

  // 3. WRITE OPERATIONS (CRUD) ---------------------------------------------------------

  Future<void> addPost(Post post, String? uid) async {
    await firebaseService.addPost(post.toJson(), uid);
    notifyListeners(); // Updates the UI
  }

  Future<void> editPost(String id, Map<String, dynamic> updates) async {
    await firebaseService.editPost(id, updates);
    notifyListeners();
  }

  Future<void> deletePost(String id) async {
    await firebaseService.deletePost(id);
    notifyListeners();
  }

  Future<void> updatePostStatus(String id, PostStatus status) async {
    await firebaseService.updatePostStatus(id, status);
    notifyListeners();
  }
}