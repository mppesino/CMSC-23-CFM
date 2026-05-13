import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/theme/app_theme.dart';

// PrimaryButton
// For primary control buttons of the app
// For example: Log-in, Sign-up Button
class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;      // Changed to optional
  final IconData? icon;    // Added icon data
  final String style; 
  final Size size;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    this.text,
    this.icon,
    this.size = const Size(200, 50),
    this.style = "gray",
  });

  @override
  Widget build(BuildContext context) {
    final bool isRed = style == "red";
    final bool isYellow = style == "yellow";
    final bool isGreen = style == "green";

    Widget buttonContent;

    if (icon != null && text != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 25),
          const SizedBox(width: 8),
          Text(text!, style: TextStyleTheme.button),
        ],
      );
    } else if (icon != null) {
      buttonContent = Icon(icon);
    } else {
      buttonContent = Text(text ?? "", style: TextStyleTheme.button);
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isRed ? BrandColors.red : isYellow ? BrandColors.yellow : isGreen ? BrandColors.green : BrandColors.gray,
        foregroundColor: isRed ? BrandColors.white : isYellow ? BrandColors.darkYellow : isGreen ? BrandColors.white : BrandColors.black,
        elevation: 0,
        minimumSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: buttonContent,
    );
  }
}

class SelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SelectableChip({
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
