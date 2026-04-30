import 'package:flutter/material.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/profile.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  ProfilePage({super.key, required this.title});

  @override 
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return(
      CenteredColumn(children:[
        ProfilePicture(userID: 123456,),


      ])
    );
  }

}