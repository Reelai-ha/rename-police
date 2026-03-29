#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/Release"
DIST_DIR="$ROOT_DIR/dist"
APP_NAME="RenamePolice.app"
ZIP_NAME="RenamePolice-mac.zip"
DMG_NAME="RenamePolice.dmg"
MAKE_DMG="false"

if [[ "${1:-}" == "--dmg" ]]; then
  MAKE_DMG="true"
fi

rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$BUILD_DIR" "$DIST_DIR"

xcodebuild \
  -project "$ROOT_DIR/RenamePolice.xcodeproj" \
  -scheme RenamePolice \
  -configuration Release \
  CONFIGURATION_BUILD_DIR="$BUILD_DIR" \
  build

if [[ ! -d "$BUILD_DIR/$APP_NAME" ]]; then
  echo "Expected app bundle not found at $BUILD_DIR/$APP_NAME" >&2
  exit 1
fi

/usr/bin/ditto -c -k --sequesterRsrc --keepParent \
  "$BUILD_DIR/$APP_NAME" \
  "$DIST_DIR/$ZIP_NAME"

echo "Created $DIST_DIR/$ZIP_NAME"

if [[ "$MAKE_DMG" == "true" ]]; then
  hdiutil create \
    -volname "Rename Police" \
    -srcfolder "$BUILD_DIR/$APP_NAME" \
    -ov \
    -format UDZO \
    "$DIST_DIR/$DMG_NAME"

  echo "Created $DIST_DIR/$DMG_NAME"
fi
