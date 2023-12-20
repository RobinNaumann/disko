import 'package:elbe/elbe.dart';
import 'package:disko/model/m_filenode.dart';
import 'package:disko/service/s_application.dart';
import 'package:disko/util/byte_format.dart';
import 'package:disko/util/text_style.dart';
import 'package:macos_ui/macos_ui.dart';

class NodeInfoView extends StatelessWidget {
  final FileNode node;
  const NodeInfoView({super.key, required this.node});

  Widget _row(BuildContext context, String label, String value) => Row(
        children: [
          SizedBox(
              width: 60,
              child: WText("$label:", style: MacosTypography.of(context).body)),
          const Spaced(),
          WText(value, style: macType(context).body.bold),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            WIcon(node.isFile ? ApfelIcons.doc : ApfelIcons.folder),
            const Spaced(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WText(node.name, style: macType(context).title2.bold),
                  WText(node.path, style: macType(context).footnote),
                ].spaced(amount: 0.3),
              ),
            ),
            WText(node.totalSize.bytes, style: macType(context).title2.bold),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                  children: [
                _row(context, "size", node.totalSize.bytes),
                if (!node.isFile)
                  _row(context, "folders", (node.totalFolders - 1).toString()),
                if (!node.isFile)
                  _row(context, "files", node.totalFiles.toString()),
              ].spaced(amount: 0.3)),
            ),
            Column(
              children: [
                MacosPulldownButton(
                    icon: ApfelIcons.ellipsis_circle,
                    items: node.isFile
                        ? [
                            MacosPulldownMenuItem(
                                title: const Text("open"),
                                onTap: () =>
                                    ProcessService.i.openFinder(node.path)),
                          ]
                        : [
                            MacosPulldownMenuItem(
                                title: const Text("open in Finder"),
                                onTap: () =>
                                    ProcessService.i.openFinder(node.path)),
                            MacosPulldownMenuItem(
                                title: const Text("open in Terminal"),
                                onTap: () =>
                                    ProcessService.i.openTerminal(node.path))
                          ])
              ],
            )
          ],
        ),
      ].spaced(),
    );
  }
}
