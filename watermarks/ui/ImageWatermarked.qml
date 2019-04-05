import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Image {
    id: root

    property alias watermarkSource: imageWatermark.source
    property alias watermarkSize: imageWatermark.sourceSize
    property bool scaleWatermark: true
    readonly property size scaledSize: Qt.size( imagesManager.requestWatermarkWidth(topLeftImage.paintedWidth), imagesManager.requestWatermarkHeight(topLeftImage.paintedHeight) )
    property alias hovered: imageChecker.hovered
    property int position: ImageWatermarked.Position.TopLeft
    enum Position { TopLeft, TopRight, BottomRight, BottomLeft }

    onScaledSizeChanged: {
        updateWatermarkScaledSize()
    }
    onWatermarkSourceChanged: {
        updateWatermarkScaledSize()
        sliderHorizontalPadding.updateHorizontalPadding()
        sliderVerticalPadding.updateVerticalPadding()
    }

    property alias checked: imageChecker.checked

    property real horizontalPadding: sliderHorizontalPadding.scaledHorizontalPaddingValue
    property real verticalPadding: sliderVerticalPadding.scaledVerticalPaddingValue

    signal pressAndHold()

    onPressAndHold: {
        fullScreenImage.position = position
        fullScreenImage.showFullScreen()
    }

    function check() {
        imageChecker.checked = true
    }
    function uncheck() {
        imageChecker.checked = false
    }
    function updateWatermarkScaledSize() {
        if (scaleWatermark) {
            watermarkSize = scaledSize
        }
    }

    CheckDelegateSelectImage {
        id: imageChecker
        anchors.fill: parent
        Material.accent: "#00F06D"

        onPressAndHold: root.pressAndHold()
    }

    fillMode: Image.PreserveAspectFit
    clip: true

    // Watermark
    Image {
        id: imageWatermark
        anchors.left: (position === ImageWatermarked.TopLeft || position === ImageWatermarked.BottomLeft) ? parent.left : undefined
        anchors.right: (position === ImageWatermarked.TopRight || position === ImageWatermarked.BottomRight) ? parent.right : undefined
        anchors.top: (position === ImageWatermarked.TopLeft || position === ImageWatermarked.TopRight) ? parent.top : undefined
        anchors.bottom: (position === ImageWatermarked.BottomLeft || position === ImageWatermarked.BottomRight) ? parent.bottom : undefined
        anchors.leftMargin: horizontalPadding
        anchors.rightMargin: anchors.leftMargin
        anchors.topMargin: verticalPadding
        anchors.bottomMargin: anchors.topMargin
        visible: imagesManager.validWatermarkImage && imagesManager.imagesTotalCount > 0
        fillMode: Image.PreserveAspectFit
        mipmap: true

        Component.onCompleted: {
            updateWatermarkScaledSize()
        }
    }
}
