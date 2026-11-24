import 'package:flutter/material.dart';

import 'app_theme.dart';

class IconTile extends StatelessWidget {
  const IconTile({required this.icon, required this.size, super.key});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.mint.withValues(alpha: 0.10),
        border: Border.all(color: AppColors.mint.withValues(alpha: 0.20)),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, size: size * 0.52, color: AppColors.mint),
    );
  }
}
