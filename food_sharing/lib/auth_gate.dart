
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/screen/landing_page.dart';
import 'package:food_sharing/screen/welcome.dart';

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
    
    return StreamBuilder( // Show different screen depending on if user is logged in or not
      stream: userStream,
      builder: (context, snapshot){

          if (authProvider.isRegistering) {
            return LandingPage(title: widget.title, subtitle: widget.subtitle,);
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return LandingPage(title: widget.title, subtitle: widget.subtitle,);
          }
          return const WelcomeScreen();
      },

    );
  }
}