import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/theme/app_theme.dart';

class SignupPage extends StatefulWidget {
  final String title;
  SignupPage({super.key, required this.title});

  @override 
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: FullHeightColumn(children: [
      const SizedBox(height: 40),
      FaIcon(
        FontAwesomeIcons.bowlFood,
        color: BrandColors.darkGreen,
        size: 100.0,
      ),
      Text(
        widget.title,
        style: TextStyleTheme.titleSmall,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),

      Expanded(
          child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SectionCard(
          children: [
            const SizedBox(height: 20),
            Text(
              "Tara, kain!",
              style: TextStyleTheme.heading,
              textAlign: TextAlign.center,
            ),
            Text(
              "Ready to see what's on the table?",
              style: TextStyleTheme.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),            
            Padding(
              padding: TextStyleTheme.insets,
              child:
              TextFormField(
              cursorColor: BrandColors.darkGreen,
              decoration: TextStyleTheme.textInput(label: "Email", prefixIcon: const Icon(Icons.mail_outline))
            )),

            Row(children: [
              Expanded(
                child: Padding(
                padding: TextStyleTheme.insets,
                child:
                TextFormField(
                cursorColor: BrandColors.darkGreen,
                decoration: TextStyleTheme.textInput(label: "First Name")
              ))),
              Expanded(
                child: Padding(
                padding: TextStyleTheme.insets,
                child:
                TextFormField(
                cursorColor: BrandColors.darkGreen,
                decoration: TextStyleTheme.textInput(label: "Last Name")
              ))),

            ],),
            

            Padding(
              padding: TextStyleTheme.insets,
              child:
              TextFormField(
              cursorColor: BrandColors.darkGreen,
              decoration: TextStyleTheme.textInput(label: "Username")
            )),

            Padding(
              padding: const EdgeInsets.all(12),
              child:
              TextFormField(
              cursorColor: BrandColors.darkGreen,
              obscureText: true,
              decoration: TextStyleTheme.textInput(label: "Password")
            )),
                        Padding(
              padding: const EdgeInsets.all(12),
              child:
              TextFormField(
              cursorColor: BrandColors.darkGreen,
              obscureText: true,
              decoration: TextStyleTheme.textInput(label: "Confirm Password")
            )),
            
            const SizedBox(height: 20), 
        
            Padding(
              padding: TextStyleTheme.insets,
              child: PrimaryButton(onPressed: () => print("Signup"), text: "Sign Up",  style: "red"),
            ),
            Padding(
              padding: TextStyleTheme.insets,
              child: PrimaryButton(onPressed: () => Navigator.pop(context), text:"Back", style: "gray"),
            ),
          ],
        ),
      )),
      const SizedBox(height: 20), 
    ]),
  );
}
}