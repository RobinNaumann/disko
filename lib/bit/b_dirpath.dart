import 'package:elbe/elbe.dart';
import 'package:file_picker/file_picker.dart';

class DirPathBit extends MapMsgBitControl<String?> {
  static const builder = MapMsgBitBuilder<String?, DirPathBit>.make;

  DirPathBit({String? picked}) : super.worker((_) async => picked);

  void pickPath() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) emit(path);
  }
}
