import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/api/firebase_users_api.dart';
import '../models/user.dart';

class UsersProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _usersStream;
  final FirebaseUsersApi firebaseService = FirebaseUsersApi();

  User? _currentUser;
  User? get currentUser => _currentUser;


  UsersProvider() {
    fetchUsers();
  }

  Stream<QuerySnapshot> get users => _usersStream;

  void fetchUsers() {
    _usersStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  Future<void> loadUser(String uid) async {
  try {
    final user = await getUserById(uid);
    _currentUser = user;
    notifyListeners();
  } catch (e) {
    debugPrint("Error loading user: $e");
  }
  }

  void clearUser() {
  _currentUser = null;
  notifyListeners();
  }

  Future<User?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await firebaseService.getUser(uid);

      if (doc.exists && doc.data() != null) {
        return User.fromJson(
          doc.data() as Map<String, dynamic>
            ..['userId'] = doc.id, 
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

    if (_currentUser != null && _currentUser!.userId == uid) {
      _currentUser = User(
        userId: _currentUser!.userId,
        email: _currentUser!.email,
        firstName: _currentUser!.firstName,
        lastName: _currentUser!.lastName,
        userName: _currentUser!.userName,
        bio: _currentUser!.bio,
        profilePicture: _currentUser!.profilePicture,
        isOnboarded: user['isOnboarded'] ?? _currentUser!.isOnboarded,
        tags: user['tags'] != null
            ? Map<String, String>.from(user['tags'])
            : _currentUser!.tags,
      );
    }

    notifyListeners();


    debugPrint(message);
    notifyListeners();
  }

  Future<void> deleteUser(String uid) async {
    String message = await firebaseService.deleteUser(uid);
    debugPrint(message);
    notifyListeners();
  }
}