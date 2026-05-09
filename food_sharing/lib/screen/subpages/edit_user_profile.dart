import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/component/profile.dart';
import 'package:food_sharing/component/sections.dart';
import 'package:food_sharing/constants.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/screen/auth/welcome.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/models/user.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => EditUserPageState();
}

class EditUserPageState extends State<EditUserPage> {
  bool _isLoading = false;

  final _editUserFormKey = GlobalKey<FormState>();

  late TextEditingController _fnameController;
  late TextEditingController _lnameController;
  late TextEditingController _userNameController;
  late TextEditingController _bioController;

  String? _usernameError;

  final Set<String> selectedTags = {};

  @override
  void initState() {
    super.initState();

    final user = context.read<UsersProvider>().currentUser;

    _fnameController = TextEditingController(text: user?.firstName ?? "");
    _lnameController = TextEditingController(text: user?.lastName ?? "");
    _userNameController = TextEditingController(text: user?.userName ?? "");
    _bioController = TextEditingController(text: user?.bio ?? "");

    selectedTags.addAll(user?.tags ?? []);

  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      selectedTags.contains(tag)
          ? selectedTags.remove(tag)
          : selectedTags.add(tag);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final user = context.read<UsersProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.mediumGreen,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Edit Profile",
          style: TextStyleTheme.heading_white_s,
        ),
      ),
      body: Stack(
        children: [
          FullHeightColumn(
            children: [
                SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  
                Padding(padding: EdgeInsets.all(15), child:ProfilePicture(user: user,)),

                SizedBox(
                width: 50,
                height: 50,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                      final image = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 70,
                    );

                    if (image == null) return;

                    setState(() {
                      _isLoading = true;
                    });


                    final compressedBytes = await compressImage(image);
                    final base64image = base64Encode(compressedBytes);

                    final usersProvider = context.read<UsersProvider>();

                    await usersProvider.editUser(
                      usersProvider.currentUser!.userId!,
                      {
                        'profilePicture': base64image,
                        'isVerified': true
                      },
                    );

                    setState(() {
                        _isLoading = false;
                    });
                  },

    
                ),
              ),
              ],),
    
              Expanded(
                child: Form(
                  key: _editUserFormKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: SectionCard(
                      color: Colors.white,
                      children: [
                        // FIRST + LAST NAME
                        Padding(
                          padding: TextStyleTheme.insets,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fnameController,
                                  cursorColor: BrandColors.darkGreen,
                                  decoration: TextStyleTheme.textInput(
                                    label: "First Name",
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? "Enter first name"
                                          : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _lnameController,
                                  cursorColor: BrandColors.darkGreen,
                                  decoration: TextStyleTheme.textInput(
                                    label: "Last Name",
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                          ? "Enter last name"
                                          : null,
                                ),
                              ),
                            ],
                          ),
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
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? "Enter username"
                                    : null,
                          ),
                        ),

                        // BIO
                        Padding(
                          padding: TextStyleTheme.insets,
                          child: TextFormField(
                            controller: _bioController,
                            cursorColor: BrandColors.darkGreen,
                            decoration: TextStyleTheme.textInput(
                              label: "Bio",
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        Padding(
                          padding: TextStyleTheme.insets,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Dietary Restrictions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: FoodTags.dietaryTags
                                    .map((tag) => SelectableChip(
                                          label: tag,
                                          selected:
                                              selectedTags.contains(tag),
                                          onTap: () => _toggleTag(tag),
                                        ))
                                    .toList(),
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                'Food Categories',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: FoodTags.categoryTags
                                    .map((tag) => SelectableChip(
                                          label: tag,
                                          selected:
                                              selectedTags.contains(tag),
                                          onTap: () => _toggleTag(tag),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),

                        // BUTTON
                        Padding(
                          padding: TextStyleTheme.insets,
                          child: PrimaryButton(
                            onPressed: submit,
                            text: "Confirm Edits",
                            style: "gray",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
    if (!_editUserFormKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _usernameError = null;
    });

    final usersProvider = context.read<UsersProvider>();

    bool isTaken = await usersProvider.isUsernameTaken(
      _userNameController.text,
      uid: usersProvider.currentUser?.userId ?? "",
    );

    if (isTaken) {
      setState(() {
        _usernameError = "Username already taken";
        _isLoading = false;
      });
      return;
    }

    await usersProvider.editUser(
      usersProvider.currentUser?.userId ?? "",
      {
        'firstName': _fnameController.text,
        'lastName': _lnameController.text,
        'userName': _userNameController.text,
        'bio': _bioController.text,
        'tags': selectedTags.toList(),
      },
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    Navigator.pop(context);
  }
}