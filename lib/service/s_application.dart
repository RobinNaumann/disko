import 'dart:io';

class ProcessService {
  static const ProcessService i = ProcessService._internal();
  const ProcessService._internal();

  void openFinder(String path) => Process.run('open', [path]);
  void openTerminal(String path) =>
      Process.run('open', ['-a', 'Terminal', path]);
}
