#include "imagesmanager.h"
#include <QDebug>

ImagesManager::ImagesManager(QObject *parent) : QObject(parent)
{
//    imageFilepath = ":/images/tests/testImage.png";
//    image.load(imageFilepath);
//    watermarkFilepath = ":/images/tests/testWatermark.png";
//    watermarkImage.load(watermarkFilepath);
}

void ImagesManager::reset()
{
    if (!allImagesFilepaths.isEmpty()) {
        setImageFilepath(allImagesFilepaths.first());
    }
    setIndexCurrentImage(0);
    setIsLastImage(indexCurrentImage == imagesTotalCount - 1);
}

int ImagesManager::scanInputDirectory()
{
    QDir in(inputDirpath);
    QList<QFileInfo> files = in.entryInfoList(imageFilters, QDir::Files | QDir::Readable);
    allImagesFilepaths.clear();
    for (auto f : files) {
        allImagesFilepaths << f.absoluteFilePath();
    }
    if (!allImagesFilepaths.isEmpty()) {
        setImageFilepath(allImagesFilepaths.first());
    }
    int count = allImagesFilepaths.count();
    setImagesTotalCount(count);
    setIndexCurrentImage(0);
    return count;
}

bool ImagesManager::next()
{
    if (allImagesFilepaths.isEmpty()) {
        qCritical() << "[empty] The input folder doesn't contains images";
        return false;
    } else if (indexCurrentImage >= allImagesFilepaths.count() - 1) { // showld never happen
        qCritical() << "[out-of-range] Cannot access index" << indexCurrentImage;
        return false;
    }
    setIndexCurrentImage(indexCurrentImage + 1);
    setImageFilepath(allImagesFilepaths[indexCurrentImage]);
    setIsLastImage(indexCurrentImage == imagesTotalCount - 1);
    return true;
}

bool ImagesManager::mark(int position)
{
    QImage temp(image);
    QPainter p(&temp);

    QString side;
    switch (Position(position)) {
    case TopLeft:
        side = "topLeft";
        p.drawImage(QPoint(horizontalPadding, verticalPadding), watermarkImage);
        break;
    case TopRight:
        side = "topRight";
        p.drawImage(QPoint(temp.width() - watermarkImage.width() - horizontalPadding, verticalPadding), watermarkImage);
        break;
    case BottomRight:
        side = "bottomRight";
        p.drawImage(QPoint(temp.width() - watermarkImage.width() - horizontalPadding, temp.height() - watermarkImage.height() - verticalPadding), watermarkImage);
        break;
    case BottomLeft:
        side = "bottomLeft";
        p.drawImage(QPoint(horizontalPadding, temp.height() - watermarkImage.height() - verticalPadding), watermarkImage);
        break;
    }

    QFileInfo fileInfo(imageFilepath);
    QString savePath = outputDirpath + QDir::separator() + QFileInfo(imageFilepath).baseName() + "_" + side + "." + fileInfo.suffix();
    QFile saveFile(savePath);
    bool result = temp.save(&saveFile);
    if (!result) {
    }
    return result;
}

QString ImagesManager::selectFolder(const QString &initialFolder)
{
    QString dirpath = QFileDialog::getExistingDirectory(qApp->activeWindow(), tr("Select a folder"), initialFolder);
    return dirpath;
}

QString ImagesManager::selectFile(const QString &initialFile)
{
    QString dirpath = QFileDialog::getOpenFileName(qApp->activeWindow(), tr("Select a file"), initialFile, tr("Images") + " (" + imageFilters.join(' ') + ')');
    return dirpath;
}

int ImagesManager::requestWatermarkWidth(int paintedImageWidth) const
{
    double imageWidthScale = double(paintedImageWidth)/image.width();
    return int(watermarkImage.width() * imageWidthScale);
}

int ImagesManager::requestWatermarkHeight(int paintedImageHeight) const
{
    double imageHeightScale = double(paintedImageHeight)/image.height();
    return int(watermarkImage.height() * imageHeightScale);
}

int ImagesManager::requestScaledHorizontalPadding(int paintedImageWidth) const
{
    double imageWidthScale = double(paintedImageWidth)/image.width();
    return int(horizontalPadding * imageWidthScale);
}

int ImagesManager::requestScaledVerticalPadding(int paintedImageHeight) const
{
    double imageHeightScale = double(paintedImageHeight)/image.height();
    return int(verticalPadding * imageHeightScale);
}

int ImagesManager::getNotShowToolTipAgain() const
{
    return notShowToolTipAgain;
}

