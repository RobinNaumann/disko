import 'package:elbe/elbe.dart';
import 'package:disko/service/s_appinfo.dart';
import 'package:disko/widget/vp_analysis.dart';
import 'package:macos_ui/macos_ui.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

void main() async {
  await _configureMacosWindowUtils();
  WidgetsFlutterBinding.ensureInitialized();

  try {
    AppInfoService.init(await PackageInfo.fromPlatform());
  } catch (e) {
    //
  }

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
          title: 'Flutter Demo',
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
