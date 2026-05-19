// AUTH_PROVIDER.DART

// IMPORTS ---------------------------------------------------------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';
import '../models/user.dart' as model;
// ---------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------
// whenever someone logs in or out, it send signal to the whole app
class AppAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;

  // change to true when server is confirming a new user
  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;
  
  // user's id and profile
  User? userObj; // authentication token (managed by firebase)
  model.User? customUserData; // application schema (managed by firestore)

  AppAuthProvider() {
    authService = FirebaseAuthAPI();

    // if the user logs out, it will clear their data so next user wont see
    authService.getUser().listen((User? newUser) async {
        userObj = newUser;
        if (newUser != null) {
          // if session exists, trigger a fetch for the related document in the firestore
          await refreshUser();
        } else {
          // clean up, ensure no data remains in memory after logout
          customUserData = null;
          notifyListeners();
        }
    }); 

    fetchAuthentication();
  }

  // data synchronization / cache refresh
  // fetches user's document from the collection
  Future<void> refreshUser() async {
    if (userObj != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userObj!.uid)
          .get();
      
      if (doc.exists && doc.data() != null) {
        // converts semi structured database data into an object
        customUserData = model.User.fromJson(doc.data()!);
        notifyListeners();
      }
    }
  }

  // getters
  // provides read-only access to private state var
  String? get uid => userObj?.uid;
  User? get user => userObj;
  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();
    notifyListeners();
  }

  // sign up 
  // state start -> API call -> state end
  Future<String?> signUp(String firstName, String lastName, String userName, String email, String password) async {
    String? code;
    try {
        _isRegistering = true; // set state to pending
        notifyListeners(); 
        code = await authService.signUp(firstName, lastName, userName, email, password);
    } finally {
      _isRegistering = false; // set state to idle regardless of a success or a failure
      notifyListeners();
    }
    return code;
  }

  // validates credentials
  Future<String?> signIn(String email, String password) async {
    String? code = await authService.signIn(email, password);
    notifyListeners();
    return code;
  }

  // terminate a session
  // destroys local token and clears state
  Future<void> signOut() async {
    await authService.signOut();
    customUserData = null;
    notifyListeners();
  }
}
// ---------------------------------------------------------------------------------------