import 'package:flutter/material.dart';
import 'package:food_sharing/component/buttons.dart';
import 'package:food_sharing/component/layouts.dart';
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

  static const dietaryTags = [
    'Vegan', 'Vegetarian', 'Halal', 'Pescetarian', 'Gluten-Free', 'Dairy-Free',
  ];

  static const categoryTags = [
    'Canned / Packaged',
    'Raw Ingredients',
    'Grains',
    'Proteins & Dairy',
    'Beverage',
    'Snacks',
  ];

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
                      'Thank you for being part of our SALO community!',
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
                      children: dietaryTags
                          .map((tag) => _SelectableChip(
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
                      children: categoryTags
                          .map((tag) => _SelectableChip(
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

// CHIP
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color.fromRGBO(59, 109, 17, 1)
              : Colors.transparent,
          border: Border.all(color: const Color.fromRGBO(59, 109, 17, 1)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected
                ? Colors.white
                : const Color.fromRGBO(59, 109, 17, 1),
          ),
        ),
      ),
    );
  }
}