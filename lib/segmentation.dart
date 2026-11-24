import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:flutter_litert/flutter_litert.dart';
import 'package:image/image.dart' as img;

const _size = 256;
const _threshold = 0.5;

Future<Uint8List> segmentImage(Uint8List imageBytes) async {
  final model = await rootBundle.load('assets/lightweight_unet.tflite');
  return Isolate.run(() => _segment(imageBytes, Uint8List.sublistView(model)));
}

Uint8List _segment(Uint8List imageBytes, Uint8List modelBytes) {
  final decoded = img.decodeImage(imageBytes);
  if (decoded == null) {
    throw const FormatException('Choose a readable JPEG or PNG image.');
  }

  final original = img.bakeOrientation(decoded).convert(numChannels: 3);
  final resized = img.copyResize(
    original,
    width: _size,
    height: _size,
    interpolation: img.Interpolation.linear,
  );
  final input = [
    List.generate(_size, (y) {
      return List.generate(_size, (x) {
        final pixel = resized.getPixel(x, y);
        return [pixel.r / 255, pixel.g / 255, pixel.b / 255];
      });
    }),
  ];
  final output = [
    List.generate(_size, (_) => List.generate(_size, (_) => [0.0])),
  ];

  final interpreter = Interpreter.fromBuffer(modelBytes);
  try {
    interpreter.run(input, output);
  } finally {
    interpreter.close();
  }

  final overlay = img.Image(width: _size, height: _size);
  for (var y = 0; y < _size; y++) {
    for (var x = 0; x < _size; x++) {
      final pixel = resized.getPixel(x, y);
      final alpha = output[0][y][x][0] >= _threshold ? 0.45 : 0.0;
      overlay.setPixelRgb(
        x,
        y,
        (pixel.r * (1 - alpha)).round(),
        (pixel.g * (1 - alpha) + 255 * alpha).round(),
        (pixel.b * (1 - alpha)).round(),
      );
    }
  }

  // Undo the model's square resize for display without enlarging the PNG.
  final longestSide = original.width > original.height
      ? original.width
      : original.height;
  final width = (original.width * 640 / longestSide).round().clamp(1, 640);
  final height = (original.height * 640 / longestSide).round().clamp(1, 640);
  return img.encodePng(img.copyResize(overlay, width: width, height: height));
}
