import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUsersApi {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> getUser(String uid) {
    return db.collection('users').doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection('users').snapshots();
  }

  Future<String> addUser(Map<String, dynamic> user, String uid) async {
    try {
      final docRef = db.collection('users').doc(uid);

      user['userId'] = uid;

      await docRef.set(user);

      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<DocumentSnapshot> getUserOnce(String uid) async {
    return await db.collection('users').doc(uid).get();
  }

  Future<String> editUser(String uid, Map<String, dynamic> user) async {
    try {
      await db.collection('users').doc(uid).update({
        'name': user['name'],
        'bio': user['bio'],
        'profile_picture': user['profile_picture'],
        'tags': user['tags'],
      });

      return "Successfully updated user!";
    } on FirebaseException catch (e) {
      return "Error on ${e.code}: ${e.message}";
    }
  }

  Future<String> deleteUser(String uid) async {
    try {
      await db.collection('users').doc(uid).delete();
      return "Successfully deleted user!";
    } on FirebaseException catch (e) {
      return "Error on ${e.code}: ${e.message}";
    }
  }
}