
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/screen/auth/landing_page.dart';
import 'package:food_sharing/screen/auth/welcome.dart';
import 'package:food_sharing/screen/app_frame.dart';

import "package:provider/provider.dart";

class AuthGate extends StatefulWidget {
  
  final String title;
  final List<String> subtitle;

  const AuthGate({
    super.key, 
    required this.title,
    required this.subtitle
  });

  @override 
  AuthGateState createState() => AuthGateState();
}

class AuthGateState extends State<AuthGate>{


  @override
  Widget build(BuildContext context) {

    final authProvider = context.watch<AppAuthProvider>();
    Stream<User?> userStream = context.watch<AppAuthProvider>().uStream;
    
    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return LandingPage(
            title: widget.title,
            subtitle: widget.subtitle,
          );
        }

        return const AppFrame(); // or your main home
      },
    );
  }
}