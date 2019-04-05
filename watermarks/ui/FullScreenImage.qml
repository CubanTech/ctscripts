import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

Window {
    id: root

    property alias position: image.position

    title: Qt.application.name + ' ' + currentImage

    ToolButton {
        id: toolButtonExit
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        text: qsTr("Exit")
        font.bold: true
        icon.source: "qrc:/images/icons/close.svg"
        icon.color: "transparent"
        z: 1

        onClicked: close()
    }

    Flickable {
        id: scrollView
        anchors.fill: parent
        anchors.topMargin: toolButtonExit.height
        contentWidth: imagesManager.imageWidth
        contentHeight: imagesManager.imageHeight
        clip: true

        Item {
            anchors.fill: parent

            ImageWatermarked {
                id: image
                anchors.centerIn: parent
                horizontalPadding: sliderHorizontalPadding.value
                verticalPadding: sliderVerticalPadding.value
                scaleWatermark: false // keep original size
                enabled: false
                source: imagesManager.imagesTotalCount > 0 ? currentImage : ""
                watermarkSource: imagesManager.validWatermarkImage > 0 ? watermarkImage : ""
            }
        }
    } // Flickable
}
