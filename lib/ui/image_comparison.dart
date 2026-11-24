import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'app_theme.dart';
import '../ui/icon_tile.dart';

class ImageComparison extends StatelessWidget {
  const ImageComparison({
    required this.wide,
    required this.original,
    required this.overlay,
    super.key,
  });

  final bool wide;
  final Uint8List original;
  final Uint8List overlay;

  @override
  Widget build(BuildContext context) {
    final panels = [
      _ImagePanel(
        title: 'Original image',
        icon: Icons.image_outlined,
        bytes: original,
      ),
      _ImagePanel(
        title: 'Predicted overlay',
        icon: Icons.layers_outlined,
        bytes: overlay,
      ),
    ];

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: panels.map((panel) => Expanded(child: panel)).toList(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: panels,
    );
  }
}

class _ImagePanel extends StatelessWidget {
  const _ImagePanel({
    required this.title,
    required this.icon,
    required this.bytes,
  });

  final String title;
  final IconData icon;
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Row(
              spacing: 10,
              children: [
                IconTile(icon: icon, size: 32),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: ColoredBox(
                  color: const Color(0xFF080D14),
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.contain,
                    semanticLabel: title,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
