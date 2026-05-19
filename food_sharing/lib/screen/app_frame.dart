// APP_FRAME.DART

// IMPORTS ---------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/drawer.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/pantry_page.dart';  
import 'package:food_sharing/screen/profile_page.dart';
import 'package:food_sharing/screen/search_page.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';
// ---------------------------------------------------------------------------------------

// DYNAMIC SCREEN ---------------------------------------------------------------------------------------
class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => AppFrameState();
}
// ---------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------
class AppFrameState extends State<AppFrame> {
  // starts at the pantry page
  int _selectedIndex = 0;
  
  // instruction to change screen and refresh page
  void setTab(int index) {
    setState(() {
      _selectedIndex = index;
  });}

  //trigger the location tracker immediately upon opening app:
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {updateUserLocation(context);});
  }



  @override
  Widget build(BuildContext context) {
    // fetches the info of the current user to show on profile page
    final userProvider = context.watch<UsersProvider>(); 
    final user = userProvider.currentUser;

    // list of screens
    final List<Widget> pages = [
      const PantryPage(), // 0
      const SearchPage(), // 1
      ProfilePage(user:user!, showAppBar: false,), // 2
    ];

    return Scaffold(
      // drawer, only shows if on page 2 (profile)
      endDrawer: _selectedIndex == 2 ? AppDrawer() : null,
      // changes color of ui depending on the screen
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: _selectedIndex == 0 ? BrandColors.black : Colors.white,
        ),
        // icon for adding a post
        leading: IconButton(
          icon: const Icon(Icons.add),
          color: _selectedIndex == 0 ? BrandColors.black : BrandColors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/add_post');
          },
        ),
        // changes the title design per screen
        title: Text(
          _selectedIndex != 2 ? "Salo" : user.userName,
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

      // displays the specific page chosen
      body: pages[_selectedIndex],

      // nav bar
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
// ---------------------------------------------------------------------------------------