import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.12

Popup {
    id: root

    //    closePolicy: Popup.NoAutoClose
    Material.theme: Material.Light

    background: Rectangle {
        radius: 2
        color: "transparent"
    }

    T.Overlay.modal: Rectangle {
        color: Material.theme === Material.Light ? "#DD000000" : "#DDFFFFFF"
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    T.Overlay.modeless: Rectangle {
        color: Material.theme === Material.Light ? "#DD000000" : "#DDFFFFFF"
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    Image {
        id: imageCheckCircle
        anchors.centerIn: parent
        source: "qrc:/images/icons/check-circle.svg"
        sourceSize: "128x128"
    }

    Image {
        id: imageCheckMark
        anchors.centerIn: parent
        source: "qrc:/images/icons/check-mark.svg"
        sourceSize: "128x128"
    }

    ParallelAnimation {
        running: root.visible
        SequentialAnimation {
            loops: Animation.Infinite

            NumberAnimation { target: imageCheckCircle; property: "scale"; duration: 700; to: 1.2; easing.type: Easing.InCirc }
            NumberAnimation { target: imageCheckCircle; property: "scale"; duration: 700; to: 1.0; easing.type: Easing.OutCirc }
        }
        SequentialAnimation {
            loops: Animation.Infinite

            NumberAnimation { target: imageCheckMark; property: "scale"; duration: 700; to: 1.2; easing.type: Easing.InOutBack }
            NumberAnimation { target: imageCheckMark; property: "scale"; duration: 700; to: 1.0; easing.type: Easing.OutCirc }
        }
    }


    Label {
        id: subMessage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 120
        Material.theme: parent.Material.theme === Material.Light ? Material.Dark : Material.Light
        text: qsTr("Success!")
        font.pointSize: Qt.application.font.pointSize * 2
        font.bold: true
        font.italic: true
        color: 'white'

        SequentialAnimation on opacity {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { duration: 120; to: 0.0 }
            NumberAnimation { duration: 120; to: 1.0 }
            PauseAnimation { duration: 110 }
        }
    }
}
