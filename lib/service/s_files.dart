import 'dart:io';

import 'package:disko/model/m_filenode.dart';
import 'package:elbe/bit/bit/bit.dart';
import 'package:elbe/elbe.dart';
import 'package:path/path.dart' as p;

class FilesService {
  static const FilesService i = FilesService._();

  const FilesService._();

  MsgBit<FileNode> tree(String path) => Bit((update) async {
        final dir =
            await FileSystemEntity.type(path) == FileSystemEntityType.directory;

        final ent = dir ? Directory(path) : File(path);
        final size = (await ent.stat()).size;
        final name = p.basename(ent.path);
        List<RawFileNode>? children;

        if (dir) {
          children = <RawFileNode>[];
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
        return FileNode.fromRaw(RawFileNode(
            name: name, path: path, size: size, children: children));
      });
}
