import 'package:elbe/bit/bit/bit.dart';
import 'package:elbe/elbe.dart';
import 'package:disko/model/m_filenode.dart';

class ViewOptions {
  final FileNode? selected;
  final bool showFiles;
  final bool showNames;
  final Color color;
  final double itemHeight;

  FileNode active(FileNode node) => selected ?? node;

  const ViewOptions(
      {this.selected,
      this.showFiles = true,
      this.showNames = true,
      this.color = Colors.blue,
      this.itemHeight = 30});

  ViewOptions copyWith(
          {Maybe<FileNode>? selected,
          bool? showFiles,
          bool? showNames,
          Color? color,
          double? itemHeight}) =>
      ViewOptions(
          selected: maybeOr(selected, this.selected),
          showFiles: showFiles ?? this.showFiles,
          showNames: showNames ?? this.showNames,
          color: color ?? this.color,
          itemHeight: itemHeight ?? this.itemHeight);
}

class ViewOptionsBit extends MapMsgBitControl<ViewOptions> {
  static const builder = MapMsgBitBuilder<ViewOptions, ViewOptionsBit>.make;

  ViewOptionsBit() : super.worker((_) => const ViewOptions());
}
