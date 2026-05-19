import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/drawer.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/pantry_page.dart';  
import 'package:food_sharing/screen/profile_page.dart';
import 'package:food_sharing/screen/search_page.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'package:food_sharing/utils.dart';

class AppFrame extends StatefulWidget {
  const AppFrame({super.key});

  @override
  State<AppFrame> createState() => AppFrameState();
}

class AppFrameState extends State<AppFrame> {
  int _selectedIndex = 0;
  
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
    final userProvider = context.watch<UsersProvider>(); 
    final user = userProvider.currentUser;

    // List of widgets for each tab
    final List<Widget> pages = [
      const PantryPage(), 
      const SearchPage(),
      ProfilePage(user:user!, showAppBar: false,),
    ];

    return Scaffold(
      endDrawer: _selectedIndex == 2 ? AppDrawer() : null,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: _selectedIndex == 0 ? BrandColors.black : Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.add),
          color: _selectedIndex == 0 ? BrandColors.black : BrandColors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/add_post');
          },
        ),
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
      body: pages[_selectedIndex],
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