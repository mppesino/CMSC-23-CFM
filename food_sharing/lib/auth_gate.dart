
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/api/firebase_users_api.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/auth/landing_page.dart';
import 'package:food_sharing/screen/app_frame.dart';
import 'package:food_sharing/screen/auth/welcome.dart';
import 'package:food_sharing/theme/app_theme.dart';

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
    
return StreamBuilder(
  stream: userStream,
  builder: (context, snapshot) {
    
    final userProvider = context.watch<UsersProvider>();
    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: BrandColors.green),
        ),
      );
    }

    if (authProvider.isRegistering) {
      return LandingPage(            
        title: widget.title,
        subtitle: widget.subtitle,
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text("Error encountered! ${snapshot.error}"),
      );
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: BrandColors.green),
      );
    } else if (!snapshot.hasData) {
      return LandingPage(            
        title: widget.title,
        subtitle: widget.subtitle,
      );
    }

    final user = context.watch<UsersProvider>().currentUser;

    if (user == null || !user.isOnboarded) {
      return const WelcomeScreen();
    }

    return const AppFrame();
  },
);
  }
}