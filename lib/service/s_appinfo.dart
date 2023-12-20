import 'package:elbe/elbe.dart';

class AppInfoService {
  static const List<String> _authors = ['Robin Naumann'];
  final PackageInfo _info;
  static AppInfoService? i;
  const AppInfoService._(this._info);

  static void init(PackageInfo info) => i = AppInfoService._(info);

  String get versionFull => '${_info.version}+${_info.buildNumber}';
  String get name => _info.appName;
  String get version => _info.version;
  String get authors => _authors.join(', ');
}
