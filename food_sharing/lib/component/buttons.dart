import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/theme/app_theme.dart';


class MainButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String style; // "red" or "gray"

  const MainButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.style = "red",
  });

  @override
  Widget build(BuildContext context) {
    final bool isRed = style == "red";
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isRed ? BrandColors.red : BrandColors.gray,
        foregroundColor: isRed ? BrandColors.white : BrandColors.black,
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

