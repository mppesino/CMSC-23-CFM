import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/api/firebase_users_api.dart';
import '../models/user.dart';

class UsersProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _usersStream;
  final FirebaseUsersApi firebaseService = FirebaseUsersApi();

  UsersProvider() {
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _usersStream;

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  // ✅ FIXED: use getUserOnce instead of stream
  Future<User?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await firebaseService.getUserOnce(uid);

      if (doc.exists && doc.data() != null) {
        return User.fromJson(
          doc.data() as Map<String, dynamic>
            ..['userId'] = doc.id, // ✅ correct field
        );
      }
      return null;
    } catch (e) {
      debugPrint("Error getting user: $e");
      return null;
    }
  }

  Future<void> addUser(User user, String uid) async {
    String message = await firebaseService.addUser(user.toJson(), uid);
    debugPrint(message);
    notifyListeners();
  }

  Future<void> editUser(String uid, Map<String, dynamic> user) async {
    String message = await firebaseService.editUser(uid, user);
    debugPrint(message);
    notifyListeners();
  }

  Future<void> deleteUser(String uid) async {
    String message = await firebaseService.deleteUser(uid);
    debugPrint(message);
    notifyListeners();
  }
}