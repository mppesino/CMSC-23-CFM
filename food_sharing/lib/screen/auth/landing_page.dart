import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/theme/app_theme.dart';
class LandingPage extends StatelessWidget {
  final String title;
  final List<String> subtitle;

  const LandingPage({
    super.key, 
    required this.title,
    required this.subtitle
  });

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body:SizedBox.expand(
        child:
         CenteredColumn(  children: [
              Column(children: [
              Image.asset(
                'assets/salologo_only.png',
                height: 160,
              ),
              Text(title, style: TextStyleTheme.title,),
              Text(subtitle[0] , style: TextStyleTheme.subtitle,),
              Text(subtitle[1], style: TextStyleTheme.subtitle,)
              ],),
              Padding(padding: EdgeInsets.only(top:30), child: Column(children: [
                Padding(padding: const EdgeInsets.all(6), child:PrimaryButton(onPressed: () {Navigator.pushNamed(context, '/login');}, text: "Login", style:  "red")),
                Padding(padding: const EdgeInsets.all(6), child:PrimaryButton(onPressed:() {Navigator.pushNamed(context, '/signup');}, text: "Sign Up", style: "gray")),

              ],))
        ])
        
      )
      );

  }
}