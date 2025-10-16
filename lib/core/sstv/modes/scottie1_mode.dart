// ignore_for_file: cascade_invocations

import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:wavica/core/sstv/modes/sstv_mode.dart';

class Scottie1Mode extends SSTVMode {
  @override
  String get name => 'Scottie 1';

  @override
  int get visCode => 60; // Scottie 1 VIS code

  @override
  int get width => 320;

  @override
  int get height => 256;

  // Scottie 1 timing constants (in milliseconds)
  static const double syncPulseDuration = 9;
  static const double syncPorchDuration = 1.5;
  static const double lineDuration = 138.240; // per color component

  static const double syncFrequency = 1200;
  static const double syncPorchFrequency = 1500;

  @override
  List<double> encode(img.Image image) {
    final samples = <double>[];

    // Resize image if needed
    img.Image resized;
    if (image.width != width || image.height != height) {
      resized = img.copyResize(image, width: width, height: height);
    } else {
      resized = image;
    }

    // Add VIS code
    samples.addAll(generateVISCode());

    // Encode each line
    for (var y = 0; y < height; y++) {
      // Sync pulse (1200 Hz for 9ms)
      samples.addAll(generateTone(syncFrequency, syncPulseDuration));

      // Sync porch (1500 Hz for 1.5ms)
      samples.addAll(generateTone(syncPorchFrequency, syncPorchDuration));

      // Scottie order: Green, Blue, Red (unlike Martin which is GBR)
      // Green line
      samples.addAll(_encodeLine(resized, y, 'green'));

      // Blue line
      samples.addAll(_encodeLine(resized, y, 'blue'));

      // Red line
      samples.addAll(_encodeLine(resized, y, 'red'));
    }

    return samples;
  }

  List<double> _encodeLine(img.Image image, int y, String component) {
    final samplesPerPixel = (lineDuration * sampleRate / 1000) / width;
    final totalSamples = (lineDuration * sampleRate / 1000).round();
    final result = List<double>.filled(totalSamples, 0);

    var sampleIndex = 0;

    for (var x = 0; x < width; x++) {
      final pixel = image.getPixel(x, y);

      // Extract color component
      int value;
      switch (component) {
        case 'red':
          value = pixel.r.toInt();
        case 'green':
          value = pixel.g.toInt();
        case 'blue':
          value = pixel.b.toInt();
        default:
          value = 0;
      }

      final frequency = pixelToFrequency(value);
      final pixelSamples = samplesPerPixel.round();

      // Generate tone for this pixel
      for (var i = 0; i < pixelSamples && sampleIndex < totalSamples; i++) {
        result[sampleIndex] = sin(
          2 * pi * frequency * sampleIndex / sampleRate,
        );
        sampleIndex++;
      }
    }

    return result;
  }
}
