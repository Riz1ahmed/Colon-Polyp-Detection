import 'package:flutter/material.dart';
import 'package:polyp_segmentation/ui/image_screen.dart';
import 'ui/app_theme.dart';

void main() => runApp(MaterialApp(
  title: 'Polyp Segmentation',
  debugShowCheckedModeBanner: false,
  theme: AppTheme.dark,
  home: const ImageScreen(),
));