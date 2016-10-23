#!/bin/bash

BUILD_VERSION=$(git rev-list HEAD --count)
INFO_PLIST="$TARGET_BUILD_DIR/$INFOPLIST_PATH"
DYSM_PLIST="$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME/Contents/Info.plist"

for plist in "$INFO_PLIST" "$DYSM_PLIST"; do
  if [ -f "$plist" ]; then
    /usr/libexec/PlistBuddy -c "Add :CFBundleBuildVersion string $BUILD_VERSION" "$plist" 2>/dev/null || /usr/libexec/PlistBuddy -c "Set :CFBundleBuildVersion $BUILD_VERSION" "$plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_VERSION" "$plist"
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $BUILD_VERSION" "$plist"
  fi
done