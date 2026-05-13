import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_sharing/theme/app_theme.dart';

// FullHeightColumn
// If contents of the column is short, it expands to fill the screen vertically
// If contents of the column is long, it scrolls
class FullHeightColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  const FullHeightColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ],
    );
  }
}

// CenteredColumn
// Centers contents of the column vertically and horizontally
// If contents of the column doesn't fit, it scrolls
class CenteredColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  const CenteredColumn({super.key, required this.children, this.mainAxisAlignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: mainAxisAlignment,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
        );
      },
    );
  }
}

class SaloHeader extends StatelessWidget {
  final String title;
  final List<String> subtitle;

  const SaloHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/salologo_only.png',
          height: 64
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyleTheme.titleSmall,
            ),
            Text(
              subtitle[0],
              style: TextStyleTheme.subtitle,
            ),
            Text(
              subtitle[1],
              style: TextStyleTheme.subtitle,
            ),
          ],
        ),
      ],
    );
  }
}