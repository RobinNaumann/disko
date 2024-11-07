import 'package:disko/bit/b_dirpath.dart';
import 'package:disko/bit/b_view_options.dart';
import 'package:disko/model/m_filenode.dart';
import 'package:disko/widget/folder_info/v_node_info.dart';
import 'package:disko/widget/graph/v_size_graph.dart';
import 'package:elbe/elbe.dart';
import 'package:local_hero/local_hero.dart';
import 'package:macos_ui/macos_ui.dart';

import '../bit/b_filetree.dart';
import 'vp_analysis.dart';

extension CRect on Rect {
  bool get isNegative => left < 0 || top < 0 || width < 0 || height < 0;
  Rect copyWith({double? left, double? top, double? width, double? height}) =>
      Rect.fromLTWH(left ?? this.left, top ?? this.top, width ?? this.width,
          height ?? this.height);
}

class AnalysisView extends StatelessWidget {
  final String path;
  const AnalysisView({super.key, required this.path});

  @override
  Widget build(BuildContext context) => BitBuildProvider(
      key: ValueKey(path),
      create: (BuildContext context) => FileTreeBit(path: path),
      onData: (fileBit, FileNode fileTree) => BitBuildProvider(
          create: (_) => ViewOptionsBit(),
          onData: (optionsBit, ViewOptions options) => MacosScaffold(
                  toolBar: ToolBar(
                    title: const WText('Disko'),
                    actions: [
                      ToolBarIconButton(
                        icon: const WIcon(ApfelIcons.back),
                        label: 'back',
                        showLabel: false,
                        onPressed: () => fileBit.back(),
                      ),
                      ToolBarIconButton(
                        icon: const WIcon(ApfelIcons.refresh),
                        label: 'reload',
                        showLabel: false,
                        onPressed: () => fileBit.reload(),
                      ),
                      ToolBarIconButton(
                        icon: const WIcon(ApfelIcons.folder_open),
                        label: 'open',
                        showLabel: false,
                        onPressed: () => context.bit<DirPathBit>().pickPath(),
                      ),
                      ToolBarPullDownButton(
                        icon: ApfelIcons.gear,
                        label: 'options',
                        items: [
                          MacosPulldownMenuItem(
                              title: Text(options.showFiles
                                  ? "hide files"
                                  : "show files"),
                              onTap: () => optionsBit.emit(options.copyWith(
                                  showFiles: !options.showFiles))),
                          MacosPulldownMenuItem(
                              title: Text(options.showNames
                                  ? "hide names"
                                  : "show names"),
                              onTap: () => optionsBit.emit(options.copyWith(
                                  showNames: !options.showNames))),
                          const MacosPulldownMenuDivider(),
                          MacosPulldownMenuItem(
                              title: Text("send feedback"),
                              onTap: () async {
                                await Navigator.of(context).maybePop();
                                AnalysisPage.showFeedback(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                  children: [
                    ContentArea(
                        builder: (c, sc) => FileTreeBit.builder(
                            onData: (bit, state) => Padded.all(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: LocalHeroScope(
                                            createRectTween: (a, b) =>
                                                RectTween(begin: a, end: b),
                                            duration: const Duration(
                                                milliseconds: 200),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              child: SingleChildScrollView(
                                                  reverse: true,
                                                  controller: sc,
                                                  child: SizeGraphView(
                                                    options: GraphOptions(
                                                        /*
                                                            macTheme(context)
                                                                .canvasColor,*/
                                                        color: options.color,
                                                        showFiles:
                                                            options.showFiles,
                                                        itemHeight:
                                                            options.itemHeight,
                                                        showNames:
                                                            options.showNames,
                                                        onTap: (node) =>
                                                            optionsBit.emit(
                                                                options.copyWith(
                                                                    selected: () =>
                                                                        node)),
                                                        onDoubleTap: (node) =>
                                                            fileBit
                                                                .emitExistingPath(
                                                                    node.path)),
                                                    node: fileTree,
                                                    selected:
                                                        options.selected?.path,
                                                  )),
                                            ))),
                                    Padded.only(
                                        bottom: 0.5,
                                        child: NodeInfoView(
                                            node:
                                                options.selected ?? fileTree)),
                                  ].spaced(amount: 2),
                                ))))
                  ])));
}
