/**
 * @file solverengine.h
 * @brief Contains the functionality for the engine used to model and solve puzzles as well as controlling the view.
 * @author Ben Prisby <ben@benprisby.com>
 */

#ifndef SOLVERENGINE_H_
#define SOLVERENGINE_H_

#include <QObject>
#include <QQmlEngine>
#include <QVector>
#include <cmath>

/**
 * @brief The integer constant representing an unassigned value, i.e. a blank cell.
 */
static constexpr int UNASSIGNED_VALUE = -1;

/**
 * @brief Class containing all functionality required for modeling, solving, and managing puzzles.
 * @details The public API is used by the view to initate solving a puzzle entered by the user. This class therefore
 * exposes properties for driving the state of the QML view.
 */
class SolverEngine : public QObject
{
    Q_OBJECT

    /**
     * @brief The current state of the engine.
     * @see eEngineState_t
     * @see state()
     * @see stateChanged()
     */
    Q_PROPERTY( int state READ state NOTIFY stateChanged )

    /**
     * @brief The time taken by the engine to solve the last puzzle in seconds.
     * @see solveTime()
     * @see solveTimeChanged()
     */
    Q_PROPERTY( double solveTime READ solveTime NOTIFY solveTimeChanged )

public:
    /**
     * @brief Enum containing all possible states for the engine, accessible via QML.
     * @see state()
     */
    enum eEngineState_t
    {
        EngineState_Idle = 0, /*!< The engine is idle. */
        EngineState_Solving,  /*!< The engine is currently solving the puzzle. */
        EngineState_Finished, /*!< The engine has successfully solved the puzzle. */
        EngineState_Error     /*!< The engine encountered an error. */
    };
    Q_ENUM( eEngineState_t )

    /**
     * @brief Returns the Singleton instance associated with this engine.
     * @details This function calls the constructor to create a new instance if not already done.
     * @see SolverEngine()
     * @return The pointer to the Singleton instance.
     */
    static SolverEngine * instance();

    /**
     * @brief Getter function for the current state of the engine.
     * @see eEngineState_t
     * @see stateChanged()
     * @return The engine state.
     */
    eEngineState_t state() const { return m_eState; }

    /**
     * @brief Getter function for the time taken by the engine to solve the puzzle once completed.
     * @see solveTimeChanged()
     * @return The time taken in seconds.
     */
    double solveTime() const { return m_dSolveTime; }

signals:
    /**
     * @brief Signal emitted whenever the engine state changes.
     * @see state()
     */
    void stateChanged();

    /**
     * @brief Signal emitted whenever the time taken to solve the puzzle is announced.
     * @see solveTime()
     */
    void solveTimeChanged();

public slots:
    /**
     * @brief Commands the engine to start attempting a solution using the current state of the view.
     * @details This function resets the engine, loads the currently-displayed grid into the interal board and
     * conflicts models, and starts the solving process. If successful, the logged time taken to solve is stored and
     * published to the view. State transitions for the engine are also published along the way.
     * @see reset()
     */
    void solve();

    /**
     * @brief Clears any currently-loaded board and conflicts models.
     * @details After clearing all of the internal models, this fucntion reallocates each of them with default values
     * and sets the state of the engine to idle.
     * @see eEngineState_t
     */
    void reset();

private:
    /**
     * @brief Struct for holding a location on the board, consisting of a row and column position.
     */
    struct xLocation_t
    {
        /**
         * @brief Constructor to create a location given an optional row and column.
         * @param iRow The row of the location.
         * @param iColumn The column of the location.
         */
        xLocation_t( const int iRow = UNASSIGNED_VALUE, const int iColumn = UNASSIGNED_VALUE )
        {
            this->iRow = iRow;
            this->iColumn = iColumn;
        }

        /**
         * @brief The row of the location, possibly unassigned.
         */
        int iRow;

        /**
         * @brief The column of the location, possibly unassigned.
         */
        int iColumn;
    };

