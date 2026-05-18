import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';
import '../models/user.dart' as model;

class AppAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;
  
  User? userObj;
  model.User? customUserData;

  AppAuthProvider() {
    authService = FirebaseAuthAPI();

    authService.getUser().listen((User? newUser) async {
        userObj = newUser;
        if (newUser != null) {
          await refreshUser();
        } else {
          customUserData = null;
          notifyListeners();
        }
    }); 

    fetchAuthentication();
  }

  Future<void> refreshUser() async {
    if (userObj != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userObj!.uid)
          .get();
      
      if (doc.exists && doc.data() != null) {
        customUserData = model.User.fromJson(doc.data()!);
        notifyListeners();
      }
    }
  }

  String? get uid => userObj?.uid;
  User? get user => userObj;
  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();
    notifyListeners();
  }

  Future<String?> signUp(String firstName, String lastName, String userName, String email, String password) async {
    String? code;
    try {
        _isRegistering = true; 
        notifyListeners(); 
        code = await authService.signUp(firstName, lastName, userName, email, password);
    } finally {
      _isRegistering = false; 
      notifyListeners();
    }
    return code;
  }

  Future<String?> signIn(String email, String password) async {
    String? code = await authService.signIn(email, password);
    notifyListeners();
    return code;
  }

  Future<void> signOut() async {
    await authService.signOut();
    customUserData = null;
    notifyListeners();
  }
}