import 'package:disko/util/byte_format.dart';
import 'package:elbe/elbe.dart';
import 'package:disko/model/m_filenode.dart';
import 'package:disko/util/text_style.dart';
import 'package:local_hero/local_hero.dart';
import 'package:macos_ui/macos_ui.dart';

import '../v_small_info.dart';

Color _textColor(BuildContext context) =>
    macTheme(context).typography.body.color ?? Colors.white;

const double _margin = 2;
const double _borderRadius = 3;

class GraphOptions {
  final Color color;
  final double itemHeight;
  final bool showFiles;
  final bool showNames;
  final Function(FileNode node)? onTap;
  final Function(FileNode node)? onDoubleTap;

  const GraphOptions(
      {this.color = Colors.blue,
      this.itemHeight = 30,
      this.showFiles = true,
      this.showNames = true,
      this.onTap,
      this.onDoubleTap});
}

class SizeGraphView extends StatelessWidget {
  final double hueFactor;
  final GraphOptions options;
  final Color? color;
  final FileNode node;
  final String? selected;

  SizeGraphView(
      {super.key,
      required this.node,
      this.selected,
      this.options = const GraphOptions()})
      : color = null,
        hueFactor = 330 / node.totalSize;

  const SizeGraphView._(
      {required this.node,
      required this.hueFactor,
      required this.selected,
      required this.options,
      required this.color});

  List<Widget> _makeChildren(BuildContext c, double factor) {
    final folders = <Widget>[];
    final files = <Widget>[];
    List<FileNode> tooSmalls = [];

    final baseColor = MacosTheme.of(c).canvasColor.withOpacity(1);

    //_textColor(c);

    HSLColor childColor =
        HSLColor.fromColor((color ?? options.color).inter(0.1, baseColor));

    for (final child in node.sortedChildren ?? <FileNode>[]) {
      final size = child.totalSize;
      final width = size * factor;
      if (child.isFile) {
        if (width > 10 && options.showFiles) {
          files.add(GestureDetector(
              onDoubleTap: () => options.onDoubleTap?.call(child),
              onTap: () => options.onTap?.call(child),
              child: _NodeItem(
                  showName: options.showNames && width > 50,
                  selected: selected == child.path,
                  color: baseColor.facM(-2),
                  height: options.itemHeight,
                  width: width,
                  node: child)));
        }
        continue;
      }
      if (width < 5) {
        tooSmalls.add(child);
        continue;
      }

      folders.add(SizedBox(
          width: width,
          child: SizeGraphView._(
            node: child,
            options: options,
            color: childColor.toColor(),
            hueFactor: hueFactor,
            selected: selected,
          )));
      childColor =
          childColor.withHue((childColor.hue + hueFactor * size) % 360);
    }

    final smallsWidth = tooSmalls.fold(0, (p, e) => p + e.totalSize) * factor;
    if (smallsWidth > 10) {
      folders.add(LocalHero(
        key: Key("${node.path}#smalls"),
        tag: "${node.path}#smalls",
        child: GestureDetector(
          onTap: () => SmallDialog.show(c, tooSmalls),
          child: Container(
              width: smallsWidth - _margin,
              height: options.itemHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  color: baseColor.facM(0.16))),
        ),
      ));
    }

    return [...folders, ...files];
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (_, c) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                      _makeChildren(context, c.maxWidth / node.totalSize)),
              GestureDetector(
                onDoubleTap: () => options.onDoubleTap?.call(node),
                onTap: () => options.onTap?.call(node),
                child: _NodeItem(
                    height: options.itemHeight,
                    selected: selected == node.path,
                    color: color ?? options.color,
                    showName: options.showNames && c.maxWidth > 50,
                    node: node),
              ),
            ],
          ));
}

class _NodeItem extends StatelessWidget {
  final double height;
  final bool selected;
  final Color color;
  final bool showName;
  final FileNode node;
  final double? width;
  const _NodeItem(
      {required this.selected,
      required this.color,
      required this.showName,
      required this.node,
      required this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    final textColor = _textColor(context);
    return Padding(
      padding: const EdgeInsets.only(right: _margin, bottom: _margin / 2),
      child: LocalHero(
          key: Key(node.path),
          tag: node.path,
          child: MacosTooltip(
              message: "${node.name}\n${node.totalSize.bytes}",
              child: node.isFile
                  ? Material(
                      color: color,
                      shape: BeveledRectangleBorder(
                        side: selected
                            ? BorderSide(
                                width: 2, color: Colors.grey.withOpacity(0.6))
                            : BorderSide.none,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8)),
                      ),
                      child: Container(
                          height: height,
                          width: (width ?? 2) - 2,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Center(
                            child: WText(
                              node.name,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextStyle(color: textColor),
                            ),
                          )))
                  : Container(
                      key: Key(node.path),
                      decoration: BoxDecoration(
                          border: selected
                              ? WBorder.all(
                                  color: _textColor(context).withOpacity(0.4),
                                  width: 3,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(_borderRadius),
                          color: color),
                      padding: const EdgeInsets.all(4),
                      height: height,
                      child: !showName
                          ? null
                          : Center(
                              child: WText(
                                node.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            )))),
    );
  }
}
