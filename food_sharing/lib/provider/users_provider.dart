import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/api/firebase_users_api.dart';
import '../models/user.dart';

import 'package:flutter/foundation.dart';

class UsersProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _usersStream;
  final FirebaseUsersApi firebaseService = FirebaseUsersApi();

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    _isLoading = true;
    notifyListeners();
    final user = await getUserById(uid);
    _currentUser = user;

    _isLoading = false;
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

      firstName: user['firstName'] ?? _currentUser!.firstName,
      lastName: user['lastName'] ?? _currentUser!.lastName,
      userName: user['userName'] ?? _currentUser!.userName,
      bio: user['bio'] ?? _currentUser!.bio,

      profilePicture: user['profilePicture'] ?? _currentUser!.profilePicture,

      isVerified:
          user['isVerified'] ?? _currentUser!.isVerified,

      isOnboarded:
          user['isOnboarded'] ?? _currentUser!.isOnboarded,

      tags: user['tags'] != null
          ? List<String>.from(user['tags'])
          : _currentUser!.tags,


      enableDiscovery: user['enableDiscovery'] ?? _currentUser!.enableDiscovery,
      enablePickups: user['enablePickups'] ?? _currentUser!.enablePickups,
      enableRequests: user['enableRequests'] ?? _currentUser!.enableRequests,
      discoveryRadius: (user['discoveryRadius'] as num?)?.toDouble() ?? _currentUser!.discoveryRadius,

      lat: (user['lat'] as num?)?.toDouble() ?? _currentUser!.lat,
      lng: (user['lng'] as num?)?.toDouble() ?? _currentUser!.lng,
    );
  }
  notifyListeners();

  debugPrint(message);
}

  Future<bool> isUsernameTaken(String username, {String? uid}) async {
    bool? result;
    result = await firebaseService.isUsernameTaken(username, userId: uid);
    notifyListeners();
    return result;
  }


  Future<void> deleteUser(String uid) async {
    String message = await firebaseService.deleteUser(uid);
    debugPrint(message);
    notifyListeners();
  }

  
}