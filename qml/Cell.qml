import QtQuick 2.12
import QtQuick.Controls 2.5

import com.benprisby.sudokusolver.solverengine 1.0

Item {
    id: cell
    width: 60
    height: width

    property alias digit: digitEntry.text

    TextField {
        id: digitEntry
        anchors.centerIn: parent
        font.pixelSize: 32
        validator: digitsValidator
        width: parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        selectByMouse: false
        readOnly: ( SolverEngine.EngineState_Idle != SolverEngine.state )
                  && ( SolverEngine.EngineState_Error != SolverEngine.state )
        background: Rectangle {
            color: "white"
            border.width: 1
            border.color: "black"
        }

        IntValidator {
            id: digitsValidator
            bottom: 0
            top: 9
        }
    }
}
