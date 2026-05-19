// MAIN.DART

// IMPORTS ---------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_sharing/screen/subpages/settings.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/auth_gate.dart';
import 'package:food_sharing/screen/app_frame.dart';
import 'package:food_sharing/screen/pantry_page.dart';
import 'package:food_sharing/screen/subpages/add_post.dart';
import 'package:food_sharing/screen/auth/login_page.dart';
import 'package:food_sharing/screen/auth/signup_page.dart';
import 'package:food_sharing/screen/auth/welcome.dart';
import 'package:food_sharing/screen/search_page.dart';
import 'package:food_sharing/screen/subpages/edit_user_profile.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/notifications.dart';
// ---------------------------------------------------------------------------------------

// MAIN FUNCTION ---------------------------------------------------------------------------------------
Future<void> main() async {
  // ensures that the flutter framework is ready before calling the firebase
  WidgetsFlutterBinding.ensureInitialized();
  // initializes backend (firebase)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // push notification configuration
  await Notifications.init();
  
  runApp(
    // accessible by any page
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => PostsProvider()),

        // ensures everything automatically updates
        ChangeNotifierProxyProvider<AppAuthProvider, UsersProvider>(
          create: (_) => UsersProvider(),
          update: (_, authProvider, usersProvider) {
            final uid = authProvider.user?.uid;
            // if uid exists, fetch their profile data from the database
            if (uid != null && usersProvider!.currentUser?.userId != uid) {
              usersProvider.loadUser(uid);
            }
            return usersProvider!;
          },
        ),
      ],
      child: FoodSharing(),
    ),
  );
}
// ---------------------------------------------------------------------------------------

// ROUTING ---------------------------------------------------------------------------------------
class FoodSharing extends StatelessWidget {
  FoodSharing({super.key});
  static const appTitle = 'salo';
  static const appSubtitle = ['meals from iskolars', 'for iskolars'];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: "/",
      routes: {
        '/': (context) => const AuthGate(title: appTitle, subtitle: appSubtitle),
        "/login": (context) => const LoginPage(title: appTitle, subtitle: appSubtitle),
        "/signup": (context) => const SignupPage(title: appTitle, subtitle: appSubtitle),
        "/welcome": (context) => const WelcomeScreen(title: appTitle, subtitle: appSubtitle),
        
        "/app_frame": (context) => AppFrame(),
        "/pantry_page": (context) => const PantryPage(), 
        "/add_post": (context) => const AddPostPage(),
        "/settings": (context) => const SettingsPage(),

        "/search": (context) => const SearchPage(),
        "/edit-profile": (context) => const EditUserPage(),
      },
    );
  }
}
// ---------------------------------------------------------------------------------------