    /**
     * @brief Constructor for the engine, responsible for initializing classing members.
     * @param pParent The parent of the engine.
     */
    explicit SolverEngine( QObject * pParent = nullptr ) :
        QObject( pParent ), m_eState { EngineState_Idle }, m_dSolveTime { std::nan( "" ) }, m_xStartLocation( 0, 0 )
    {}

    /**
     * @brief Writes out the current internal board model to the QML view to display it to the user.
     */
    void updateScreen();

    /**
     * @brief Core function for solving the puzzle using the currently-loaded internal board model.
     * @return True if the puzzle has been solved, false if not.
     */
    bool solveBoard();

    /**
     * @brief Finds the next blank cell that is a candidate for value insertion.
     * @details The search starts at the optional starting position. This does not wrap back to the beginning if the
     * starting position is not the top-left of the board.
     * @param xStartLocation Optional starting position, defaulting to the top-left of the board.
     * @see xLocation_t
     * @return The next blank location or an unassigned location if the board is full.
     */
    xLocation_t nextBlankCell( const xLocation_t & xStartLocation = xLocation_t( 0, 0 ) ) const;

    /**
     * @brief Consults the current conflicts, returning whether or not the proposed value placement is acceptable.
     * @details This function looks at the current row, column, and square conflicts to make a determination.
     * @param xLocation The desired location at which to place the value.
     * @param iValue The proposed value.
     * @see xLocation_t
     * @return True if there are no known conflicts with the proposed location and value, false otherwise.
     */
    bool canPlaceValue( const xLocation_t & xLocation, int iValue ) const;

    /**
     * @brief Returns the square number containing the passed location on the board.
     * @details Squares are numbered from left-to-right, top-to-bottom starting at 0 (top-left).
     * @param xLocation The cell location.
     * @see xLocation_t
     * @return The square number containing the cell.
     */
    int squareNumberFromLocation( const xLocation_t & xLocation ) const;

    /**
     * @brief The internal representation of the board.
     * @details The model is a 2D vector (row by column) holding the value at each cell.
     */
    QVector<QVector<int> > m_BoardModel;

    /**
     * @brief The currently-known row conflicts, which are arranged as a 2D vector.
     * @details The outer vector represents the row while the inner vector represents whether or not a conflict exists
     * for the value. Here, the index is the value, so the item at index 0 of the inner vector is not used.
     */
    QVector<QVector<bool> > m_RowConflicts;

    /**
     * @brief Similar to the row conflicts, but the outer vector represents the column.
     * @see m_RowConflicts
     */
    QVector<QVector<bool> > m_ColumnConflicts;

    /**
     * @brief Similar to the row and column conflicts, but the outer vector represents the square number.
     * @see m_RowConflicts
     * @see m_ColumnConflicts
     * @see squareNumberFromLocation()
     */
    QVector<QVector<bool> > m_SquareConflicts;

    /**
     * @brief Internal variable for holding the current state of the engine.
     * @see eEngineState_t
     * @see state()
     */
    eEngineState_t m_eState;

    /**
     * @brief Internal variable for holding the time taken to solve the last puzzle in seconds.
     * @see solveTime()
     */
    double m_dSolveTime;

    /**
     * @brief The starting position to use when searching for the next blank cell.
     * @details After a value is placed, it becomes the next starting location.
     * @see xLocation_t
     */
    xLocation_t m_xStartLocation;
};

/**
 * @brief Provides the Singleton instance pointer for use within the QML context.
 * @param pEngine The QML engine where the view is loaded.
 * @param pScriptEngine The JavaScript engine associated with the view.
 * @see SolverEngine::instance()
 * @return The Singleton instance pointer to this engine.
 */
QObject * solverengine_singletontype_provider( QQmlEngine * pEngine, QJSEngine * pScriptEngine );

#endif  // SOLVERENGINE_H_
