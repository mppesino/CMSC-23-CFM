import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_sharing/component/components.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

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
        body: AppComponents.centeredColumn(children: [
              FaIcon(
                FontAwesomeIcons.bowlFood,      
                color: BrandColors.darkGreen, 
                size: 100.0,                    
              ), 
              Text(
                title,
                style: TextStyleTheme.title,
                textAlign: TextAlign.center
              ),
              Text(subtitle[0],
                  style: TextStyleTheme.subtitle
                  ),
              Text(subtitle[1],
                  style: TextStyleTheme.subtitle
                  ),

              Padding(padding: EdgeInsets.only(top:120), child: Column(children: [
                Padding(padding: const EdgeInsets.all(6), child:AppComponents.mainButton(() {Navigator.pushNamed(context, '/login');}, "Login", "red")),
                Padding(padding: const EdgeInsets.all(6), child:AppComponents.mainButton(() {Navigator.pushNamed(context, '/signup');}, "Sign Up", "gray")),

              ],))
        ])
        
      );

  }
}