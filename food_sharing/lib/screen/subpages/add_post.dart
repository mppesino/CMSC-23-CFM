// --------------- IMPORTS ---------------
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_sharing/constants.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
// ---------------  ---------------

// --------------- ADD POST PAGE ---------------
// this page is for adding a post in the pantry
class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}
// ---------------  ---------------

// --------------- STATE CLASS ---------------
class _AddPostPageState extends State<AddPostPage> {
  // controller for desc field ---------------
  final _captionController = TextEditingController();
  // stores image ---------------
  File? _imageFile;
  // stores expiration date ---------------
  DateTime? _expiration;
  // stores dietary tags ---------------
  final List<String> _selectedDietary = [];
  // stores food categories ---------------
  final List<String> _selectedCategories = [];
  // loading state ---------------
  bool _isLoading = false;

  // --------------- DISPOSE ---------------
  // removes text when screen is closed, for memory leak prevention
  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
  // ---------------  ---------------

  // --------------- IMAGE FOR POST ---------------
  Future<void> _pickImage() async {
    // creates an instance ---------------
    final picker = ImagePicker();
    // opens the device's camera ---------------
    final picked = await picker.pickImage(
      // only use the camera (can't upload) ---------------
      source: ImageSource.camera,
      // just for image quality, too high can cause lag ---------------
      imageQuality: 70,
    );
    // updates UI to display the picture ---------------
    // it saves the file and automatically triggers ascreen refresh to show it
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // --------------- DATE PICKER ---------------
  Future<void> _pickExpiration() async {
    // initializes current time ---------------
    final now = DateTime.now();

    // opens the date picker ---------------
    final picked = await showDatePicker(
      context: context,
      // default is the current date ---------------
      // cannot post already expired food ---------------
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      // can only post foods that has an expiration date of 2 years ---------------
      lastDate: now.add(const Duration(days: 730)),
      // design ---------------
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: BrandColors.green),
        ),
        child: child!,
      ),
    );

    // if date is selected, save it ---------------
    if (picked != null) {
      setState(() {
        _expiration = picked;
      });
    }
  }

  // --------------- SAVES IMAGE IN THE FIREBASE ---------------
  // not working yet!!
  // maybe the error is here but i cant find!!
  Future<String?> _uploadImage(File file, String postId) async {
    try {
      // location of the firebase ---------------
      final ref = FirebaseStorage.instance
          .ref()
          // sets folder name and uses postId as filename ---------------
          .child('post_images/$postId.jpg');

      // uploads file to firebase ---------------
      UploadTask uploadTask = ref.putFile(file);
      // waits for upload to finish ---------------
      TaskSnapshot snapshot = await uploadTask;

      // get img download url ---------------
      // image is saved in storage & the link is saved in the database
      // so everyone can view the picture
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
      // error handling ---------------
    } catch (e) {
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  // --------------- POST ---------------
  Future<void> _submit() async {
    // UNCOMMENT IF FIXED
    // VALIDATION 1 ---------------
    // add a picture from the camera ---------------
    /*
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Upload an image from your camera.',
          ),
        ),
      );
      return;
    }*/

    // VALIDATION 2 ---------------
    // add a desc for the item ---------------
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a description.')),
      );
      return;
    }

    // VALIDATION 3---------------
    // add an expiration date ---------------
    if (_expiration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set an expiration date.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // user id ---------------
    final uid = context.read<UsersProvider>().currentUser?.userId;

    // post provider ---------------
    final postsProvider = context.read<PostsProvider>();

    // temporary id ---------------
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();

    // upload the image ---------------
    // COMMENTED FOR TESTING
    /*final imageUrl =
        await _uploadImage(_imageFile!, tempId);

    // error handling for image upload ---------------
    if (imageUrl == null) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to upload image.',
          ),
        ),
      );

      return;
    }
    */
    // ------------------------------

    // THIS IS FOR TESTING ONLY, DELETE IF IMAGE IS WORKING ALREADY
    String? imageUrl;

    if (_imageFile != null) {
      imageUrl = await _uploadImage(_imageFile!, tempId);

      // upload failed ---------------
      if (imageUrl == null) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );

        return;
      }
    }
    // ---------------------------------------------------------------------------

    // create post object ---------------
    final post = Post(
      userId: uid, // poster
      title: _captionController.text.trim(), // uses the desc as a title
      description: _captionController.text.trim(), // DESCRIPTION
      status: PostStatus.available, // default status
      dietary: _selectedDietary, // dietary tags
      category: _selectedCategories, // category tags
      expiration: _expiration!, // expiration date
      imageUrl: imageUrl, // image
    );

    // save post to firestore
    await postsProvider.addPost(post, uid);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      // close page
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item posted to Pantry!')));
    }
  }

  // --------------- DIETARY TAGS TOGGLE ---------------
  void _toggleTag(String tag) {
    setState(() {
      // remove if already selected ---------------
      if (_selectedDietary.contains(tag)) {
        _selectedDietary.remove(tag);
      } else {
        // add if not selected ---------------
        _selectedDietary.add(tag);
      }
    });
  }

  // --------------- CATEGORY TAGS TOGGLE ---------------
  void _toggleCategory(String category) {
    setState(() {
      // remove if already selected ---------------
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        // add if not selected ---------------
        _selectedCategories.add(category);
      }
    });
  }

  // --------------- UI ---------------
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UsersProvider>().currentUser;

    return Scaffold(
      backgroundColor: BrandColors.cream,

      appBar: AppBar(
        backgroundColor: BrandColors.cream,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text('Post Item', style: TextStyleTheme.titleXs),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),

        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // USER INFO ---------------
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: BrandColors.gray,
                        backgroundImage: user?.profilePicture != null
                            ? NetworkImage(user!.profilePicture!)
                            : null,
                      ),

                      const SizedBox(width: 10),

                      Text(
                        '${user?.firstName ?? "User"} ${user?.lastName ?? ""}',
                        style: TextStyleTheme.body,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // CAMERA BOX ---------------
                  GestureDetector(
                    onTap: _pickImage,

                    child: Container(
                      height: 200,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: BrandColors.green,
                          width: 1.5,
                        ),
                      ),

                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: BrandColors.green,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Take Photo",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DESCRIPTION ---------------
                  TextField(
                    controller: _captionController,
                    maxLines: 2,

                    decoration: InputDecoration(
                      hintText: 'e.g. 3 extra Eggs from breakfast...',
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // EXPIRATION ---------------
                  GestureDetector(
                    onTap: _pickExpiration,

                    child: Row(
                      children: [
                        const Icon(Icons.event, color: BrandColors.green),

                        const SizedBox(width: 10),

                        Text(
                          _expiration != null
                              ? 'Expires: ${_expiration!.month}/${_expiration!.day}/${_expiration!.year}'
                              : 'Set Expiration Date',

                          style: TextStyle(
                            color: _expiration == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // DIETARY TAGS ---------------
                  Text('Dietary Tags', style: TextStyleTheme.subtitle_bold),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children: FoodTags.dietaryTags.map((tag) {
                      final selected = _selectedDietary.contains(tag);

                      return _SelectableChip(
                        label: tag,
                        selected: selected,
                        onTap: () => _toggleTag(tag),
                      );
                    }).toList(),
                  ),

                  // CATEGORY TAGS ---------------
                  const SizedBox(height: 20),

                  Text('Food Categories', style: TextStyleTheme.subtitle_bold),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children: FoodTags.categoryTags.map((category) {
                      final selected = _selectedCategories.contains(category);

                      return _SelectableChip(
                        label: category,
                        selected: selected,
                        onTap: () => _toggleCategory(category),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // POST BUTTON ---------------
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: BrandColors.green,
                          )
                        : PrimaryButton(
                            onPressed: _submit,
                            text: 'POST TO PANTRY',
                            style: 'yellow',
                            size: const Size(200, 50),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CHIP ---------------
class _SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

        decoration: BoxDecoration(
          color: selected ? BrandColors.green : Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: BrandColors.green),
        ),

        child: Text(
          label,

          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : BrandColors.green,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
