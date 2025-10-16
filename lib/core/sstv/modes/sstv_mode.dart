import 'dart:math';

import 'package:image/image.dart' as img;

abstract class SSTVMode {
  String get name;
  int get visCode;
  int get width;
  int get height;
  int get sampleRate => 44100;

  // Generate audio samples for the image
  List<double> encode(img.Image image);

  // Common tone generation
  List<double> generateTone(double frequency, double durationMs) {
    final samples = (durationMs * sampleRate / 1000).round();
    final result = List<double>.filled(samples, 0);

    for (var i = 0; i < samples; i++) {
      result[i] = sin(2 * pi * frequency * i / sampleRate);
    }

    return result;
  }

  // VIS code generation (common for all modes)
  List<double> generateVISCode() {
    final samples = <double>[
      // Leader tone: 1900 Hz for 300ms
      ...generateTone(1900, 300),
      // Break: 1200 Hz for 10ms
      ...generateTone(1200, 10),
      // Leader tone: 1900 Hz for 300ms
      ...generateTone(1900, 300),
      // VIS start bit: 1200 Hz for 30ms
      ...generateTone(1200, 30),
    ];

    // VIS code bits (LSB first)
    for (var i = 0; i < 7; i++) {
      final bit = (visCode >> i) & 1;
      final freq = bit == 1 ? 1100.0 : 1300.0;
      samples.addAll(generateTone(freq, 30));
    }

    // Parity bit (even parity)
    var parity = 0;
    for (var i = 0; i < 7; i++) {
      parity ^= (visCode >> i) & 1;
    }
    final parityFreq = parity == 1 ? 1100.0 : 1300.0;
    samples
      ..addAll(generateTone(parityFreq, 30))
      // VIS stop bit: 1200 Hz for 30ms
      ..addAll(generateTone(1200, 30));

    return samples;
  }

  // Convert pixel value (0-255) to frequency (1500-2300 Hz)
  double pixelToFrequency(int value) {
    return 1500.0 + (value / 255.0) * 800.0;
  }
}
