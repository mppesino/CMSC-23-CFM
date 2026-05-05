import 'package:flutter/material.dart';
import 'package:food_sharing/auth_gate.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/app_frame.dart';
import 'package:food_sharing/screen/auth/login_page.dart';
import 'package:food_sharing/screen/search_page.dart';
import 'package:food_sharing/screen/auth/signup_page.dart';
import 'package:food_sharing/screen/auth/welcome.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppAuthProvider(),
        ),
        ChangeNotifierProxyProvider<AppAuthProvider, UsersProvider>(
        create: (_) => UsersProvider(),
        update: (_, authProvider, usersProvider) {
          final uid = authProvider.user?.uid;

          if (uid != null) {
            if (usersProvider!.currentUser?.userId != uid) {
              usersProvider.loadUser(uid);
            }
          } else {
            usersProvider!.clearUser();
          }

          return usersProvider;
        },
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
        '/': (context) => AuthGate(title: appTitle, subtitle: appSubtitle),
        "/login": (context) => LoginPage(title: appTitle, subtitle: appSubtitle,),
        "/signup": (context) => SignupPage(title: appTitle, subtitle: appSubtitle,),
        "/welcome": (context) => WelcomeScreen(title: appTitle, subtitle: appSubtitle),
        "/app_frame": (context) => AppFrame(),
        "/search": (context) => SearchPage()
      },

    );

    
  }
}
