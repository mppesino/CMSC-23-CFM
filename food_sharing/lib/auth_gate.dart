
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/screen/auth/landing_page.dart';
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
    
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {

        if (authProvider.isRegistering) {
          print("Registering!");
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
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          print("No data!");
          return LandingPage(            
            title: widget.title,
            subtitle: widget.subtitle,
        );
        }

        print("App frame time");
        return const AppFrame(); // or your main home
      },
    );
  }
}