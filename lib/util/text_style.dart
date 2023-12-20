import 'package:elbe/elbe.dart';
import 'package:macos_ui/macos_ui.dart';

extension TxtStyle on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
}

MacosTypography macType(BuildContext context) => MacosTypography.of(context);
MacosThemeData macTheme(BuildContext context) => MacosTheme.of(context);
