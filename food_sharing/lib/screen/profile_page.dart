import 'package:flutter/material.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/theme/app_theme.dart';

class ProfilePage extends StatefulWidget {

  final String userID;

  ProfilePage({super.key, required this.userID});

  @override 
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(body:
        CenteredColumn(mainAxisAlignment: MainAxisAlignment.start, children:[
        
          SectionCard(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Column(
                children: [
                    ProfilePicture(userID: widget.userID,),
                    Text("@kiemu", style: TextStyleTheme.body,)
                ],
              ),
              Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("This is my bio!", style: TextStyleTheme.body),
                  Text("Dietary Restrictions", style: TextStyleTheme.body),
                  Text("Preferences", style: TextStyleTheme.body),

                ],
              ),

            ],)
          ])

      ])

      )
    );
  }

}