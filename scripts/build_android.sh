set -e # exit on error

echo "\x1b[34;1mAndroid: Flutter build (apk)...\x1b[0m"
flutter build apk --release
cp ./build/app/outputs/flutter-apk/app-release.apk ./dist/$1.apk

echo "\x1b[34;1mAndroid: Flutter build (appbundle)...\x1b[0m"
flutter build appbundle --release
cp ./build/app/outputs/bundle/release/app-release.aab ./dist/printikum.aab
