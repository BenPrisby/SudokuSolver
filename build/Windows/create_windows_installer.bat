@echo off
rem DESCRIPTION: Creates a Windows installer using Inno Setup.
rem PARAMETERS: Version - optional

rem Set the following paths according to your system.
set MINGW=C:\Qt\Tools\mingw730_64\bin
set QT=C:\Qt\5.12.6\mingw73_64\bin
set INNO="C:\Program Files (x86)\Inno Setup 6"

set PATH=%MINGW%;%QT%;%INNO%;%PATH%

rem Check if the above paths exist before proceeding.
if not exist %MINGW%\ (
    echo Failed to find the configured MinGW directory. Please verify that the path in this script is correct and try again.
    exit /b 1
)
if not exist %QT%\ (
    echo Failed to find the configured Qt directory. Please verify that the path in this script is correct and try again.
    exit /b 1
)
if not exist %INNO%\ (
    echo Failed to find the configured Inno Setup directory. Please verify that the path in this script is correct and try again.
    exit /b 1
)

rem Move to the current working directory.
cd /D "%~dp0"

rem Check if a version was specified.
if [%1] == [] goto default_version
set VERSION=%1
echo Supplying version %VERSION%...
goto exit_version
:default_version
set VERSION=1.0.0
echo No version specified, so using %VERSION%...
:exit_version

rem Execute the build.
pushd .
if exist ..\..\build_tmp rmdir /s /q ..\..\build_tmp
mkdir ..\..\build_tmp
cd ..\..\build_tmp
qmake -config release "VERSION=%VERSION%" ..\SudokuSolver.pro
mingw32-make -j4 release
popd

rem Prepare the installer data directory.
if exist data\ rmdir /s /q data\
mkdir data\

rem Copy the application into the package.
copy /Y ..\..\build_tmp\release\SudokuSolver.exe "data\Sudoku Solver.exe"

rem Deploy runtime dependencies.
pushd .
cd data
windeployqt --release --compiler-runtime --verbose 2 --qmldir "%QT%\..\qml" -opengl "Sudoku Solver.exe"
popd

rem Insert the version into the install scripts.
pushd .
cd tools
call patch_install_script.bat

rem Create the installer.
iscc install_script.iss
popd

rem Clean up.
rmdir /s /q ..\..\build_tmp
rmdir /s /q data
