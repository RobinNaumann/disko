import 'package:elbe/elbe.dart';
import 'package:elbe/util/m_data.dart';

class FileNode extends DataModel {
  final String name;
  final String path;
  final int size;
  //if this is null, then this is a file
  final List<FileNode>? children;

  const FileNode(
      {required this.name,
      required this.path,
      required this.size,
      this.children});

  bool get isFile => children == null;

  List<FileNode>? get sortedChildren => children?.sorted((a, b) {
        if ((a.children == null) == (b.children == null)) {
          return a.name.compareTo(b.name);
        }
        return (a.children == null) ? 1 : -1;
      });

  int get totalSize =>
      children?.fold<int>(size, (p, e) => p + (e.totalSize)) ?? size;

  int get totalItems =>
      children?.fold<int>(1, (p, e) => p + (e.totalItems)) ?? 1;

  int get totalFiles =>
      children?.fold<int>(0, (p, e) => p + (e.totalFiles)) ?? 1;

  int get totalFolders =>
      children?.fold<int>(1, (p, e) => p + (e.totalFolders)) ?? 0;

  @override
  get map => {
        'name': name,
        'path': path,
        'size': size,
        'children': children?.map((e) => e.map).toList()
      };
}
