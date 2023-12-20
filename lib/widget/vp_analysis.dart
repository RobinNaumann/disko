import 'package:elbe/elbe.dart';
import 'package:disko/bit/b_dirpath.dart';
import 'package:disko/widget/v_analysis.dart';
import 'package:macos_ui/macos_ui.dart';

extension CRect on Rect {
  bool get isNegative => left < 0 || top < 0 || width < 0 || height < 0;
  Rect copyWith({double? left, double? top, double? width, double? height}) =>
      Rect.fromLTWH(left ?? this.left, top ?? this.top, width ?? this.width,
          height ?? this.height);
}

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BitProvider(
        create: (BuildContext context) => DirPathBit(),
        child: DirPathBit.builder(
            onData: (bit, path) => path == null
                ? MacosScaffold(
                    toolBar: ToolBar(
                      title: const WText('Disko'),
                      actions: [
                        ToolBarIconButton(
                          icon: const WIcon(ApfelIcons.folder_open),
                          label: 'open',
                          showLabel: false,
                          onPressed: () => bit.pickPath(),
                        ),
                        const ToolBarPullDownButton(
                          icon: ApfelIcons.gear,
                          label: 'options',
                          items: [AboutEntry()],
                        ),
                      ],
                    ),
                    children: [
                        ContentArea(
                            builder: (c, sc) =>
                                const Center(child: Text("choose a folder")))
                      ])
                : AnalysisView(path: path)));
  }
}
