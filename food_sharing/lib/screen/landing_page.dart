import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
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
              Image.asset(
                'assets/salologo.png',
                height: 280,
              ),
              Padding(padding: EdgeInsets.only(top:30), child: Column(children: [
                Padding(padding: const EdgeInsets.all(6), child:PrimaryButton(onPressed: () {Navigator.pushNamed(context, '/login');}, text: "Login", style:  "red")),
                Padding(padding: const EdgeInsets.all(6), child:PrimaryButton(onPressed:() {Navigator.pushNamed(context, '/signup');}, text: "Sign Up", style: "gray")),

              ],))
        ])
        
      )
      );

  }
}