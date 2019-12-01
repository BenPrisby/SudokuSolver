# SudokuSolver

The Sudoku Solver is a simple application for, as the name implies, solving Sudoku puzzles. It is built against the Qt framework with a QML view, making it available and easy to build for macOS, Windows, and Linux.

## Features

The QML view offers a simple UI for entering in the puzzle to be solved. A single action button initiates the solving process, displaying the final solution and time taken to solve once completed.

Invalid input puzzles (i.e. those with rule violations already present) will be rejected and an error message will be displayed when attempting to solve.

After solving, the action button allows clearing of the grid to enter another puzzle to solve.

## Algorithm

The heart of the solving engine uses a backtracking algorithm to solve the puzzle. Values are placed until the board is either solved or no more valid placements are available. When this occurs, the algorithm steps back until another valid choice can be made. Optimizations have been added to improve the efficiency of the traditional brute-force approach.

An internal conflict model tracks conflicts along rows, columns, and squares to improve the algorithm's guess at placing the next value. Data containers for these models ensure constant time lookups and the algorithm is able to move on to the next possible placement as soon as one of the three possible conflicts has been found.

The engine also keeps track of the position of the last-placed value to speed up search times for the next available cell. Since the algorithm works left-to-right, top-to-bottom, doing this cuts down on the time required to find blank cells as opposed to starting at the top-left of the board every time.

## Project Contents

### build

- Build scripts and deployment assets for macOS, Windows, and Linux

### docs

- Generated documentation from the source files using [Doxygen](http://www.doxygen.nl)

### Doxyfile

- Configuration file for Doxygen

### qml

- QML components used throughout the application

### resources

- Design assets for the application
- macOS app bundle metadata file (_Info.plist_)
- Generic application icon (_icon.png_)
- macOS application icon file (_icon\_apple.icns_)
- Windows application icon file (_icon\_windows.ico_)
- Windows resource file (_myapp.rc_)

### src

- C++ source files for the application

### SudokuSolver.pro

- Qt project file

## Prerequisites

-   [Qt 5.12 (Open Source)](https://www.qt.io/download)

	-  Releases are built against 5.12.6 (currently the latest stable 5.12 release).
	-	After installation is complete, it is recommended to add Qt to the PATH environment variable (i.e. `export PATH=~/Qt/5.12.6/clang_64/bin:$PATH` added to `~/.bash_profile` on macOS) to facilitate running build scripts. System installations may already include a version of `qmake` (especially on Linux), so it is important to ensure that the new installation takes precedence over this by setting the PATH correctly.

## Building and Running

After checking out the project, the simplest way to build and run is through Qt Creator:

1. Open the project file, _SudokuSolver.pro_ in the project root.
2. Build the project.

## Deployment

Build scripts have been created for each platform that will produce either a standalone executable or installer:

-   **macOS:** Inside _build/macOS_, run the script `create_mac_app.command` to build the application and create a DMG file.
-   **Linux:** Inside _build/Linux_, run the script `create_linux_app` to build the application and create an [AppImage](https://appimage.org) file.
-   **Windows:** Inside _build/Windows_, run the script `create_windows_installer.bat` to build the application and create a Windows installer. This script uses the free [Inno Setup](http://www.jrsoftware.org/isinfo.php) for packaging on Windows, so this must be installed and made accessible in the PATH as a prerequisite for running this script.

