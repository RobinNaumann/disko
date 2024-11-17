# config:
label="Disko"
package="in.robbb.disko"

# script:

set -e # exit on error
clear

echo "\x1b[32;1mRunnin Plugins\x1b[0m"
flutter pub get
dart run flutter_launcher_icons
dart run change_app_package_name:main $package

echo "\x1b[34;cleaning output...\x1b[0m"
rm -rf ./dist
mkdir ./dist
echo "\x1b[34;1mbuilding app for macOS\x1b[0m"

#./scripts/build_android.sh $label 
#./scripts/build_macos.sh $label

echo "\x1b[34;1mbuilding app for XCode Release\x1b[0m"
flutter build macos --release

#echo "\x1b[32;1mDone! opening dist directory\x1b[0m"
#open ./dist