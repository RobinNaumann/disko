import 'dart:math';

import 'package:disko/model/m_filenode.dart';
import 'package:disko/util/byte_format.dart';
import 'package:disko/util/text_style.dart';
import 'package:disko/widget/graph/v_limited_hero.dart';
import 'package:elbe/elbe.dart';
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
  final GraphOptions options;
  final FileNode node;
  final String? selected;

  SizeGraphView(
      {super.key,
      required this.node,
      this.selected,
      this.options = const GraphOptions()});

  List<Widget> _makeChildren(BuildContext c, double factor) {
    final folders = <Widget>[];
    final files = <Widget>[];
    List<FileNode> tooSmalls = [];

    final baseColor = MacosTheme.of(c).canvasColor.withOpacity(1);

    for (final child in node.sortedChildren ?? <FileNode>[]) {
      final width = child.totalSize * factor;

      if (child.isFile) {
        if (!options.showFiles) continue;
        if (width > 10) {
          // add a file
          files.add(GestureDetector(
              onDoubleTap: () => options.onDoubleTap?.call(child),
              onTap: () => options.onTap?.call(child),
              child: _NodeItem(
                  showName: options.showNames && width > 50,
                  selected: selected == child.path,
                  color: HSLColor.fromColor(baseColor.facM(-2)),
                  height: options.itemHeight,
                  width: width,
                  node: child)));
        } else {
          tooSmalls.add(child);
        }
        continue;
      }
      if (width < 5) {
        tooSmalls.add(child);
        continue;
      }

      folders.add(SizedBox(
          width: width,
          child: SizeGraphView(
            node: child,
            options: options,
            selected: selected,
          )));
    }

    final smallsWidth = tooSmalls.fold(0, (p, e) => p + e.totalSize) * factor;
    if (smallsWidth > 5) {
      files.add(LocalLimitedHero(
        tag: "${node.path}#smalls",
        child: GestureDetector(
          onTap: () => SmallDialog.show(c, tooSmalls),
          child: Container(
              margin: EdgeInsets.only(bottom: 1),
              width: max(1, smallsWidth - _margin),
              height: options.itemHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  color: baseColor.facM(0.3))),
        ),
      ));
    }

    return [...folders, ...files];
  }

  @override
  Widget build(BuildContext context) {
    //final baseColor = MacosTheme.of(c).canvasColor.withOpacity(1);
    final hslC = HSLColor.fromColor(options.color); //.inter(0.1, baseColor));

    return LayoutBuilder(
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
                      color: hslC.withHue((hslC.hue + node.offset * 300) % 360),
                      showName: options.showNames && c.maxWidth > 50,
                      node: node),
                ),
              ],
            ));
  }
}

class _NodeItem extends StatelessWidget {
  final double height;
  final bool selected;
  final HSLColor color;
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

  bool _isLight(HSLColor c) =>
      c.lightness > .7 || (c.lightness > .5 && c.hue > 40 && c.hue < 100);

  @override
  Widget build(BuildContext context) {
    final textColor = _isLight(color) ? Colors.black : Colors.white;

    //_textColor(context);
    return Padding(
      padding: const EdgeInsets.only(right: _margin, bottom: _margin / 2),
      child: LocalLimitedHero(
          tag: node.path,
          child: MacosTooltip(
              message:
                  "${node.name} (${node.totalSize.bytes})\ndouble-click to focus",
              child: node.isFile
                  ? Material(
                      color: color.toColor(),
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
                          color: color.toColor()),
                      padding: const EdgeInsets.all(4),
                      height: height,
                      child: !showName
                          ? null
                          : Center(
                              child: WText(
                                node.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: textColor),
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            )))),
    );
  }
}
