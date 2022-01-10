import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Dialog {
    id: root
    title: qsTr("Folders")

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            TextField {
                id: textFieldInputFolder
                placeholderText: qsTr("Input folder")
                text: imagesManager.inputDirpath
                readOnly: true
                selectByMouse: true
                focus: true
                Layout.fillWidth: true
                Layout.preferredWidth: rootAppWindow.width * 0.8

                onTextChanged: {
                    imagesManager.inputDirpath = text
                }
            }
            ToolButton {
                id: toolButtonSelectInputFolder
                icon.source: "qrc:/images/icons/folder.svg"

                onClicked: {
                    var dirpath = imagesManager.selectFolder(imagesManager.inputDirpath)
                    if (dirpath !== "") {
                        textFieldInputFolder.text = dirpath
                        imagesManager.scanInputDirectory()
                        sliderHorizontalPadding.updateHorizontalPadding()
                        sliderVerticalPadding.updateVerticalPadding()
                        textFieldOutputFolder.focus = true

                    }
                    if (unconfiguredBlocker.canClose()) {
                        unconfiguredBlocker.close()
                    } else {
                        unconfiguredBlocker.open()
                    }
                }
            }
        } // RowLayout
        RowLayout {
            TextField {
                id: textFieldOutputFolder
                placeholderText: qsTr("Output folder")
                text: imagesManager.outputDirpath
                readOnly: true
                selectByMouse: true
                Layout.fillWidth: true
                Layout.preferredWidth: rootAppWindow.width * 0.8

                onTextChanged: {
                    imagesManager.outputDirpath = text
                }
            }
            ToolButton {
                id: toolButtonSelectOutputFolder
                icon.source: "qrc:/images/icons/folder.svg"

                onClicked: {
                    var dirpath = imagesManager.selectFolder(imagesManager.outputDirpath)
                    if (dirpath !== "") {
                        textFieldOutputFolder.text = dirpath
                        imagesManager.reset()
                    }
                    if (unconfiguredBlocker.canClose()) {
                        unconfiguredBlocker.close()
                    } else {
                        unconfiguredBlocker.open()
                    }
                }
            }
        } // RowLayout
    } // ColumnLayout
}
