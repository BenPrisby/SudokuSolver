import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

import com.benprisby.sudokusolver.solverengine 1.0

Window {
    visible: true
    minimumWidth: 640
    minimumHeight: 860
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight
    title: qsTr( "Sudoku Solver" )

    Text {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 32
        font.bold: true
        text: qsTr( "Sudoku Solver" )
    }

    Text {
        id: instructions
        anchors.top: title.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        text: {
            switch ( SolverEngine.state )
            {
            case SolverEngine.EngineState_Finished:
                color = "#34c759";
                return qsTr( "Solved in " + SolverEngine.solveTime.toFixed( 3 ) + "s." );

            case SolverEngine.EngineState_Error:
                color = "#ff3a30";
                return qsTr( "Invalid input puzzle. Please try again." );

            default:
                color = "black";
                return qsTr( "Enter the puzzle to solve below." );
            }
        }
    }

    Grid {
        id: board
        objectName: "board"
        anchors.top: instructions.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        columns: 3
        rows: columns
        columnSpacing: -2
        rowSpacing: columnSpacing

        property alias row0Column0Digit: square0.cell0Digit
        property alias row0Column1Digit: square0.cell1Digit
        property alias row0Column2Digit: square0.cell2Digit
        property alias row0Column3Digit: square1.cell0Digit
        property alias row0Column4Digit: square1.cell1Digit
        property alias row0Column5Digit: square1.cell2Digit
        property alias row0Column6Digit: square2.cell0Digit
        property alias row0Column7Digit: square2.cell1Digit
        property alias row0Column8Digit: square2.cell2Digit

        property alias row1Column0Digit: square0.cell3Digit
        property alias row1Column1Digit: square0.cell4Digit
        property alias row1Column2Digit: square0.cell5Digit
        property alias row1Column3Digit: square1.cell3Digit
        property alias row1Column4Digit: square1.cell4Digit
        property alias row1Column5Digit: square1.cell5Digit
        property alias row1Column6Digit: square2.cell3Digit
        property alias row1Column7Digit: square2.cell4Digit
        property alias row1Column8Digit: square2.cell5Digit

        property alias row2Column0Digit: square0.cell6Digit
        property alias row2Column1Digit: square0.cell7Digit
        property alias row2Column2Digit: square0.cell8Digit
        property alias row2Column3Digit: square1.cell6Digit
        property alias row2Column4Digit: square1.cell7Digit
        property alias row2Column5Digit: square1.cell8Digit
        property alias row2Column6Digit: square2.cell6Digit
        property alias row2Column7Digit: square2.cell7Digit
        property alias row2Column8Digit: square2.cell8Digit

        property alias row3Column0Digit: square3.cell0Digit
        property alias row3Column1Digit: square3.cell1Digit
        property alias row3Column2Digit: square3.cell2Digit
        property alias row3Column3Digit: square4.cell0Digit
        property alias row3Column4Digit: square4.cell1Digit
        property alias row3Column5Digit: square4.cell2Digit
        property alias row3Column6Digit: square5.cell0Digit
        property alias row3Column7Digit: square5.cell1Digit
        property alias row3Column8Digit: square5.cell2Digit

        property alias row4Column0Digit: square3.cell3Digit
        property alias row4Column1Digit: square3.cell4Digit
        property alias row4Column2Digit: square3.cell5Digit
        property alias row4Column3Digit: square4.cell3Digit
        property alias row4Column4Digit: square4.cell4Digit
        property alias row4Column5Digit: square4.cell5Digit
        property alias row4Column6Digit: square5.cell3Digit
        property alias row4Column7Digit: square5.cell4Digit
        property alias row4Column8Digit: square5.cell5Digit

        property alias row5Column0Digit: square3.cell6Digit
        property alias row5Column1Digit: square3.cell7Digit
        property alias row5Column2Digit: square3.cell8Digit
        property alias row5Column3Digit: square4.cell6Digit
        property alias row5Column4Digit: square4.cell7Digit
        property alias row5Column5Digit: square4.cell8Digit
        property alias row5Column6Digit: square5.cell6Digit
        property alias row5Column7Digit: square5.cell7Digit
        property alias row5Column8Digit: square5.cell8Digit

        property alias row6Column0Digit: square6.cell0Digit
        property alias row6Column1Digit: square6.cell1Digit
        property alias row6Column2Digit: square6.cell2Digit
        property alias row6Column3Digit: square7.cell0Digit
        property alias row6Column4Digit: square7.cell1Digit
        property alias row6Column5Digit: square7.cell2Digit
        property alias row6Column6Digit: square8.cell0Digit
        property alias row6Column7Digit: square8.cell1Digit
        property alias row6Column8Digit: square8.cell2Digit

        property alias row7Column0Digit: square6.cell3Digit
        property alias row7Column1Digit: square6.cell4Digit
        property alias row7Column2Digit: square6.cell5Digit
        property alias row7Column3Digit: square7.cell3Digit
        property alias row7Column4Digit: square7.cell4Digit
        property alias row7Column5Digit: square7.cell5Digit
        property alias row7Column6Digit: square8.cell3Digit
        property alias row7Column7Digit: square8.cell4Digit
        property alias row7Column8Digit: square8.cell5Digit

        property alias row8Column0Digit: square6.cell6Digit
        property alias row8Column1Digit: square6.cell7Digit
        property alias row8Column2Digit: square6.cell8Digit
        property alias row8Column3Digit: square7.cell6Digit
        property alias row8Column4Digit: square7.cell7Digit
        property alias row8Column5Digit: square7.cell8Digit
        property alias row8Column6Digit: square8.cell6Digit
        property alias row8Column7Digit: square8.cell7Digit
        property alias row8Column8Digit: square8.cell8Digit

        Square { id: square0 }
        Square { id: square1 }
        Square { id: square2 }
        Square { id: square3 }
        Square { id: square4 }
        Square { id: square5 }
        Square { id: square6 }
        Square { id: square7 }
        Square { id: square8 }
    }

    Button {
        id: actionButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 75
        text: {
            switch ( SolverEngine.state )
            {
            case SolverEngine.EngineState_Idle:
            case SolverEngine.EngineState_Error:
                return qsTr( "Solve" );

            case SolverEngine.EngineState_Solving:
                return qsTr( "Solving..." );

            default:
                return qsTr( "Reset" );
            }
        }

        contentItem: Text {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: "white"
            text: actionButton.text
            font.pixelSize: 24
            font.bold: true
        }

        background: Rectangle {
            color: actionButton.down ? "#0063cc" : "#007bff"
            radius: 6
        }

        onClicked: {
            if ( ( SolverEngine.EngineState_Idle == SolverEngine.state )
                    || ( SolverEngine.EngineState_Error == SolverEngine.state ) )
            {
                SolverEngine.solve();
            }
            else if ( SolverEngine.EngineState_Finished == SolverEngine.state )
            {
                SolverEngine.reset();

                board.row0Column0Digit = "";
                board.row0Column1Digit = "";
                board.row0Column2Digit = "";
                board.row0Column3Digit = "";
                board.row0Column4Digit = "";
                board.row0Column5Digit = "";
                board.row0Column6Digit = "";
                board.row0Column7Digit = "";
                board.row0Column8Digit = "";

                board.row1Column0Digit = "";
                board.row1Column1Digit = "";
                board.row1Column2Digit = "";
                board.row1Column3Digit = "";
                board.row1Column4Digit = "";
                board.row1Column5Digit = "";
                board.row1Column6Digit = "";
                board.row1Column7Digit = "";
                board.row1Column8Digit = "";

                board.row2Column0Digit = "";
                board.row2Column1Digit = "";
                board.row2Column2Digit = "";
                board.row2Column3Digit = "";
                board.row2Column4Digit = "";
                board.row2Column5Digit = "";
                board.row2Column6Digit = "";
                board.row2Column7Digit = "";
                board.row2Column8Digit = "";

                board.row3Column0Digit = "";
                board.row3Column1Digit = "";
                board.row3Column2Digit = "";
                board.row3Column3Digit = "";
                board.row3Column4Digit = "";
                board.row3Column5Digit = "";
                board.row3Column6Digit = "";
                board.row3Column7Digit = "";
                board.row3Column8Digit = "";

                board.row4Column0Digit = "";
                board.row4Column1Digit = "";
                board.row4Column2Digit = "";
                board.row4Column3Digit = "";
                board.row4Column4Digit = "";
                board.row4Column5Digit = "";
                board.row4Column6Digit = "";
                board.row4Column7Digit = "";
                board.row4Column8Digit = "";

                board.row5Column0Digit = "";
                board.row5Column1Digit = "";
                board.row5Column2Digit = "";
                board.row5Column3Digit = "";
                board.row5Column4Digit = "";
                board.row5Column5Digit = "";
                board.row5Column6Digit = "";
                board.row5Column7Digit = "";
                board.row5Column8Digit = "";

                board.row6Column0Digit = "";
                board.row6Column1Digit = "";
                board.row6Column2Digit = "";
                board.row6Column3Digit = "";
                board.row6Column4Digit = "";
                board.row6Column5Digit = "";
                board.row6Column6Digit = "";
                board.row6Column7Digit = "";
                board.row6Column8Digit = "";

                board.row7Column0Digit = "";
                board.row7Column1Digit = "";
                board.row7Column2Digit = "";
                board.row7Column3Digit = "";
                board.row7Column4Digit = "";
                board.row7Column5Digit = "";
                board.row7Column6Digit = "";
                board.row7Column7Digit = "";
                board.row7Column8Digit = "";

                board.row8Column0Digit = "";
                board.row8Column1Digit = "";
                board.row8Column2Digit = "";
                board.row8Column3Digit = "";
                board.row8Column4Digit = "";
                board.row8Column5Digit = "";
                board.row8Column6Digit = "";
                board.row8Column7Digit = "";
                board.row8Column8Digit = "";
            }
            else
            {
                // Still working on the solution, do nothing.
            }
        }
    }

    Text {
        id: solveTimeText
        anchors.bottom: parent.bottom
    }
}
