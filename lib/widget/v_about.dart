import 'package:flutter/material.dart';
import 'package:disko/service/s_appinfo.dart';
import 'package:disko/widget/v_oss_licenses.dart';
import 'package:macos_ui/macos_ui.dart';

import '../util/text_style.dart';

class AboutAppDialog extends StatelessWidget {
  const AboutAppDialog({super.key});

  static void show(BuildContext context) => showMacosAlertDialog(
      context: context,
      builder: (context) => const AboutAppDialog(),
      barrierDismissible: true);

  @override
  Widget build(BuildContext context) {
    return MacosAlertDialog(
      appIcon: Image.asset('assets/icon.png', width: 48, height: 48),
      title: Text(AppInfoService.i?.name ?? 'Disko'),
      message:
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text("Version ${AppInfoService.i?.versionFull ?? '--'}"),
        const SizedBox(height: 10),
        Text("by ${AppInfoService.i?.authors ?? '?'}"),
        Text("robin.naumann@proton.me", style: macType(context).footnote),
        const SizedBox(height: 10),
        const Text("")
      ]),
      secondaryButton: PushButton(
          secondary: true,
          onPressed: () async {
            await Navigator.maybePop(context);
            // ignore: use_build_context_synchronously
            OssLicensesDialog.show(context);
          },
          controlSize: ControlSize.large,
          child: const Text("oss licenses")),
      primaryButton: PushButton(
        controlSize: ControlSize.large,
        child: const Text('OK'),
        onPressed: () => Navigator.maybePop(context),
      ),
    );
  }
}
