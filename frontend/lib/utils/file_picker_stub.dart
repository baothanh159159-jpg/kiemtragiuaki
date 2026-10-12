import 'dart:typed_data';

class PickedDocxFile {
  final String name;
  final Uint8List bytes;
  PickedDocxFile(this.name, this.bytes);
}

Future<PickedDocxFile?> pickDocxFile() async {
  return null;
}
