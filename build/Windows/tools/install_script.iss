; -- install_script.iss --
; Inno Setup install script for the Sudoku Solver.

[Setup]
AppName=Sudoku Solver
AppPublisher=Ben Prisby
AppPublisherURL=https://benprisby.com
AppVersion=0.0.0
DefaultDirName={pf}\Ben Prisby\Sudoku Solver
; Since no icons will be created in "{group}", we don't need the wizard
; to ask for a Start Menu folder name:
DisableProgramGroupPage=yes
UninstallDisplayName=Sudoku Solver
UninstallDisplayIcon={app}\Sudoku Solver.exe
Compression=lzma2
SolidCompression=yes
OutputDir=..
OutputBaseFilename=Sudoku_Solver_{#SetupSetting("AppVersion")}

[InstallDelete]
; Purge the install directory.
Type: filesandordirs; Name: {app}\*

[Files]
Source: "..\data\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{commonprograms}\Sudoku Solver"; Filename: "{app}\Sudoku Solver.exe"
Name: "{commondesktop}\Sudoku Solver"; Filename: "{app}\Sudoku Solver.exe"

[Run]
Filename: {app}\Sudoku Solver.exe; Description: Launch Sudoku Solver; Flags: postinstall nowait skipifsilent
