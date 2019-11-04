import QtQuick 2.12

Rectangle {
    width: 180
    height: width
    border.width: 4
    border.color: "black"

    property alias cell0Digit: cell0.digit
    property alias cell1Digit: cell1.digit
    property alias cell2Digit: cell2.digit
    property alias cell3Digit: cell3.digit
    property alias cell4Digit: cell4.digit
    property alias cell5Digit: cell5.digit
    property alias cell6Digit: cell6.digit
    property alias cell7Digit: cell7.digit
    property alias cell8Digit: cell8.digit

    Grid {
        anchors.centerIn: parent
        columns: 3
        rows: columns
        columnSpacing: -2
        rowSpacing: columnSpacing

        Cell { id: cell0 }
        Cell { id: cell1 }
        Cell { id: cell2 }
        Cell { id: cell3 }
        Cell { id: cell4 }
        Cell { id: cell5 }
        Cell { id: cell6 }
        Cell { id: cell7 }
        Cell { id: cell8 }
    }
}
