import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_sharing/models/post.dart';
import 'package:rxdart/rxdart.dart';

class FirebasePostsApi {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllPosts() {
    return db.collection('posts')
    .orderBy('createdAt', descending: true)
    .snapshots(); 
  }

  Stream<QuerySnapshot> getPostsByUser(String? uid) {
    return db.collection('posts')
    .where('userId', isEqualTo: uid)
    .orderBy('createdAt', descending: true)
    .snapshots(); 
  }

  Future<DocumentSnapshot> getPost(String id) async {
    return await db.collection('posts').doc(id).get();
  }

Stream<List<QueryDocumentSnapshot>> getPostsByTransaction(String uid) {
  final requested = db
      .collection('posts')
      .where('requesterIds', arrayContains: uid)
      .snapshots();

  final reserved = db
      .collection('posts')
      .where('reservedForId', isEqualTo: uid)
      .snapshots();

  return Rx.combineLatest2(
    requested,
    reserved,
    (QuerySnapshot a, QuerySnapshot b) {
      final map = <String, QueryDocumentSnapshot>{};

      for (var doc in a.docs) {
        map[doc.id] = doc;
      }
      for (var doc in b.docs) {
        map[doc.id] = doc;
      }

      return map.values.toList();
    },
  );
}

  Future<String> addPost(Map<String, dynamic> post, String? uid) async {
    try {
      DocumentReference docRef = db.collection('posts').doc();
      post['id'] = docRef.id;
      post['userId'] = uid; 

      await docRef.set(post);
      return "Successfully added post!";
    } on FirebaseException catch (e) {
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> deletePost(String id) async {
    try {
      await db.collection('posts').doc(id).delete();
      return "Successfully deleted post!";
    } on FirebaseException catch (e) {
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> editPost(String id,Map<String, dynamic> updates) async {
    try {
      await db.collection('posts').doc(id).update(updates);
      return "Successfully edited post!";
    } on FirebaseException catch (e) {
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> updatePostStatus(String id, PostStatus status) async {
    try {
      await db.collection('posts').doc(id).update({
        'status': status.name,
      });
      return "Successfully updated post status!";
    } on FirebaseException catch (e) {
      return "Error on ${e.code}: ${e.message}";
    }
  }
}