import 'package:elbe/elbe.dart';
import 'package:elbe/util/m_data.dart';

class RawFileNode extends DataModel {
  final String name;
  final String path;
  final int size;
  //if this is null, then this is a file
  final List<RawFileNode>? children;

  const RawFileNode(
      {required this.name,
      required this.path,
      required this.size,
      this.children});

  bool get isFile => children == null;

  List<RawFileNode>? get sortedChildren => children?.sorted((a, b) {
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

class FileNode extends RawFileNode {
  final double offset;
  final List<FileNode>? children;
  FileNode(
      {required super.name,
      required super.path,
      required super.size,
      required this.offset,
      this.children});

  @override
  List<FileNode>? get sortedChildren => children?.sorted((a, b) {
        if ((a.children == null) == (b.children == null)) {
          return a.name.compareTo(b.name);
        }
        return (a.children == null) ? 1 : -1;
      });

  factory FileNode.fromRaw(RawFileNode raw,
      [double? total, double offset = 0]) {
    total = total ?? raw.totalSize.toDouble();

    // map children
    List<FileNode>? children;
    if (raw.children != null) {
      double cOff = offset;
      for (final child in raw.sortedChildren!) {
        final cSize = child.totalSize;
        final cFactor = cSize / total;
        children ??= [];
        children.add(FileNode.fromRaw(child, total, cOff));
        cOff += cFactor;
      }
    }

    return FileNode(
        name: raw.name,
        path: raw.path,
        size: raw.size,
        offset: offset,
        children: children);
  }
}
