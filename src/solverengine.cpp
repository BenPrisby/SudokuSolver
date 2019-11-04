/**
 * @file solverengine.cpp
 * @brief Source file for the engine class.
 * @author Ben Prisby <ben@benprisby.com>
 */

#include "solverengine.h"

#include <QCoreApplication>
#include <QDateTime>
#include <QDebug>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtMath>
/*--------------------------------------------------------------------------------------------------------------------*/

/**
 * @brief The QML engine where the view will be loaded.
 */
extern QQmlApplicationEngine * pEngine;
/*--------------------------------------------------------------------------------------------------------------------*/

static SolverEngine * g_pInstance = nullptr;
static constexpr int BOARD_LENGTH = 9;
/*--------------------------------------------------------------------------------------------------------------------*/

SolverEngine * SolverEngine::instance()
{
    if ( nullptr == g_pInstance )
    {
        g_pInstance = new SolverEngine();
    }

    return g_pInstance;
}
/*--------------------------------------------------------------------------------------------------------------------*/

void SolverEngine::solve()
{
    auto * pBoard = pEngine->rootObjects().first()->findChild<QObject *>( "board" );

    // Clear out any existing data and reset the model.
    reset();

    if ( nullptr != pBoard )
    {
        // Signal to the view that we are starting.
        m_eState = EngineState_Solving;
        emit stateChanged();

        // Build the board model.
        for ( int i = 0; i < BOARD_LENGTH; i++ )
        {
            for ( int j = 0; j < BOARD_LENGTH; j++ )
            {
                // QML property names follow the same indexing scheme.
                QString PropertyName = "row" + QString::number( i ) + "Column" + QString::number( j ) + "Digit";
                QString Value = pBoard->property( PropertyName.toStdString().c_str() ).toString();

                if ( !Value.isEmpty() )
                {
                    int iValue = Value.toInt();

                    // Verify that the input is valid.
                    if ( canPlaceValue( xLocation_t( i, j ), iValue ) )
                    {
                        m_BoardModel[ i ][ j ] = iValue;

                        // Track the conflict.
                        m_RowConflicts[ i ][ iValue ] = true;
                        m_ColumnConflicts[ j ][ iValue ] = true;
                        m_SquareConflicts[ squareNumberFromLocation( xLocation_t( i, j ) ) ][ iValue ] = true;
                    }
                    else
                    {
                        // Invalid input.
                        m_eState = EngineState_Error;
                        emit stateChanged();
                        i = BOARD_LENGTH;  // Break out of the nested loop
                        break;
                    }
                }
                else
                {
                    m_BoardModel[ i ][ j ] = UNASSIGNED_VALUE;
                }
            }
        }

        if ( EngineState_Error != m_eState )
        {
            // Log the start time to track how long solving takes.
            QDateTime StartTime = QDateTime::currentDateTimeUtc();

            // Solve it!
            if ( solveBoard() )
            {
                QDateTime EndTime = QDateTime::currentDateTimeUtc();

                m_dSolveTime = StartTime.msecsTo( EndTime ) / 1000.0;
                emit solveTimeChanged();

                // Pass out the state change to the view.
                m_eState = EngineState_Finished;
                emit stateChanged();
            }
            else
            {
                // Failed to solve.
                m_eState = EngineState_Error;
                emit stateChanged();
            }
        }
    }
    else
    {
        // Failed to get the board context from the QML engine.
        m_eState = EngineState_Error;
        emit stateChanged();
    }
}
/*--------------------------------------------------------------------------------------------------------------------*/

void SolverEngine::reset()
{
    // Reset any known internal models.
    m_BoardModel.clear();
    m_RowConflicts.clear();
    m_ColumnConflicts.clear();
    m_SquareConflicts.clear();
    m_xStartLocation.iRow = 0;
    m_xStartLocation.iColumn = 0;

    for ( int i = 0; i < BOARD_LENGTH; i++ )
    {
        // Allocate space to store the row contents.
        m_BoardModel.push_back( QVector<int>( BOARD_LENGTH, UNASSIGNED_VALUE ) );

        // Also create the vectors for holding conflicts, which have an extra item so that access can be value-based
        // instead of subtracting 1 every time.
        m_RowConflicts.push_back( QVector<bool>( BOARD_LENGTH + 1, false ) );
        m_ColumnConflicts.push_back( QVector<bool>( BOARD_LENGTH + 1, false ) );
        m_SquareConflicts.push_back( QVector<bool>( BOARD_LENGTH + 1, false ) );
    }

    m_eState = EngineState_Idle;
    emit stateChanged();
}
/*--------------------------------------------------------------------------------------------------------------------*/

