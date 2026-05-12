import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/provider/auth_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import "package:provider/provider.dart";

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

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
  String? _usernameError;

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


  //for selfie verification:
  File? _verificationSelfie;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takeSelfie() async{
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front
    );

    if(photo != null){
      setState(() {
        _verificationSelfie = File(photo.path);
      });
    }
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
                        const SizedBox(height: 15),

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
                            ).copyWith(errorText: _usernameError),
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

                        const SizedBox(height: 15),

                        _buildVerificationButton(),

                        const SizedBox(height: 15),

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
              color: Colors.black.withValues(alpha: 0.4),
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

    if (_verificationSelfie == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please take a verification selfie to proceed.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
      _usernameError = null;
    });

    final authProvider = context.read<AppAuthProvider>();
    final usersProvider = context.read<UsersProvider>();

    bool isTaken = await usersProvider.isUsernameTaken(_userNameController.text);

    if (isTaken) {
      setState(() {
        _usernameError = "Username already taken";
        _isLoading = false;
      });
      return;
    }

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
  }



  Widget _buildVerificationButton(){
    return Padding(
      padding: TextStyleTheme.insets,
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _takeSelfie, 
            icon: const Icon(Icons.camera_alt),
            label: const Text("Verify Identity"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _verificationSelfie == null? BrandColors.mediumGreen : Colors.green[800],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10))
            ),
          ),
          if(_verificationSelfie != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 5),
                  Text("Selfie Captured", style: TextStyleTheme.body.copyWith(color: Colors.green))
                ]
              ),
            )
        ],
      ),
    );
  }


  
}