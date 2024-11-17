import 'package:disko/util/byte_format.dart';
import 'package:elbe/elbe.dart';
import 'package:macos_ui/macos_ui.dart';

import '../model/m_filenode.dart';
import '../util/text_style.dart';

class SmallDialog extends StatelessWidget {
  final List<FileNode> nodes;
  const SmallDialog({super.key, required this.nodes});

  static void show(BuildContext c, List<FileNode> nodes) => showMacosSheet(
      context: c,
      builder: (context) => SmallDialog(nodes: nodes),
      barrierDismissible: true);

  Widget _entry(FileNode node) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Icon(node.isFile ? ApfelIcons.doc : ApfelIcons.folder),
        Expanded(
            child: Padded.only(
                left: .7,
                right: 1,
                child: WText(
                  node.name,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ))),
        WText(
          node.size.bytes,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ]));

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: ListView(padding: const EdgeInsets.all(20), children: [
        WText("Small Entries", style: macTheme(context).typography.title2.bold),
        const SizedBox(height: 10),
        ...nodes.map(_entry).toList()
      ]),
    );
  }
}
