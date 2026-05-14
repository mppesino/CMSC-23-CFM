import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/screen/component/buttons.dart';
import 'package:food_sharing/screen/component/layouts.dart';
import 'package:food_sharing/screen/component/sections.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import "package:provider/provider.dart";

class LoginPage extends StatefulWidget {
  final String title;
  final List<String> subtitle;
  const LoginPage({super.key, required this.title, required this.subtitle});

  @override 
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  bool _isLoading = false;

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
      body: Stack(
        children: [
          FullHeightColumn(children: [
            const SizedBox(height: 40),

            SaloHeader(title: widget.title, subtitle: widget.subtitle),

            Expanded(
              child: Form(
                key: _loginFormKey,
                child: Padding(
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
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: BrandColors.green,
                          decoration: TextStyleTheme.textInput(
                            label: "Email",
                            prefixIcon: const Icon(Icons.mail_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email address';
                            }
                            if (_firebaseErrorCode == 'too-many-requests') {
                              return 'Too many requests. Please try again later';
                            }
                            if (_firebaseErrorCode != null) {
                              return 'Wrong email or password';
                            }
                            return null;
                          },
                        ),
                      ),

                      Padding(
                        padding: TextStyleTheme.insets,
                        child: TextFormField(
                          controller: _passwordController,
                          cursorColor: BrandColors.darkGreen,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: TextStyleTheme.textInput(label: "Password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 125),

                      Padding(
                        padding: TextStyleTheme.insets,
                        child: PrimaryButton(
                          onPressed: submit,
                          text: "Login",
                          style: "red",
                        ),
                      ),

                      Padding(
                        padding: TextStyleTheme.insets,
                        child: PrimaryButton(
                          onPressed: () => Navigator.pop(context),
                          text: "Back",
                          style: "gray",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ]),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: BrandColors.green,),
              ),
            ),
        ],
      ),
    );
  }

  void submit() async {

    setState(() {
        _firebaseErrorCode = null;
    });

    if (!_loginFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AppAuthProvider>();
    String? code = await authProvider.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (code != null) {
      setState(() {
        _firebaseErrorCode = code;
      });

      _loginFormKey.currentState!.validate();
      return;
    }

    Navigator.pop(context);
  }
}