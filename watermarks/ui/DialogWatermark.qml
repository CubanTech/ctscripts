import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: root
    title: qsTr("Watermark")

    RowLayout {
        anchors.fill: parent
        TextField {
            id: textFieldWatermark
            placeholderText: qsTr("Watermark")
            text: imagesManager.watermarkFilepath
            readOnly: true
            focus: true
            selectByMouse: true
            Layout.fillWidth: true
            Layout.preferredWidth: rootAppWindow.width * 0.8

            onTextChanged: {
                imagesManager.watermarkFilepath = text
            }
        }
        ToolButton {
            id: toolButtonSelectInputFolder
            icon.source: "qrc:/images/icons/folder.svg"

            onClicked: {
                var dirpath = imagesManager.selectFile(imagesManager.watermarkFilepath)
                if (dirpath !== "") {
                    textFieldWatermark.text = dirpath
                }
                if (unconfiguredBlocker.canClose()) {
                    unconfiguredBlocker.close()
                } else {
                    unconfiguredBlocker.open()
                }
            }
        }
    } // RowLayout
}
