import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({super.key, required this.title});

  @override 
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: FullHeightColumn(children: [
      const SizedBox(height: 40),
      Image.asset(
        'assets/salologo1.png',
        height: 100,
      ),

      Expanded(
          child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SectionCard(
          children: [
            const SizedBox(height: 20),
            Text(
              "Namiss ka namin!",
              style: TextStyleTheme.heading,
              textAlign: TextAlign.center,
            ),
            Text(
              "Hungry for more?",
              style: TextStyleTheme.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            Padding(
              padding: TextStyleTheme.insets,
              child:
              TextFormField(
              cursorColor: BrandColors.darkGreen,
              decoration: TextStyleTheme.textInput(label: "Email / Username", prefixIcon: const Icon(Icons.mail_outline))
            )),
            Padding(
              padding: TextStyleTheme.insets,
              child:
              TextFormField(
              cursorColor: BrandColors.darkGreen,
              obscureText: true,
              decoration: TextStyleTheme.textInput(label: "Password")
            )),
            
            const SizedBox(height: 125), 
        
            Padding(
              padding: TextStyleTheme.insets,
              child: PrimaryButton(onPressed: () => Navigator.pushNamed(context, '/welcome'), text:  "Login", style: "red"),
            ),
            Padding(
              padding: TextStyleTheme.insets,
              child: PrimaryButton(onPressed:() => Navigator.pop(context),text: "Back", style: "gray"),
            ),
          ],
        ),
      )),
      const SizedBox(height: 20), 
    ]),
  );
}
}