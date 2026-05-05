import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/theme/app_theme.dart';

// PrimaryButton
// For primary control buttons of the app
// For example: Log-in, Sign-up Button
class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String style; // "red" or "gray"

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style = "red",
  });

  @override
  Widget build(BuildContext context) {
    final bool isRed = style == "red";
    final bool isYellow = style == "yellow";

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isRed ? BrandColors.red : isYellow ? BrandColors.yellow : BrandColors.gray,
        foregroundColor: isRed ? BrandColors.white : isYellow ? BrandColors.darkYellow : BrandColors.black,
        elevation: 0,
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text, style: TextStyleTheme.button),
    );
  }
}

