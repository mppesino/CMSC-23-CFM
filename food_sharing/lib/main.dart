import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_sharing/screen/subpages/post_detail.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Providers
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/transactions_provider.dart';

// Screens
import 'package:food_sharing/auth_gate.dart';
import 'package:food_sharing/screen/app_frame.dart';
import 'package:food_sharing/screen/pantry_page.dart'; // <-- Ensure this exists
import 'package:food_sharing/screen/subpages/add_post.dart'; // <-- Ensure this exists
import 'package:food_sharing/screen/auth/login_page.dart';
import 'package:food_sharing/screen/auth/signup_page.dart';
import 'package:food_sharing/screen/auth/welcome.dart';
import 'package:food_sharing/screen/search_page.dart';
import 'package:food_sharing/screen/subpages/edit_user_profile.dart';
import 'package:food_sharing/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => PostsProvider()),

        ChangeNotifierProxyProvider<AppAuthProvider, UsersProvider>(
          create: (_) => UsersProvider(),
          update: (_, authProvider, usersProvider) {
            final uid = authProvider.user?.uid;
            if (uid != null && usersProvider!.currentUser?.userId != uid) {
              usersProvider.loadUser(uid);
            }
            return usersProvider!;
          },
        ),
        ChangeNotifierProvider(create: (_) => TransactionsProvider()),
      ],
      child: const FoodSharing(),
    ),
  );
}

class FoodSharing extends StatelessWidget {
  const FoodSharing({super.key});
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
        
        // Navigation Routes
        "/app_frame": (context) => const AppFrame(),
        "/pantry_page": (context) => const PantryPage(), 
        "/add_post": (context) => const AddPostPage(),

        "/search": (context) => const SearchPage(),
        "/edit-profile": (context) => const EditUserPage(),
      },
    );
  }
}