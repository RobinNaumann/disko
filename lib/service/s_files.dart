import 'dart:io';

import 'package:elbe/bit/bit/bit.dart';
import 'package:elbe/elbe.dart';
import 'package:path/path.dart' as p;
import 'package:disko/model/m_filenode.dart';

class FilesService {
  static const FilesService i = FilesService._();

  const FilesService._();

  MsgBit<FileNode> tree(String path) => Bit((update) async {
        final dir =
            await FileSystemEntity.type(path) == FileSystemEntityType.directory;

        final ent = dir ? Directory(path) : File(path);
        final size = (await ent.stat()).size;
        final name = p.basename(ent.path);
        List<FileNode>? children;

        if (dir) {
          children = <FileNode>[];
          try {
            await for (var e in (ent as Directory).list(followLinks: false)) {
              if (e is! File && e is! Directory) continue;
              children.add(await tree(e.path).asFuture);
              update("loading ${e.path}");
            }
          } catch (e) {
            //
          }
        }
        return FileNode(name: name, path: path, size: size, children: children);
      });
}
