import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_sharing/component/components.dart';
import 'package:food_sharing/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  final String title;
  LoginPage({super.key, required this.title});

  @override 
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: AppComponents.autoSizedColumn(children: [
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
        child: AppComponents.sectionCard(
          context: context,
          children: [
            const SizedBox(height: 20),
            Text(
              "Namiss ka namin!",
              style: TextStyleTheme.heading,
              textAlign: TextAlign.center,
            ),
            Text(
              "Hungry for more?",
              style: TextStyleTheme.subtitle,
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
              child: AppComponents.mainButton(() => print("Login"), "Login", "red"),
            ),
            Padding(
              padding: TextStyleTheme.insets,
              child: AppComponents.mainButton(() => Navigator.pop(context), "Back", "gray"),
            ),
          ],
        ),
      )),
      const SizedBox(height: 20), 
    ]),
  );
}
}