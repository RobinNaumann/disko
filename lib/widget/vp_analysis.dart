import 'package:disko/bit/b_dirpath.dart';
import 'package:disko/widget/v_analysis.dart';
import 'package:elbe/elbe.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:moewe/moewe.dart';

extension CRect on Rect {
  bool get isNegative => left < 0 || top < 0 || width < 0 || height < 0;
  Rect copyWith({double? left, double? top, double? width, double? height}) =>
      Rect.fromLTWH(left ?? this.left, top ?? this.top, width ?? this.width,
          height ?? this.height);
}

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  static void showFeedback(BuildContext c) => MoeweFeedbackPage.show(
        c,
        labels: FeedbackLabels(
            header: "send feedback",
            description:
                "Hey ☺️ Thanks for using Disko!\nIf you have any feedback, questions or suggestions, please let me know. I'm always happy to hear from you.\n\nYours, Robin",
            contactDescription:
                "if you want me to respond to you, please provide your email address or social media handle",
            contactHint: "contact info (optional)"),
        theme: MoeweTheme(
            darkTheme: MacosTheme.brightnessOf(c) == Brightness.dark,
            backButtonOffset: 5),
      );

  static ToolBarIconButton sendFeedbackButton(BuildContext c) =>
      ToolBarIconButton(
          label: "view",
          icon: MacosIcon(CupertinoIcons.exclamationmark_bubble),
          tooltipMessage: "send feedback",
          onPressed: () => showFeedback(c),
          showLabel: false);

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
                        ToolBarDivider(),
                        sendFeedbackButton(context),
                      ],
                    ),
                    children: [
                        ContentArea(
                            builder: (c, sc) => Column(
                                  children: [
                                    MoeweUpdateView(),
                                    Expanded(
                                      child: Center(
                                        child: GestureDetector(
                                            onTap: () => bit.pickPath(),
                                            child: Padded.all(
                                                value: 2,
                                                child:
                                                    WText("choose a folder"))),
                                      ),
                                    ),
                                  ],
                                ))
                      ])
                : AnalysisView(path: path)));
  }
}
