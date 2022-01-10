#ifndef IMAGESMANAGER_H
#define IMAGESMANAGER_H

#include <QObject>
#include <QImage>
#include <QString>
#include <QStringList>
#include <QPainter>
#include <QFile>
#include <QFileInfo>
#include <QDir>
#include <QFileDialog>
#include <QApplication>

class ImagesManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString inputDirpath READ getInputDirpath WRITE setInputDirpath NOTIFY inputDirpathChanged)
    Q_PROPERTY(QString outputDirpath READ getOutputDirpath WRITE setOutputDirpath NOTIFY outputDirpathChanged)
    Q_PROPERTY(QString imageFilepath READ getImageFilepath WRITE setImageFilepath NOTIFY imageFilepathChanged)
    Q_PROPERTY(QString watermarkFilepath READ getWatermarkFilepath WRITE setWatermarkFilepath NOTIFY watermarkFilepathChanged)

    Q_PROPERTY(int indexCurrentImage READ getIndexCurrentImage NOTIFY indexCurrentImageChanged)
    Q_PROPERTY(int imagesTotalCount READ getImagesTotalCount NOTIFY imagesTotalCountChanged)
    Q_PROPERTY(bool isLastImage READ getIsLastImage NOTIFY isLastImageChanged)
    Q_PROPERTY(int horizontalPadding READ getHorizontalPadding WRITE setHorizontalPadding NOTIFY horizontalPaddingChanged)
    Q_PROPERTY(int verticalPadding READ getVerticalPadding WRITE setVerticalPadding NOTIFY verticalPaddingChanged)
    Q_PROPERTY(int imageWidth READ getImageWidth WRITE setImageWidth NOTIFY imageWidthChanged)
    Q_PROPERTY(int imageHeight READ getImageHeight WRITE setImageHeight NOTIFY imageHeightChanged)
    Q_PROPERTY(int watermarkWidth READ getWatermarkWidth WRITE setWatermarkWidth NOTIFY watermarkWidthChanged)
    Q_PROPERTY(int watermarkHeight READ getWatermarkHeight WRITE setWatermarkHeight NOTIFY watermarkHeightChanged)
    Q_PROPERTY(bool validOutputDir READ getValidOutputDir NOTIFY validOutputDirChanged)
    Q_PROPERTY(bool validWatermarkImage READ getValidWatermarkImage NOTIFY validWatermarkImageChanged)

    // config
    Q_PROPERTY(int notShowToolTipAgain READ getNotShowToolTipAgain NOTIFY notShowToolTipAgainChanged)

public:
    enum Position { TopLeft, TopRight, BottomRight, BottomLeft };

    explicit ImagesManager(QObject *parent = nullptr);

    QString getImageFilepath() const;
    void setImageFilepath(const QString &newFilepath);

    QString getWatermarkFilepath() const;
    void setWatermarkFilepath(const QString &newFilepath);

    QString getInputDirpath() const;
    void setInputDirpath(const QString &inputDir);

    QString getOutputDirpath() const;
    void setOutputDirpath(const QString &outputDir);

    int getIndexCurrentImage() const;
    void setIndexCurrentImage(int newIndex);

    int getImagesTotalCount() const;
    void setImagesTotalCount(int newTotal);

    bool getIsLastImage() const;
    void setIsLastImage(bool last);

    int getHorizontalPadding() const;
    void setHorizontalPadding(int hp);

    int getVerticalPadding() const;
    void setVerticalPadding(int vp);

    int getImageWidth() const;
    void setImageWidth(int w);

    int getImageHeight() const;
    void setImageHeight(int h);

    int getWatermarkWidth() const;
    void setWatermarkWidth(int w);

    int getWatermarkHeight() const;
    void setWatermarkHeight(int h);

    bool getValidOutputDir();
    bool getValidWatermarkImage();

    int getNotShowToolTipAgain() const;
    void setNotShowToolTipAgain(int countdown);

signals:
    void inputDirpathChanged(const QString &inputPath);
    void outputDirpathChanged(const QString &outputPath);
    void imageFilepathChanged(const QString &newFilepath);
    void watermarkFilepathChanged(const QString &newFilepath);
    void indexCurrentImageChanged(int index);
    void imagesTotalCountChanged(int total);
    void isLastImageChanged(bool last);
    void horizontalPaddingChanged(int hp);
    void verticalPaddingChanged(int vp);
    void imageWidthChanged(int w);
    void imageHeightChanged(int h);
    void watermarkWidthChanged(int w);
    void watermarkHeightChanged(int h);
    void validOutputDirChanged(bool valid);
    void validWatermarkImageChanged(bool valid);
    void notShowToolTipAgainChanged(int countdown);

public slots:
    void reset();
    int scanInputDirectory();
    bool mark(int position);
    bool next();
    QString selectFolder(const QString &initialFolder);
    QString selectFile(const QString &initialFile);

    int requestWatermarkWidth(int paintedImageWidth) const;
    int requestWatermarkHeight(int paintedImageHeight) const;
    int requestScaledHorizontalPadding(int paintedImageWidth) const;
    int requestScaledVerticalPadding(int paintedImageHeight) const;

private:
    QString inputDirpath;
    QString outputDirpath;
    QString watermarkFilepath;
    QString imageFilepath;
    QStringList allImagesFilepaths;
    int indexCurrentImage = 0;
    int imagesTotalCount = 0;
    bool isLastImage = false;
    int horizontalPadding = 10;
    int verticalPadding = 10;
    int imageWidth = 0;
    int imageHeight = 0;
    int watermarkWidth = 0;
    int watermarkHeight = 0;
    bool validOutputDir = false;
    bool validWatermarkImage = false;

    // Config - countdown (when 0 no show it more)
    int notShowToolTipAgain = 10;

    // Not export to QML:
    QImage image;
    QImage watermarkImage;

    const QStringList imageFilters = QStringList() << "*.bmp" << "*.gif" << "*.jpg" << "*.jpeg" << "*.png" << "*.pbm" << "*.pgm" << "*.ppm" << "*.xbm" << "*.xpm";
};

#endif // IMAGESMANAGER_H
