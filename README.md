# Polyp Segmentation

A Flutter research prototype using the MSc project's exported MobileNetV2 U-Net.
Choose a JPEG or PNG to see the original and a green overlay of the predicted
polyp region. The app runs inference on the device.

## Run on macOS or Android

From this folder, with Flutter and the platform build tools installed:

```sh
flutter pub get
flutter run -d macos
```

For Android, connect the phone with USB debugging enabled, then run:

```sh
flutter devices
flutter run -d <android-device-id>
```

The Android target requires API 24 or newer. To generate an installable build,
run `flutter build apk`. The first dependency and native runtime downloads
require internet access.

The project also includes an iOS target. Set the signing team in Xcode and
test on an iPhone before distributing an iOS build.

## Code

- `lib/main.dart` contains the image picker and responsive results screen.
- `lib/segmentation.dart` runs the bundled TFLite model on a worker isolate.
- `assets/lightweight_unet.tflite` is the project's exported model.

The model input is 256 × 256 RGB scaled to [0, 1]. The green overlay is drawn
where the predicted probability is at least 0.5. Dart uses bilinear resizing.
Compare the Dart and Python predictions on the same test images before
reporting app-level numerical parity.