void SolverEngine::updateScreen()
{
    auto * pBoard = pEngine->rootObjects().first()->findChild<QObject *>( "board" );

    if ( nullptr != pBoard )
    {
        // Write out the model to the screen.
        for ( int i = 0; i < BOARD_LENGTH; i++ )
        {
            for ( int j = 0; j < BOARD_LENGTH; j++ )
            {
                QString PropertyName = "row" + QString::number( i ) + "Column" + QString::number( j ) + "Digit";
                int iValue = m_BoardModel[ i ][ j ];

                pBoard->setProperty( PropertyName.toStdString().c_str(),
                                     ( UNASSIGNED_VALUE != iValue ) ? QVariant( iValue ) : QVariant( "" ) );
            }
        }
    }
}
/*--------------------------------------------------------------------------------------------------------------------*/

bool SolverEngine::solveBoard()
{
    const xLocation_t & NextLocation = nextBlankCell( m_xStartLocation );
    bool bReturn = false;

    // Base case: everything filled with a valid value.
    if ( ( UNASSIGNED_VALUE == NextLocation.iRow ) && ( UNASSIGNED_VALUE == NextLocation.iColumn ) )
    {
        updateScreen();
        bReturn = true;
    }
    else
    {
        for ( int iProposedValue = 1; iProposedValue <= BOARD_LENGTH; iProposedValue++ )
        {
            if ( canPlaceValue( NextLocation, iProposedValue ) )
            {
                // Recurse: place another value.
                m_BoardModel[ NextLocation.iRow ][ NextLocation.iColumn ] = iProposedValue;
                m_RowConflicts[ NextLocation.iRow ][ iProposedValue ] = true;
                m_ColumnConflicts[ NextLocation.iColumn ][ iProposedValue ] = true;
                m_SquareConflicts[ squareNumberFromLocation( NextLocation ) ][ iProposedValue ] = true;
                m_xStartLocation = NextLocation;  // Start looking for the next blank cell here next time

                if ( solveBoard() )
                {
                    bReturn = true;
                    break;
                }

                // Backtrack: clear the cell to try a different value.
                m_BoardModel[ NextLocation.iRow ][ NextLocation.iColumn ] = UNASSIGNED_VALUE;
                m_RowConflicts[ NextLocation.iRow ][ iProposedValue ] = false;
                m_ColumnConflicts[ NextLocation.iColumn ][ iProposedValue ] = false;
                m_SquareConflicts[ squareNumberFromLocation( NextLocation ) ][ iProposedValue ] = false;
            }
        }
    }

    return bReturn;
}
/*--------------------------------------------------------------------------------------------------------------------*/

SolverEngine::xLocation_t SolverEngine::nextBlankCell( const xLocation_t & xStartLocation ) const
{
    xLocation_t Return;

    // Find the next blank cell, respecting the start position.
    for ( int i = xStartLocation.iRow; i < BOARD_LENGTH; i++ )
    {
        // Skip to the interesting column if this is the starting row, otherwise look at the whole row.
        for ( int j = ( xStartLocation.iRow == i ) ? xStartLocation.iColumn : 0; j < BOARD_LENGTH; j++ )
        {
            if ( UNASSIGNED_VALUE == m_BoardModel.at( i ).at( j ) )
            {
                Return.iRow = i;
                Return.iColumn = j;
                i = BOARD_LENGTH;  // Break out of the nested loop
                break;
            }
        }
    }

    return Return;
}
/*--------------------------------------------------------------------------------------------------------------------*/

bool SolverEngine::canPlaceValue( const xLocation_t & xLocation, const int iValue ) const
{
    bool bConflict = false;

    if ( m_RowConflicts[ xLocation.iRow ][ iValue ] )
    {
        // Already in the row.
        bConflict = true;
    }
    else if ( m_ColumnConflicts[ xLocation.iColumn ][ iValue ] )
    {
        // Already in the column.
        bConflict = true;
    }
    else if ( m_SquareConflicts[ squareNumberFromLocation( xLocation ) ][ iValue ] )
    {
        // Already in the square.
        bConflict = true;
    }

    return !bConflict;
}
/*--------------------------------------------------------------------------------------------------------------------*/

int SolverEngine::squareNumberFromLocation( const xLocation_t & xLocation ) const
{
    // Squares are 0-8 starting from the top-left and incrementing across rows.
    const int iX = qFloor( static_cast<qreal>( xLocation.iRow ) / 3 );
    const int iY = qFloor( static_cast<qreal>( xLocation.iColumn ) / 3 );

    return ( iX * 3 ) + iY;
}
/*--------------------------------------------------------------------------------------------------------------------*/

QObject * solverengine_singletontype_provider( QQmlEngine * pEngine, QJSEngine * pScriptEngine )
{
    ( void )pEngine;
    ( void )pScriptEngine;

    return SolverEngine::instance();
}
/*--------------------------------------------------------------------------------------------------------------------*/
