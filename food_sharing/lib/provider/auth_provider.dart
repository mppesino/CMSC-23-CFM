import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

class AppAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  bool _isRegistering = false;
  bool get isRegistering => _isRegistering;
  
  User? userObj;

  AppAuthProvider() {
    authService = FirebaseAuthAPI();

    authService.getUser().listen((User? newUser) {
        userObj = newUser;
        notifyListeners(); 
    }); 

    fetchAuthentication();
  }

  String? get uid => userObj?.uid;
  User? get user => userObj;
  Stream<User?> get userStream => uStream;

  void fetchAuthentication() {
    uStream = authService.getUser();
    notifyListeners();
  }

  Future<String?> signUp(String firstName, String lastName, String email, String password) async {
    String? code;
    try {
       _isRegistering = true;  // Prevent sign-up page going to homepage when pressing back (this shows null user)
        code = await authService.signUp(firstName, lastName, email, password);
    } finally {
      _isRegistering = false; 
      notifyListeners();
    }
    return code;
  }

  Future<String?> signIn(String email, String password) async {
    String? code;
    code = await authService.signIn(email, password);
    print(code);
    notifyListeners();
    return code;
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

}
