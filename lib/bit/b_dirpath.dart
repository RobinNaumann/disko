import 'package:elbe/elbe.dart';
import 'package:file_picker/file_picker.dart';

String? _cleanPath(String? path) {
  if (path == null) return null;
  final volume = "/Volumes/Macintosh HD";
  if (path.startsWith(volume)) path = path.substring(volume.length);
  return path;
}

class DirPathBit extends MapMsgBitControl<String?> {
  static const builder = MapMsgBitBuilder<String?, DirPathBit>.make;

  DirPathBit({String? picked}) : super.worker((_) async => _cleanPath(picked));

  void pickPath() async {
    final path = await FilePicker.platform
        .getDirectoryPath(dialogTitle: "pick the directory to analyze");
    if (path != null) emit(_cleanPath(path));
  }
}
