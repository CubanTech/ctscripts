import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

ApplicationWindow {
    id: rootAppWindow
    visible: true
    width: 640
    height: 480
    title: Qt.application.name + ' ' + Qt.application.version

    property string currentImage: "file:" + imagesManager.imageFilepath
    property string watermarkImage: "file:" + imagesManager.watermarkFilepath

    onWatermarkImageChanged: {
        if (topLeftImage.scaleWatermark) {
            topLeftImage.updateWatermarkScaledSize()
        }
        if (topRightImage.scaleWatermark) {
            topRightImage.updateWatermarkScaledSize()
        }
        if (bottomRightImage.scaleWatermark) {
            bottomRightImage.updateWatermarkScaledSize()
        }
        if (bottomLeftImage.scaleWatermark) {
            bottomLeftImage.updateWatermarkScaledSize()
        }
    }

    menuBar: MenuBar {
        Menu {
            id: menuFolders
            title: qsTr("&Config")
            MenuItem { id: configureFolders; text: qsTr("&Folders"); onClicked: dialogFolders.open() }
            MenuItem { id: configureWatermark; text: qsTr("&Watermark"); onClicked: dialogWatermark.open() }
        }
        Menu {
            id: menuHelp
            title: qsTr("&Help")
            MenuItem { id: about; text: qsTr("&About"); onClicked: dialogAbout.open() }
            MenuItem { id: aboutQt; text: qsTr("About &Qt"); onClicked: dialogAboutQt.open() }
        }
    }

    ProgressBar {
        id: progress
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        from: 0
        to: imagesManager.imagesTotalCount
        value: imagesManager.indexCurrentImage

        Behavior on value { NumberAnimation { easing.type: Easing.OutCubic } }
    }

    Rectangle {
        id: rectanglePadding
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: unconfiguredBlocker.visible ? 0 : sliderHorizontalPadding.height
        Behavior on height { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        color: 'transparent'
        clip: true
        z: 1

        RowLayout {
            anchors.fill: parent
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: rootAppWindow.width/2 - gridLayoutImages.width/2
                Label {
                    id: labelH
                    text: "H"
                    Layout.alignment: Qt.AlignLeft
                }
                Slider {
                    id: sliderHorizontalPadding
                    from: 0
                    to: imagesManager.imageWidth/4
                    value: imagesManager.horizontalPadding
                    Layout.preferredWidth: topLeftImage.paintedWidth - labelH.width

                    property int scaledHorizontalPaddingValue;

                    function updateHorizontalPadding() {
                        scaledHorizontalPaddingValue = imagesManager.requestScaledHorizontalPadding(topLeftImage.paintedWidth)
                    }

                    onValueChanged: {
                        imagesManager.horizontalPadding = value
                        scaledHorizontalPaddingValue = imagesManager.requestScaledHorizontalPadding(topLeftImage.paintedWidth)
                    }

                    Component.onCompleted: {
                        value = imagesManager.horizontalPadding
                        updateHorizontalPadding()
                    }
                }
            } // RowLayout
            RowLayout {
                Layout.fillWidth: true
                Layout.rightMargin: rootAppWindow.width/2 - gridLayoutImages.width/2
                Label {
                    id: labelV
                    text: "V"
                    Layout.alignment: Qt.AlignLeft
                }
                Slider {
                    id: sliderVerticalPadding
                    from: 0
                    to: imagesManager.imageHeight/4
                    value: imagesManager.verticalPadding
                    Layout.preferredWidth: topLeftImage.paintedWidth - labelV.width

                    property int scaledVerticalPaddingValue;

                    function updateVerticalPadding() {
                        scaledVerticalPaddingValue = imagesManager.requestScaledVerticalPadding(topLeftImage.paintedHeight)
                    }

                    onValueChanged: {
                        imagesManager.verticalPadding = value
                        scaledVerticalPaddingValue = imagesManager.requestScaledVerticalPadding(topLeftImage.paintedHeight)
                    }

                    Component.onCompleted: {
                        value = imagesManager.verticalPadding
                        updateVerticalPadding()
                    }
                }
            } // RowLayout
        } // RowLayout
    } // Rectangle

    ScrollView {
        id: scrollView
        anchors.fill: parent
        anchors.topMargin: rectanglePadding.height
        clip: true
        contentWidth: gridLayoutImages.width > rootAppWindow.width ? gridLayoutImages.width : rootAppWindow.width
        contentHeight: gridLayoutImages.height > (rootAppWindow.height - rootAppWindow.menuBar.height - progress.height - rectanglePadding.height - rootAppWindow.footer.height) ? gridLayoutImages.height : rootAppWindow.height - rootAppWindow.menuBar.height - progress.height - rectanglePadding.height - rootAppWindow.footer.height

        Item {
            anchors.fill: parent

            GridLayout {
                id: gridLayoutImages
                anchors.centerIn: parent

                rows: 2
                columns: 2
                rowSpacing: 10
                columnSpacing: 10

                property int appropriateWidth: rootAppWindow.width/2// - rowSpacing
                property int appropriateHeight: (rootAppWindow.height - rootAppWindow.menuBar.height - progress.height - rectanglePadding.height - rootAppWindow.footer.height)/2 - anchors.margins - columnSpacing
                property int minimum: Math.min(appropriateWidth, appropriateHeight)
                property size appropriateSize: Qt.size(minimum, minimum)

                ToolTip {
                    id: toolTipShowImage
                    anchors.centerIn: parent
                    text: qsTr("Press and hold to open the image")
                    delay: Qt.styleHints.mousePressAndHoldInterval

                    function showToolTip() {
                        if (imagesManager.notShowToolTipAgain > 0) {
                            toolTipShowImage.visible = true
                            t.start()
                        }
                    }

                    Timer {
                        id: t
                        interval: 4000
                        repeat: false

                        onTriggered: {
                            toolTipShowImage.visible = false
                        }
                    }
                }

                ImageWatermarked {
                    id: topLeftImage
                    source: imagesManager.imagesTotalCount > 0 ? currentImage : ""
                    sourceSize: parent.appropriateSize
                    watermarkSource: imagesManager.validWatermarkImage > 0 ? watermarkImage : ""
                    position: ImageWatermarked.TopLeft
                }
                ImageWatermarked {
                    id: topRightImage
                    source: imagesManager.imagesTotalCount > 0 ? currentImage : ""
                    sourceSize: parent.appropriateSize
                    watermarkSource: imagesManager.validWatermarkImage > 0 ? watermarkImage : ""
                    position: ImageWatermarked.TopRight
                }
                ImageWatermarked {
                    id: bottomRightImage
                    source: imagesManager.imagesTotalCount > 0 ? currentImage : ""
                    sourceSize: parent.appropriateSize
                    watermarkSource: imagesManager.validWatermarkImage > 0 ? watermarkImage : ""
                    position: ImageWatermarked.BottomLeft
                }
                ImageWatermarked {
                    id: bottomLeftImage
                    source: imagesManager.imagesTotalCount > 0 ? currentImage : ""
                    sourceSize: parent.appropriateSize
                    watermarkSource: imagesManager.validWatermarkImage > 0 ? watermarkImage : ""
                    position: ImageWatermarked.BottomRight
                }
            } // GridLayout
        } // Item
    } // ScrollView

    footer: ToolBar {
        id: toolBarFooter
        enabled: topLeftImage.checked || topRightImage.checked || bottomRightImage.checked || bottomLeftImage.checked
        property color color: imagesManager.isLastImage ? Material.color(Material.Blue) : "#CCFFFF"
        Material.primary: enabled ? color : Qt.lighter(color, 2)
        ToolButton {
            id: toolButtonNext
            anchors.fill: parent
            text: (imagesManager.isLastImage && imagesManager.imagesTotalCount !== 0) ? qsTr("Finish") : qsTr("Next")

            onClicked: {
                if (topLeftImage.checked) {
                    imagesManager.mark(ImageWatermarked.Position.TopLeft)
                }
                if (topRightImage.checked) {
                    imagesManager.mark(ImageWatermarked.Position.TopRight)
                }
                if (bottomRightImage.checked) {
                    imagesManager.mark(ImageWatermarked.Position.BottomRight)
                }
                if (bottomLeftImage.checked) {
                    imagesManager.mark(ImageWatermarked.Position.BottomLeft)
                }
                topLeftImage.checked = false
                topRightImage.checked = false
                bottomRightImage.checked = false
                bottomLeftImage.checked = false
                if (imagesManager.isLastImage) {
                    progress.value = progress.to
                    taskCompletedOverlay.open()
                } else {
                    imagesManager.next()
                }
            } // onClicked
        }
    } // ToolBar (footer)

    // Dialogs
    DialogFolders {
        id: dialogFolders
        anchors.centerIn: Overlay.overlay
        modal: true
        focus: true
    }
    DialogWatermark {
        id: dialogWatermark
        anchors.centerIn: Overlay.overlay
        modal: true
        focus: true
    }
    DialogAbout {
        id: dialogAbout
        anchors.centerIn: Overlay.overlay
        modal: true
        focus: true
    }
    DialogAboutQt {
        id: dialogAboutQt
        anchors.centerIn: Overlay.overlay
        modal: true
        focus: true
    }

    // Overlays
    TaskCompletedOverlay {
        id: taskCompletedOverlay
        anchors.centerIn: Overlay.overlay
        modal: true
        focus: true

        onAboutToHide: {
            imagesManager.reset()
            progress.value = 0
        }
    }
    FolderNoSelectedOverlay {
        id: unconfiguredBlocker
        anchors.fill: parent
        focus: true
    }

    // Windows
    FullScreenImage {
        id: fullScreenImage

    }

    Component.onCompleted: {
        if (!unconfiguredBlocker.canClose()) {
            unconfiguredBlocker.open()
        } else {
            toolTipShowImage.showToolTip()
        }
    }
}
