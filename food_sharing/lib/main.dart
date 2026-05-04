import 'package:flutter/material.dart';
import 'package:food_sharing/auth_gate.dart';
import 'package:food_sharing/screen/app_frame.dart';
import 'package:food_sharing/screen/auth/landing_page.dart';
import 'package:food_sharing/screen/auth/login_page.dart';
import 'package:food_sharing/screen/auth/signup_page.dart';
import 'package:food_sharing/screen/auth/welcome.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(

    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppAuthProvider(),
        ),
      ],
      child: const FoodSharing(),
    ),
  );
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
        '/': (context) => const AuthGate(title: appTitle, subtitle: appSubtitle),
        "/login": (context) => LoginPage(title: appTitle),
        "/signup": (context) => SignupPage(title: appTitle),
        "/welcome": (context) => WelcomeScreen(),
        "/app_frame": (context) => AppFrame(),
      },

    );

    
  }
}
