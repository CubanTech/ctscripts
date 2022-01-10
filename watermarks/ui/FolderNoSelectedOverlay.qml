import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.12

Item {
    id: root

    property Transition enter: Transition {
        // grow_fade_in
        to: "open"
        NumberAnimation { target: rectangleOverlay; property: "scale"; from: 0.9; to: 1.0; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { target: rectangleOverlay; property: "opacity"; from: 0.0; to: 0.75; easing.type: Easing.OutCubic; duration: 150 }
    }

    property Transition exit: Transition {
        // shrink_fade_out
        to: ""
        NumberAnimation { target: rectangleOverlay; property: "scale"; from: 1.0; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
        NumberAnimation { target: rectangleOverlay; property: "opacity"; from: 0.75; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
    }

    function open() {
        state = "open"
    }

    function close() {
        toolTipShowImage.showToolTip()
        state = ""
    }

    function canClose() {
        return imagesManager.imagesTotalCount !== 0 && imagesManager.validOutputDir && imagesManager.validWatermarkImage
    }

    states: [
        State {
            name: "open"
        }
    ]
    transitions: [enter, exit]

    visible: rectangleOverlay.opacity > 0

    Rectangle {
        id: rectangleOverlay
        anchors.fill: parent

        Material.theme: Material.Light
        color: Material.theme === Material.Light ? "#DD000000" : "#DDFFFFFF"
        opacity: 0.0
    }


    Image {
        id: imageFolderCircle
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -100
        source: "qrc:/images/icons/folder-circle.svg"
        sourceSize: "128x128"
    }

    Image {
        id: imageFolderMark
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -100
        source: "qrc:/images/icons/folder-mark.svg"
        sourceSize: "64x64"
    }

    ParallelAnimation {
        running: root.visible
        SequentialAnimation {
            loops: Animation.Infinite

            NumberAnimation { target: imageFolderCircle; property: "scale"; duration: 700; to: 1.2; easing.type: Easing.InCirc }
            NumberAnimation { target: imageFolderCircle; property: "scale"; duration: 700; to: 1.0; easing.type: Easing.OutCirc }
        }
        SequentialAnimation {
            loops: Animation.Infinite

            NumberAnimation { target: imageFolderMark; property: "scale"; duration: 700; to: 1.2; easing.type: Easing.InOutBack }
            NumberAnimation { target: imageFolderMark; property: "scale"; duration: 700; to: 1.0; easing.type: Easing.OutCirc }
        }
    }


    Label {
        id: subMessage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 20
        Material.theme: parent.Material.theme === Material.Light ? Material.Dark : Material.Light
        text: qsTr("Configure:")
        font.pointSize: Qt.application.font.pointSize * 2
        font.bold: true
        font.italic: true
        color: 'white'

        SequentialAnimation on opacity {
            running: root.visible
            loops: Animation.Infinite
            NumberAnimation { duration: 200; to: 0.0 }
            NumberAnimation { duration: 200; to: 1.0 }
            PauseAnimation { duration: 1000 }
        }
    }

    ColumnLayout {
        anchors.top: subMessage.bottom
        anchors.topMargin: 10
        anchors.left: subMessage.left
        anchors.leftMargin: -subMessage.width/2
        Label {
            text: qsTr("· Input folder with images")
            font.pointSize: Qt.application.font.pointSize * 1.5
            font.bold: true
            color: 'white'
            visible: imagesManager.imagesTotalCount === 0
        }
        Label {
            text: qsTr("· Output folder")
            font.pointSize: Qt.application.font.pointSize * 1.5
            font.bold: true
            color: 'white'
            visible: !imagesManager.validOutputDir
        }
        Label {
            text: qsTr("· Watermark image")
            font.pointSize: Qt.application.font.pointSize * 1.5
            font.bold: true
            color: 'white'
            visible: !imagesManager.validWatermarkImage
        }
    }

    // Need this to block mouse event (they pass through the rectangle)
    MouseArea {
        anchors.fill: parent
        visible: root.visible
        hoverEnabled: true
    }
}
