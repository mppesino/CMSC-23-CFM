import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/theme/app_theme.dart';


// SectionCard
// Displays contents as a column in a card (with margins)
class SectionCard extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  const SectionCard({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: BrandColors.cream,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Allows card to be used inside AutoSizedColumn
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}