import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:email_validator/email_validator.dart';
import "package:provider/provider.dart";

class SignupPage extends StatefulWidget {
  final String title;
  final List<String> subtitle;

  const SignupPage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  bool _isLoading = false;

  final _signupFormKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;

  // Firebase UI errors (separate from validators)
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _fnameController = TextEditingController();
    _lnameController = TextEditingController();
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _fnameController.dispose();
    _lnameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FullHeightColumn(
            children: [
              const SizedBox(height: 40),

              SaloHeader(
                title: widget.title,
                subtitle: widget.subtitle,
              ),

              Expanded(
                child: Form(
                  key: _signupFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
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

                        // EMAIL
                        Padding(
                          padding: TextStyleTheme.insets,
                          child: TextFormField(
                            controller: _emailController,
                            cursorColor: BrandColors.darkGreen,
                            decoration: TextStyleTheme.textInput(
                              label: "Email",
                              prefixIcon: const Icon(Icons.mail_outline),
                            ).copyWith(errorText: _emailError),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ),

                        // NAME ROW
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: TextStyleTheme.insets,
                                child: TextFormField(
                                  controller: _fnameController,
                                  cursorColor: BrandColors.green,
                                  decoration: TextStyleTheme.textInput(
                                    label: "First Name",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter first name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: TextStyleTheme.insets,
                                child: TextFormField(
                                  controller: _lnameController,
                                  cursorColor: BrandColors.darkGreen,
                                  decoration: TextStyleTheme.textInput(
                                    label: "Last Name",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter last name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        // USERNAME
                        Padding(
                          padding: TextStyleTheme.insets,
                          child: TextFormField(
                            controller: _userNameController,
                            cursorColor: BrandColors.darkGreen,
                            decoration: TextStyleTheme.textInput(
                              label: "Username",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter username';
                              }
                              return null;
                            },
                          ),
                        ),

                        // PASSWORD
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextFormField(
                            controller: _passwordController,
                            cursorColor: BrandColors.darkGreen,
                            obscureText: true,
                            decoration: TextStyleTheme.textInput(
                              label: "Password",
                            ).copyWith(errorText: _passwordError),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter password';
                              }
                              if (value.length < 8) {
                                return 'Min 8 characters';
                              }
                              if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                return 'Must include a letter';
                              }
                              if (!RegExp(r'\d').hasMatch(value)) {
                                return 'Must include a number';
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                return 'Must include a special character';
                              }
                              return null;
                            },
                          ),
                        ),

                        // CONFIRM PASSWORD
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextFormField(
                            controller: _confirmController,
                            cursorColor: BrandColors.darkGreen,
                            obscureText: true,
                            decoration: TextStyleTheme.textInput(
                              label: "Confirm Password",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: TextStyleTheme.insets,
                          child: PrimaryButton(
                            onPressed: submit,
                            text: "Sign Up",
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
            ],
          ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                  color: BrandColors.mediumGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void submit() async {
    if (!_signupFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    final authProvider = context.read<AppAuthProvider>();

    final code = await authProvider.signUp(
      _fnameController.text,
      _lnameController.text,
      _userNameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (code != null) {
      setState(() {
        if (code == 'email-already-in-use') {
          _emailError = "An account already exists for this email";
        }
        if (code == 'weak-password') {
          _passwordError = "Password is too weak";
        }
      });
      return;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Account created! Please log in.")),
    );
  }
}