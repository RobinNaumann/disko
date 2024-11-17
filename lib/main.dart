import 'package:disko/widget/vp_analysis.dart';
import 'package:elbe/elbe.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:moewe/moewe.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

void main() async {
  await _configureMacosWindowUtils();
  await AppInfoService.init();
  WidgetsFlutterBinding.ensureInitialized();

  // setup Moewe for crash logging
  await Moewe(
    host: "moewe.robbb.in",
    project: "0dca2d06267e48e0",
    app: "3b72569ec046bd54",
    appVersion: AppInfoService.i.version,
    buildNumber: int.tryParse(AppInfoService.i.buildNr),
    storeManaged: true,
  ).init();

  moewe.events.appOpen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            color: ColorThemeData.fromColor(accent: Colors.blue),
            type: TypeThemeData.preset(),
            geometry: GeometryThemeData.preset()),
        child: const MacosApp(
          debugShowCheckedModeBanner: false,
          title: 'Disko',
          home: BaseView(),
        ));
  }
}

class BaseView extends StatelessWidget {
  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MacosWindow(child: AnalysisPage());
  }
}
