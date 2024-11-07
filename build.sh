# ==== CONFIG ====

app="Disko";
identity="Developer ID Application: Robin Tim Naumann"; # find via: security find-identity -p codesigning
keychain="notarytool-build"; # generate via: xcrun notarytool store-credentials ...
output="null"; # set to 'stdout' (default 'null') for verbose output





# ==== SCRIPT ====

set -e # exit on error
fOUT="/dev/$output"
macos_dir="./build/macos/Build/Products/Release" 


if [ "$1" == "info" ]; then
  if [ "$2" == "list" ]; then
    xcrun notarytool history --keychain-profile "$keychain"
    exit 0
  fi
  if [ "$2" == "log" ]; then
    xcrun notarytool log "$3" --keychain-profile "$keychain"
    exit 0
  fi
  xcrun notarytool info "$2" \
    --keychain-profile "$keychain" | grep "status" | sed 's/.*status: //'
  exit 0
fi

clear


echo "\x1b[34;1mmacOS: 1/5: Flutter build...\x1b[0m"
flutter build macos > $fOUT 2>&1

echo "\x1b[34;1mmacOS: 2/5: signing build...\x1b[0m"
codesign --force --options=runtime --deep --sign "$identity" "$macos_dir/$app.app" > $fOUT

if [ "$1" != "local" ]; then
  echo "\x1b[34;1mmacOS: 3/5: notarizing... (apple may take up to 1h)\x1b[0m"
  ditto -c -k --sequesterRsrc --keepParent "$macos_dir/$app.app" "$macos_dir/$app.zip"
  xcrun notarytool submit "$macos_dir/$app.zip" \
    --keychain-profile "$keychain" \
    --wait > $fOUT

  echo "\x1b[34;1mmacOS: 4/5: stapling & verify notarization...\x1b[0m"
  xcrun stapler staple "$macos_dir/$app.app" > $fOUT
  #verifying signature
  spctl -a -vv -t exec "$macos_dir/$app.app" > $fOUT
  else
  echo "\x1b[34;1mmacOS: skipping notarization...\x1b[0m"
fi

echo "\x1b[34;1mmacOS: 5/5: packaging to ./dist ...\x1b[0m"
rm -rf ./dist
mkdir -p ./dist
ditto -c -k --sequesterRsrc --keepParent "$macos_dir/$app.app" "./dist/$app.app.zip"
open "./dist"


# ==== NOTES ====
# get status: xcrun notarytool submit "$macos_dir/$app.zip" --keychain-profile "notarytool-build" --wait