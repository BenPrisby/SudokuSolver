/**
 * @file main.cpp
 * @brief Source file containing the main entry point for the application.
 * @author Ben Prisby <ben@benprisby.com>
 */

#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "solverengine.h"
/*--------------------------------------------------------------------------------------------------------------------*/

extern QQmlApplicationEngine * pEngine;
/*--------------------------------------------------------------------------------------------------------------------*/

/**
 * The QML engine where the view will be loaded.
 */
QQmlApplicationEngine * pEngine = nullptr;
/*--------------------------------------------------------------------------------------------------------------------*/

/**
 * Entry point for the application, responsible for setting up the engine and QML view before running the application.
 *
 * @param argc The number of arguments, used for creation of the application.
 * @param argv The arguments, used for creation of the application.
 * @return The return code from executing the application.
 */
int main( int argc, char * argv[] )
{
    QCoreApplication::setAttribute( Qt::AA_EnableHighDpiScaling );

    QGuiApplication App( argc, argv );

    // Add the custom fonts.
    QFontDatabase::addApplicationFont( ":/Lato-Regular.ttf" );
    QFontDatabase::addApplicationFont( ":/Lato-Bold.ttf" );
    QGuiApplication::setFont( QFont( "Lato" ) );

    // Register the solver engine to expose it to QML.
    qmlRegisterSingletonType<SolverEngine>(
        "com.benprisby.sudokusolver.solverengine", 1, 0, "SolverEngine", solverengine_singletontype_provider );

    // Create the QML context.
    QQmlApplicationEngine Engine;
    const QUrl Url( QStringLiteral( "qrc:/main.qml" ) );
    QObject::connect(
        &Engine,
        &QQmlApplicationEngine::objectCreated,
        &App,
        [Url]( QObject * pObject, const QUrl & ObjectUrl ) {
            if ( !pObject && Url == ObjectUrl )
            {
                QCoreApplication::exit( -1 );
            }
        },
        Qt::QueuedConnection );
    Engine.load( Url );
    pEngine = &Engine;

    return QGuiApplication::exec();
}
/*--------------------------------------------------------------------------------------------------------------------*/
