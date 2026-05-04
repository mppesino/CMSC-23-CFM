import 'package:flutter/material.dart';
import 'package:food_sharing/screen/app_frame.dart';
import 'package:food_sharing/screen/landing_page.dart';
import 'package:food_sharing/screen/login_page.dart';
import 'package:food_sharing/screen/signup_page.dart';
import 'package:food_sharing/screen/welcome.dart';
import 'package:food_sharing/theme/app_theme.dart';

void main() {
  runApp(FoodSharing());
}

class FoodSharing extends StatelessWidget {
  const FoodSharing({super.key});
  static const appTitle = 'salo';
  static const appSubtitle = ['meals from iskolars', 'for iskolars'];
  static const userID = "123456";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(),
      initialRoute: "/",
      routes:{
        '/': (context) => const LandingPage(title: appTitle, subtitle: appSubtitle),
        "/login": (context) => LoginPage(title: appTitle),
        "/signup": (context) => SignupPage(title: appTitle),
        "/welcome": (context) => WelcomeScreen(),
        "/app_frame": (context) => AppFrame(),
      },

    );
  }
}