void ImagesManager::setNotShowToolTipAgain(int countdown)
{
    if (notShowToolTipAgain != countdown) {
        notShowToolTipAgain = countdown;
        emit notShowToolTipAgainChanged(countdown);
    }
}

bool ImagesManager::getValidWatermarkImage()
{
    validWatermarkImage = !watermarkImage.isNull();
    return validWatermarkImage;
}

bool ImagesManager::getValidOutputDir()
{
    validOutputDir = outputDirpath != "" && QDir(outputDirpath).exists();
    return validOutputDir;
}

int ImagesManager::getWatermarkHeight() const
{
    return watermarkHeight;
}

void ImagesManager::setWatermarkHeight(int h)
{
    if (watermarkHeight != h) {
        watermarkHeight = h;
        emit watermarkHeightChanged(h);
    }
}

int ImagesManager::getWatermarkWidth() const
{
    return watermarkWidth;
}

void ImagesManager::setWatermarkWidth(int w)
{
    if (watermarkWidth != w) {
        watermarkWidth = w;
        emit watermarkWidthChanged(w);
    }
}

int ImagesManager::getImageHeight() const
{
    return imageHeight;
}

void ImagesManager::setImageHeight(int h)
{
    if (imageHeight != h) {
        imageHeight = h;
        emit imageHeightChanged(h);
    }
}

int ImagesManager::getImageWidth() const
{
    return imageWidth;
}

void ImagesManager::setImageWidth(int w)
{
    if (imageWidth != w) {
        imageWidth = w;
        emit imageWidthChanged(w);
    }
}

QString ImagesManager::getImageFilepath() const
{
    return imageFilepath;
}

void ImagesManager::setImageFilepath(const QString &newFilepath)
{
    if (imageFilepath != newFilepath) {
        imageFilepath = newFilepath;
        image.load(newFilepath);
        setImageWidth(image.width());
        setImageHeight(image.height());
        emit imageFilepathChanged(newFilepath);
    }
}

QString ImagesManager::getWatermarkFilepath() const
{
    return watermarkFilepath;
}

void ImagesManager::setWatermarkFilepath(const QString &newFilepath)
{
    if (watermarkFilepath != newFilepath) {
        watermarkFilepath = newFilepath;
        watermarkImage.load(newFilepath);
        setWatermarkWidth(watermarkImage.width());
        setWatermarkHeight(watermarkImage.height());
        emit watermarkFilepathChanged(newFilepath);
        emit validWatermarkImageChanged(getValidWatermarkImage());
    }
}

int ImagesManager::getVerticalPadding() const
{
    return verticalPadding;
}

void ImagesManager::setVerticalPadding(int vp)
{
    if (verticalPadding != vp) {
        verticalPadding = vp;
        emit verticalPaddingChanged(vp);
    }
}

int ImagesManager::getHorizontalPadding() const
{
    return horizontalPadding;
}

void ImagesManager::setHorizontalPadding(int hp)
{
    if (horizontalPadding != hp) {
        horizontalPadding = hp;
        emit horizontalPaddingChanged(hp);
    }
}

QString ImagesManager::getOutputDirpath() const
{
    return outputDirpath;
}

void ImagesManager::setOutputDirpath(const QString &outputDir)
{
    if (outputDirpath != outputDir) {
        outputDirpath = outputDir;
        emit outputDirpathChanged(outputDir);
        emit validOutputDirChanged(getValidOutputDir());
    }
}

QString ImagesManager::getInputDirpath() const
{
    return inputDirpath;
}

void ImagesManager::setInputDirpath(const QString &inputDir)
{
    if (inputDirpath != inputDir) {
        inputDirpath = inputDir;
        emit inputDirpathChanged(inputDir);
    }
}

bool ImagesManager::getIsLastImage() const
{
    return isLastImage;
}

void ImagesManager::setIsLastImage(bool last)
{
    if (isLastImage != last) {
        isLastImage = last;
        emit isLastImageChanged(last);
    }
}

int ImagesManager::getImagesTotalCount() const
{
    return imagesTotalCount;
}

void ImagesManager::setImagesTotalCount(int newTotal)
{
    if (imagesTotalCount != newTotal) {
        imagesTotalCount = newTotal;
        emit imagesTotalCountChanged(newTotal);
    }
}

int ImagesManager::getIndexCurrentImage() const
{
    return indexCurrentImage;
}

void ImagesManager::setIndexCurrentImage(int newIndex)
{
    if (indexCurrentImage != newIndex) {
        indexCurrentImage = newIndex;
        emit indexCurrentImageChanged(newIndex);
    }
}
