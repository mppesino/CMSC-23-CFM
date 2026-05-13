import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
import 'package:food_sharing/utils.dart';
import 'package:food_sharing/provider/users_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  final String title;
  final List<String> subtitle;

  const WelcomeScreen({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final Set<String> selectedTags = {};



  void _toggleTag(String tag) {
    setState(() {
      selectedTags.contains(tag)
          ? selectedTags.remove(tag)
          : selectedTags.add(tag);
    });
  }

  void _onContinue() async {
    final userProvider = context.read<UsersProvider>();
    final user = userProvider.currentUser;

    if (user == null || selectedTags.isEmpty) return;

    await userProvider.editUser(user.userId!, {
      'tags': selectedTags.toList(),
      'isOnboarded': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 240, 232, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // HEADER (always top)
              SaloHeader(
                title: widget.title,
                subtitle: widget.subtitle,
              ),

              const SizedBox(height: 20),

              // CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WELCOME!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(191, 57, 57, 1),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Thank you for being part of our SALO community! Please choose your dietary preferences.',
                    ),

                    const SizedBox(height: 20),

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
                                selected: selectedTags.contains(tag),
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
                                selected: selectedTags.contains(tag),
                                onTap: () => _toggleTag(tag),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                onPressed: _onContinue,
                text: "Continue",
                style: "yellow",
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

