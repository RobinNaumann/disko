set -e # exit on error

echo "\x1b[34;1mmacOS AppStore: Flutter build...\x1b[0m"
flutter build macos --release
xed ./macos/