// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

class PickedDocxFile {
  final String name;
  final Uint8List bytes;
  PickedDocxFile(this.name, this.bytes);
}

Future<PickedDocxFile?> pickDocxFile() async {
  final completer = Completer<PickedDocxFile?>();
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = '.docx';

  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      final reader = html.FileReader();

      reader.onLoadEnd.listen((e) {
        final result = reader.result;
        if (result is Uint8List) {
          completer.complete(PickedDocxFile(file.name, result));
        } else if (result is ByteBuffer) {
          completer.complete(PickedDocxFile(file.name, result.asUint8List()));
        } else if (result is List<int>) {
          completer.complete(PickedDocxFile(file.name, Uint8List.fromList(result)));
        } else {
          completer.complete(null);
        }
      });

      reader.onError.listen((e) {
        completer.complete(null);
      });

      reader.readAsArrayBuffer(file);
    } else {
      completer.complete(null);
    }
  });

  uploadInput.click();
  return completer.future;
}
