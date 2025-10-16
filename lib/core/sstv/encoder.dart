import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:wavica/core/sstv/modes/sstv_mode.dart';

class SSTVEncoder {
  SSTVEncoder(this.mode);
  final SSTVMode mode;

  // Encode image and return audio samples
  Float32List encodeImage(img.Image image) {
    final samples = mode.encode(image);
    return Float32List.fromList(samples);
  }

  // Get WAV file bytes
  Uint8List encodeToWav(img.Image image) {
    final samples = encodeImage(image);
    return _createWavFile(samples, mode.sampleRate);
  }

  Uint8List _createWavFile(Float32List samples, int sampleRate) {
    final numSamples = samples.length;
    const numChannels = 1;
    const bitsPerSample = 16;
    final byteRate = sampleRate * numChannels * bitsPerSample ~/ 8;
    const blockAlign = numChannels * bitsPerSample ~/ 8;
    final dataSize = numSamples * numChannels * bitsPerSample ~/ 8;

    final buffer = ByteData(44 + dataSize)
      // RIFF header
      ..setUint8(0, 0x52) // 'R'
      ..setUint8(1, 0x49) // 'I'
      ..setUint8(2, 0x46) // 'F'
      ..setUint8(3, 0x46) // 'F'
      ..setUint32(4, 36 + dataSize, Endian.little)
      ..setUint8(8, 0x57) // 'W'
      ..setUint8(9, 0x41) // 'A'
      ..setUint8(10, 0x56) // 'V'
      ..setUint8(11, 0x45) // 'E'
      // fmt chunk
      ..setUint8(12, 0x66) // 'f'
      ..setUint8(13, 0x6D) // 'm'
      ..setUint8(14, 0x74) // 't'
      ..setUint8(15, 0x20) // ' '
      ..setUint32(16, 16, Endian.little) // fmt chunk size
      ..setUint16(20, 1, Endian.little) // PCM format
      ..setUint16(22, numChannels, Endian.little)
      ..setUint32(24, sampleRate, Endian.little)
      ..setUint32(28, byteRate, Endian.little)
      ..setUint16(32, blockAlign, Endian.little)
      ..setUint16(34, bitsPerSample, Endian.little)
      // data chunk
      ..setUint8(36, 0x64) // 'd'
      ..setUint8(37, 0x61) // 'a'
      ..setUint8(38, 0x74) // 't'
      ..setUint8(39, 0x61) // 'a'
      ..setUint32(40, dataSize, Endian.little);

    // Write samples
    for (var i = 0; i < numSamples; i++) {
      final sample = (samples[i] * 32767).round().clamp(-32768, 32767);
      buffer.setInt16(44 + i * 2, sample, Endian.little);
    }

    return buffer.buffer.asUint8List();
  }
}
