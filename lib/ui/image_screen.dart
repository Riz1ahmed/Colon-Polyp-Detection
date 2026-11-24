import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../segmentation.dart';
import 'empty_panel.dart';
import '../ui/icon_tile.dart';
import 'image_comparison.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final _picker = ImagePicker();
  ({String name, Uint8List original, Uint8List overlay})? _result;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _loadImage(() async {
        final response = await _picker.retrieveLostData();
        if (response.exception case final exception?) throw exception;
        return response.files?.firstOrNull;
      });
    }
  }

  Future<void> _loadImage(Future<XFile?> Function() pick) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final file = await pick();
      if (file == null || !mounted) return;

      final original = await file.readAsBytes();
      final overlay = await segmentImage(original);
      if (!mounted) return;
      setState(() {
        _result = (name: file.name, original: original, overlay: overlay);
      });
    } on FormatException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (error, stack) {
      debugPrint('Could not process image: $error\n$stack');
      if (mounted) setState(() => _error = 'Could not process this image.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = _result;
    final button = FilledButton.icon(
      onPressed: _busy
          ? null
          : () => _loadImage(
              () => _picker.pickImage(source: ImageSource.gallery),
            ),
      icon: const Icon(Icons.add_photo_alternate_outlined, size: 20),
      label: Text(result == null ? 'Choose image' : 'Choose another image'),
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 720;
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 44 : 20,
                    vertical: wide ? 38 : 28,
                  ),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 14,
                      children: [
                        const IconTile(icon: Icons.biotech_outlined, size: 44),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                'Polyp Segmentation',
                                style: theme.textTheme.headlineMedium,
                              ),
                              Text(
                                'Identify and visualize predicted polyp regions.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_busy) ...[
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          'Processing image…',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(
                        minHeight: 3,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        semanticsLabel: 'Processing image',
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (_error case final error?) ...[
                      Semantics(
                        liveRegion: true,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text(
                              error,
                              style: TextStyle(
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (result == null)
                      EmptyPanel(button: button)
                    else ...[
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                'Analysis result',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                result.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          button,
                        ],
                      ),
                      const SizedBox(height: 16),
                      ImageComparison(
                        wide: wide,
                        original: result.original,
                        overlay: result.overlay,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
