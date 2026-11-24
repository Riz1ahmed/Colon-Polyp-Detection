import 'package:flutter/material.dart';

import 'app_theme.dart';
import '../ui/icon_tile.dart';

class EmptyPanel extends StatelessWidget {
  const EmptyPanel({required this.button, super.key});

  final Widget button;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(0, -0.7),
          radius: 1.15,
          colors: [Color(0xFF1B3238), AppColors.surface],
        ),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 46),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconTile(icon: Icons.image_search_outlined, size: 68),
            const SizedBox(height: 18),
            Text(
              'Choose a colonoscopy image',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a JPG or PNG to generate a segmentation overlay.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            button,
          ],
        ),
      ),
    );
  }
}
