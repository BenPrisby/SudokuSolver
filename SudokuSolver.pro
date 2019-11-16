QT += quick

CONFIG += c++11

CONFIG(release, debug|release):CONFIG += qtquickcompiler

DEFINES += QT_DEPRECATED_WARNINGS

# Treat warnings as errors.
QMAKE_CXXFLAGS += -Werror

!defined(VERSION,var):{ VERSION=1.0.0 }

SOURCES += \
        src/main.cpp \
        src/solverengine.cpp

INCLUDEPATH += src

HEADERS += \
    src/solverengine.h

RESOURCES += qml/qml.qrc \
    resources/resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH = qml

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# macOS icon for app bundling.
macx: { QMAKE_INFO_PLIST = resources/Info.plist }
macx: { ICON = resources/icon_apple.icns }

# Windows app info file.
win32: { RC_FILE = resources/myapp.rc }
