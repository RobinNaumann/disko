import 'package:elbe/elbe.dart';
import 'package:disko/model/m_filenode.dart';
import 'package:disko/service/s_files.dart';

class FileTreeBit extends MapMsgBitControl<FileNode> {
  static const builder = MapMsgBitBuilder<FileNode, FileTreeBit>.make;

  FileTreeBit({required String path}) : super(FilesService.i.tree(path));

  void emitExistingPath(String path) => state.whenData((s) {
        String relPath = path.substring(s.path.length);
        if (relPath.isEmpty) return;
        if (relPath.startsWith('/')) relPath = relPath.substring(1);

        FileNode current = s;
        for (final name in relPath.split("/")) {
          final c = current.children?.firstWhereOrNull((e) => e.name == name);
          if (c == null) {
            emitError("that path does not exist: $path");
            return;
          }
          current = c;
        }
        emit(current);
      });
}
