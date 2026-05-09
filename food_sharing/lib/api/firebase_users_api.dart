import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUsersApi {
  final FirebaseFirestore db = FirebaseFirestore.instance;


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

  Future<DocumentSnapshot> getUser(String uid) async {
    return await db.collection('users').doc(uid).get();
  }

  Future<String> editUser(String uid, Map<String, dynamic> updates) async {
    try {
      await db.collection('users').doc(uid).update(updates);
      return "Updated user successfully!";
    } catch (e) {
      return "Error: $e";
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

  Future<bool> isUsernameTaken(
    String username,
    {String? userId}
  ) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: username.trim())
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      return false;
    }
    final doc = result.docs.first;

    if (userId != null && doc.id == userId) {
    return false;
    }

    return true;
}
}