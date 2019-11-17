#!/bin/bash
# DESCRIPTION: Creates a standalone macOS application and DMG for installation.
# PARAMETERS: Version (optional)

# Move to the current working directory.
cd $(dirname "$0")

# Attempt to locate Qt.
QT="$(which qmake)"
if [ ! -x "${QT}" ] ; then
    echo "ERROR: Failed to find Qt. Please ensure it is accessible in the PATH and try again."
    exit 1
else
    QT="${QT:0:${#QT}-6}"
fi

TARGET_NAME="SudokuSolver"
DISPLAY_NAME="Sudoku Solver"
DISPLAY_FILENAME="${DISPLAY_NAME// /_}"

# Check if a version was specified.
if [ $# -eq 1 ]; then
    VERSION="$1"
    echo "Supplying version ${VERSION}..."
else
    VERSION="1.0.0"
    echo "No version specified, so using ${VERSION}..."
fi

# Prepare for the build.
pushd . &> /dev/null
rm -rf ../../build_tmp &> /dev/null
rm -rf *.app &> /dev/null
rm -f *.dmg &> /dev/null
rm -rf dmg/dmg_tmp &> /dev/null

# Build the application.
pushd . &> /dev/null
mkdir ../../build_tmp
cd ../../build_tmp
if ! qmake -config release "VERSION=${VERSION}" ../${TARGET_NAME}.pro; then
    popd > /dev/null
    rm -rf ../../build_tmp
    exit 1
fi
if ! make -j4; then
    popd > /dev/null
    rm -rf ../../build_tmp
    exit 1
fi
popd &> /dev/null

# Copy the application here to leave the build artifacts untouched.
cp -R "../../build_tmp/${TARGET_NAME}.app" .

# Rename the file to the display name.
mv "${TARGET_NAME}.app" "${DISPLAY_NAME}.app" &> /dev/null

# Prepare the application for deployment.
if ! macdeployqt "${DISPLAY_NAME}.app" -qmldir=${QT}/../qml; then
    popd &> /dev/null
    rm -rf ../../build_tmp
    exit 1
fi
popd &> /dev/null

# Create the DMG
pushd . &> /dev/null
mkdir -p dmg/dmg_tmp
mkdir dmg/dmg_tmp/.hidden
ln -s /Applications dmg/dmg_tmp/Applications
cp dmg/background.tiff dmg/dmg_tmp/.hidden/background.tiff
touch dmg/dmg_tmp/.DS_Store
cp -R "${DISPLAY_NAME}.app" dmg/dmg_tmp
hdiutil create "${TARGET_NAME}.dmg" -srcfolder dmg/dmg_tmp -ov -volname "${DISPLAY_NAME}" -format UDRW -fs HFS+
hdiutil mount "${TARGET_NAME}.dmg"
sleep 1
echo '
tell application "Finder"
    tell disk "'${DISPLAY_NAME}'"
       set current view of container window to icon view
       set theViewOptions to the icon view options of container window
       set icon size of theViewOptions to 96
       set background picture of theViewOptions to file ".hidden:background.tiff"
       open
       set toolbar visible of container window to false
       set statusbar visible of container window to false
       set the bounds of container window to {100, 100, 640, 480}
       set position of item "'${DISPLAY_NAME}.app'" of container window to {135, 190}
       set position of item "Applications" of container window to {405, 190}
       update without registering applications
       delay 1
       close
       eject
    end tell
end tell
tell application "Finder" to close every window
' | osascript
hdiutil detach "/Volumes/${DISPLAY_NAME}" -force
hdiutil mount "${TARGET_NAME}.dmg"
bless --folder "/Volumes/${DISPLAY_NAME}" --openfolder "/Volumes/${DISPLAY_NAME}"
hdiutil detach "/Volumes/${DISPLAY_NAME}" -force
hdiutil convert "${TARGET_NAME}.dmg" -format UDZO -ov -o "${TARGET_NAME}.dmg"
mv "${TARGET_NAME}.dmg" "${DISPLAY_FILENAME}_${VERSION}.dmg"
popd &> /dev/null

# Clean up the build artifacts.
rm -rf ../../build_tmp
rm -rf dmg/dmg_tmp
rm -rf "${DISPLAY_NAME}.app"

# Done!
echo "Installer successfully created!"

