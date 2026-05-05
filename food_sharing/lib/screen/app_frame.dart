import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/provider/users_provider.dart';
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

  // These are the widgets for each tab

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UsersProvider>();
    final user = userProvider.currentUser;


    final List<Widget> _pages = [
      const Center(child: Text("Home")),    
      const SearchPage(),  
      ProfilePage(user: user), 
    ];


    return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          // Add your logic here
          print("Plus button tapped!");
        },
      ),
      title: Text(_selectedIndex != 2 ? "Salo" : user?.userName ?? "User", style: _selectedIndex != 2 ? TextStyleTheme.heading : TextStyleTheme.subtitle), // Optional: your app title
      centerTitle: true,         // Optional: keeps the title in the middle
    ),      
      body: _pages[_selectedIndex], // Shows the page based on the index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: BrandColors.green,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        showSelectedLabels: false,   // Hides the label area for the active tab
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed, // Keeps all icons visible
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label:""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label:""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label:""),
        ],
      ),
    );
  }
}