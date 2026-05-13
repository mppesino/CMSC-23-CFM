// --------------- IMPORTS ---------------
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_sharing/models/post.dart';
import 'package:food_sharing/provider/posts_provider.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:food_sharing/theme/app_theme.dart';
import 'package:food_sharing/screen/component/buttons.dart';
import 'package:food_sharing/utils.dart';
import 'package:image_picker/image_picker.dart';
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
  final _titleController = TextEditingController();
  final _captionController = TextEditingController();
  DateTime? _expiration;
  final List<String> _selectedTags = [];
  bool _isLoading = false;
  String? foodPicture;

  @override
  void dispose() {
    _titleController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  // --------------- IMAGE FOR POST ---------------
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (image == null) return;
    final compressedBytes = await compressImage(image);
    final encoded = base64Encode(compressedBytes);

    setState(() {
      foodPicture = encoded;
    });

    setState(() {
      _isLoading = false;
    });

  }

  Future<void> _pickExpiration() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: BrandColors.green),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _expiration = picked;
      });
    }
  }


  // --------------- POST ---------------
  Future<void> _submit() async {


    // VALIDATION 2 ---------------
    // add a desc for the item ---------------
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a title.')),
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

    // create post object ---------------
    final post = Post(
      userId: uid, // poster
      title: _titleController.text.trim(), 
      description: _captionController.text.trim(), // DESCRIPTION
      status: PostStatus.available, // default status
      tags: _selectedTags, // dietary tags
      expiration: _expiration!, // expiration date
      foodPicture: foodPicture, // image
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
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  // --------------- UI ---------------
  @override
  Widget build(BuildContext context) {

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

                      child: foodPicture != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox.expand(
                                child: Image.memory(
                                  base64Decode(foodPicture!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                            :  Column(
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
                    controller: _titleController,
                    maxLines: 1,
                    
                    decoration: InputDecoration(
                      hintText: 'e.g. 3 extra Eggs...',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      label: Text("Title"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),


                  // DESCRIPTION ---------------
                  TextField(
                    controller: _captionController,
                    maxLines: 3,

                    decoration: InputDecoration(
                      hintText: 'Describe the item',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      label: Text("Caption"),
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
                      final selected = _selectedTags.contains(tag);

                      return SelectableChip(
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
                      final selected = _selectedTags.contains(category);

                      return SelectableChip(
                        label: category,
                        selected: selected,
                        onTap: () => _toggleTag(category),
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
