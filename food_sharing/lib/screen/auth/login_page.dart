import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import "package:provider/provider.dart";

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({super.key, required this.title});

  @override 
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  final _loginFormKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String? _firebaseErrorCode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    body: FullHeightColumn(children: [
      const SizedBox(height: 40),
      Image.asset(
        'assets/salologo1.png',
        height: 100,
      ),

    Form( key:_loginFormKey, 
          child:              
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
              controller: _emailController,
              cursorColor: BrandColors.darkGreen,
              decoration: TextStyleTheme.textInput(label: "Email", prefixIcon: const Icon(Icons.mail_outline)),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter an email';
                if (!EmailValidator.validate(value)) return 'Please enter a valid email address'; // Simple email validation
                if(_firebaseErrorCode == 'too-many-requests') return 'Too many requests. Please try again later';
                if(_firebaseErrorCode != null) return 'Wrong email or password';

                return null;
              }
            )),
            Padding(
              padding: TextStyleTheme.insets,
              child:
              TextFormField(
              controller: _passwordController,
              cursorColor: BrandColors.darkGreen,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: TextStyleTheme.textInput(label: "Password"),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter a password';
                return null;
              }
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
      ))),
      const SizedBox(height: 20), 
    ]),
  );
}

  void submit() async{
      if (_loginFormKey.currentState!.validate()) {

      final authProvider = context.read<AppAuthProvider>();
      String? code = await authProvider.signIn(_emailController.text, _passwordController.text);

        if (code != null){                      
          
          setState(() {
              _firebaseErrorCode = code;
          });    // If there is error code, set error code and validate again

          _loginFormKey.currentState!.validate();                      
          return;

        }

      }

  }

}