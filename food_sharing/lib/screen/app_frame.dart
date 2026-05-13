import 'package:flutter/material.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/pantry_page.dart'; // <--- Add this import
import 'package:food_sharing/screen/profile_page.dart';
import 'package:food_sharing/screen/search_page.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => AppFrameState();
}

class AppFrameState extends State<AppFrame> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UsersProvider>(); // Use watch to react to changes
    final user = userProvider.currentUser;

    // List of widgets for each tab
    final List<Widget> _pages = [
      const PantryPage(), // Swapped "Home" text for your actual page
      const SearchPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          // Logic for icon color based on selection
          color: _selectedIndex == 0 ? BrandColors.black : BrandColors.white,
          onPressed: () {
            // Navigate to the add post page when the plus is tapped
            Navigator.pushNamed(context, '/add_post');
          },
        ),
        title: Text(
          _selectedIndex != 2 ? "Salo" : user?.userName ?? "User",
          style: _selectedIndex == 1 
              ? TextStyleTheme.heading_white 
              : _selectedIndex == 2 
                  ? TextStyleTheme.heading_white_md 
                  : TextStyleTheme.heading,
        ),
        centerTitle: true,
        backgroundColor: _selectedIndex == 0 
            ? BrandColors.cream 
            : BrandColors.mediumGreen,
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: BrandColors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}