// Generates a simple ZÜVO app icon as PNG
// Run: dart run tool/generate_icon.dart

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:archive/archive.dart' show getCrc32;

void main() {
  // Generate icon at 1024x1024
  const size = 1024;
  final pixels = _generateIcon(size);
  final png = _encodePng(size, size, pixels);

  final outFile = File('assets/icon/zuvo_icon.png');
  outFile.parent.createSync(recursive: true);
  outFile.writeAsBytesSync(png);
  print('Icon written to ${outFile.path}');
}

Uint8List _generateIcon(int size) {
  // RGBA pixels
  final data = Uint8List(size * size * 4);

  // Colors
  const bgR = 0x0A, bgG = 0x16, bgB = 0x28; // navy
  const tealR = 0x2E, tealG = 0xDD, tealB = 0xC8;
  const limeR = 0x7E, limeG = 0xD9, limeB = 0x57;

  // Fill background
  for (int i = 0; i < size * size; i++) {
    data[i * 4] = bgR;
    data[i * 4 + 1] = bgG;
    data[i * 4 + 2] = bgB;
    data[i * 4 + 3] = 255;
  }

  // Draw a simple "Z" letter centered
  final cx = size ~/ 2;
  final cy = size ~/ 2;
  final letterSize = (size * 0.5).toInt();
  final thickness = (size * 0.09).toInt();
  final left = cx - letterSize ~/ 2;
  final right = cx + letterSize ~/ 2;
  final top = cy - letterSize ~/ 2;
  final bottom = cy + letterSize ~/ 2;

  void fillRect(int x1, int y1, int x2, int y2, int r, int g, int b) {
    for (int y = y1.clamp(0, size - 1); y <= y2.clamp(0, size - 1); y++) {
      for (int x = x1.clamp(0, size - 1); x <= x2.clamp(0, size - 1); x++) {
        final idx = (y * size + x) * 4;
        data[idx] = r;
        data[idx + 1] = g;
        data[idx + 2] = b;
        data[idx + 3] = 255;
      }
    }
  }

  // Top bar of Z (teal)
  fillRect(left, top, right, top + thickness, tealR, tealG, tealB);

  // Diagonal of Z (gradient from teal to lime)
  for (int i = 0; i <= letterSize; i++) {
    final t = i / letterSize;
    final x = right - (i * letterSize / letterSize).toInt();
    final y = top + (i * letterSize / letterSize).toInt();
    final r = (tealR + (limeR - tealR) * t).toInt();
    final g = (tealG + (limeG - tealG) * t).toInt();
    final b = (tealB + (limeB - tealB) * t).toInt();
    fillRect(x - thickness ~/ 2, y - thickness ~/ 2, x + thickness ~/ 2, y + thickness ~/ 2, r, g, b);
  }

  // Bottom bar of Z (lime)
  fillRect(left, bottom - thickness, right, bottom, limeR, limeG, limeB);

  return data;
}

Uint8List _encodePng(int w, int h, Uint8List rgba) {
  // Minimal PNG encoder
  final rawData = BytesBuilder();
  for (int y = 0; y < h; y++) {
    rawData.addByte(0); // filter none
    rawData.add(rgba.sublist(y * w * 4, (y + 1) * w * 4));
  }
  final raw = rawData.toBytes();

  // Deflate (use zlib)
  final compressed = ZLibCodec().encode(raw);

  final out = BytesBuilder();

  // PNG signature
  out.add([137, 80, 78, 71, 13, 10, 26, 10]);

  void writeChunk(String type, Uint8List data) {
    final lenBytes = ByteData(4)..setUint32(0, data.length);
    out.add(lenBytes.buffer.asUint8List());
    final typeBytes = ascii.encode(type);
    out.add(typeBytes);
    out.add(data);
    // CRC of type + data
    final crcInput = Uint8List(typeBytes.length + data.length);
    crcInput.setAll(0, typeBytes);
    crcInput.setAll(typeBytes.length, data);
    final crc = _crc32(crcInput);
    final crcBytes = ByteData(4)..setUint32(0, crc);
    out.add(crcBytes.buffer.asUint8List());
  }

  // IHDR
  final ihdr = ByteData(13);
  ihdr.setUint32(0, w);
  ihdr.setUint32(4, h);
  ihdr.setUint8(8, 8); // bit depth
  ihdr.setUint8(9, 6); // RGBA
  ihdr.setUint8(10, 0);
  ihdr.setUint8(11, 0);
  ihdr.setUint8(12, 0);
  writeChunk('IHDR', ihdr.buffer.asUint8List());

  // IDAT
  writeChunk('IDAT', Uint8List.fromList(compressed));

  // IEND
  writeChunk('IEND', Uint8List(0));

  return out.toBytes();
}

int _crc32(Uint8List data) {
  // Standard CRC-32
  const table = <int>[];
  var crc = 0xFFFFFFFF;
  // Build table on the fly
  final t = List<int>.generate(256, (n) {
    var c = n;
    for (var k = 0; k < 8; k++) {
      c = (c & 1) != 0 ? (0xEDB88320 ^ (c >> 1)) : (c >> 1);
    }
    return c;
  });
  for (final b in data) {
    crc = t[(crc ^ b) & 0xFF] ^ (crc >> 8);
  }
  return crc ^ 0xFFFFFFFF;
}
