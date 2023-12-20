import 'package:elbe/elbe.dart';
import 'package:flutter/material.dart' as m;
import 'package:disko/oss_licenses.dart';
import 'package:macos_ui/macos_ui.dart';

import '../util/text_style.dart';

class OssLicensesDialog extends StatelessWidget {
  const OssLicensesDialog({super.key});

  static void show(BuildContext c) => showMacosSheet(
      context: c,
      builder: (context) => const OssLicensesDialog(),
      barrierDismissible: true);

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: ListView(padding: const EdgeInsets.all(20), children: [
        m.Text("Open Source Software Licenses",
            style: macTheme(context).typography.title2.bold),
        const SizedBox(height: 30),
        ExpansionPanelList.radio(
            elevation: 0,
            children: ossLicenses
                .mapIndexed((i, e) => ExpansionPanelRadio(
                      backgroundColor: Colors.transparent,
                      headerBuilder: (c, ex) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: m.Text(e.name,
                                          style: macTheme(context)
                                              .typography
                                              .body
                                              .bold)),
                                  m.Text(e.version,
                                      style: macTheme(context)
                                          .typography
                                          .body
                                          .bold)
                                ],
                              ),
                              const SizedBox(height: 7),
                              m.Text(e.description,
                                  style: macTheme(context).typography.body),
                              m.Text(e.authors.join(","),
                                  style:
                                      macTheme(context).typography.title2.bold),
                            ]),
                      ),
                      body: m.Text(
                          "${e.homepage ?? ""}\n\n${e.license ?? "no license info available"}",
                          style: macTheme(context).typography.body),
                      canTapOnHeader: true,
                      value: i,
                    ))
                .toList()),
      ]),
    );
  }
}
