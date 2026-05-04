// this file is for the welcome page after clicking log in

import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // tracks the tag the user selected
  final Set<String> selectedTags = {};

  // dietary restriction options
  static const dietaryTags = [
    'Vegan', 'Vegetarian', 'Halal', 'Pescetarian', 'Gluten-Free', 'Dairy-Free',
  ];

  // food category options
  static const categoryTags = [
    'Canned / Packaged', 'Raw Ingredients', 'Grains',
    'Proteins & Dairy', 'Beverage', 'Snacks',
  ];

  // if user taps a selected tag, it will deselect
  // if user taps a tag that is not selected, it will select
  void _toggleTag(String tag) {
    setState(() {
      selectedTags.contains(tag)
          ? selectedTags.remove(tag)
          : selectedTags.add(tag);
    });
  }

  // switch screen after pressing continue
  void _onContinue() {
    // TODO: save _selectedTags to user profile before navigating
    Navigator.pushReplacementNamed(context, '/app_frame');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background color
      backgroundColor: const Color.fromRGBO(245, 240, 232, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              // app logo
              Image.asset(
                'assets/salologo.png',
                height: 80,
              ),

              const SizedBox(height: 20),

              // white container for the texts
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // welcome heading
                    const Text(
                      'WELCOME!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(191, 57, 57, 1),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // welcome texts
                    const Text(
                      'Thank you for being part of our SALO community!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(44, 44, 42, 1),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Let's set up your plate.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(44, 44, 42, 1),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Select your tags so we can 'enlist' the right food items for you!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(44, 44, 42, 1),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // DIETARY RESTRICTIONS ---------------------------------------------------------------------
                    const Text(
                      'Dietary Restrictions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(44, 44, 42, 1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // wrap automatically moves chips to the next line when they overflow
                    Wrap(
                      spacing: 8,   // horizontal gap between chips
                      runSpacing: 8, // vertical gap between rows
                      children: dietaryTags
                          .map((tag) => _SelectableChip(
                                label: tag,
                                // chip is selected if tag is in the set
                                selected: selectedTags.contains(tag),
                                onTap: () => _toggleTag(tag),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // FOOD CATEGORIES ---------------------------------------------------------------------
                    const Text(
                      'Food Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(44, 44, 42, 1),
                      ),
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

              // continue button — disabled until user picks at least one tag
              ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(245, 196, 117, 1),
                  foregroundColor: const Color.fromARGB(255, 149, 91, 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                  elevation: 0,
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// constructor
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
      // adds transition when tapped
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          // green when selected, transparent when not
          color: selected
              ? const Color.fromRGBO(59, 109, 17, 1)
              : const Color.fromRGBO(0, 0, 0, 0),
          border: Border.all(
            // changes border when selected and not selected
            color: selected
                ? const Color.fromRGBO(59, 109, 17, 1)
                : const Color.fromRGBO(59, 109, 17, 1),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            // text colors
            color: selected
                ? const Color.fromRGBO(255, 255, 255, 1)
                : const Color.fromRGBO(59, 109, 17, 1),
          ),
        ),
      ),
    );
  }
}