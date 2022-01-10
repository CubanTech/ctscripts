#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QIcon>
#include "ImagesManager/imagesmanager.h"

void load(ImagesManager *imagesManager);
void save(const ImagesManager *imagesManager);

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("TheCrowporation");
    app.setApplicationName("Watermarker");
    app.setApplicationVersion("1.0");
    app.setWindowIcon(QIcon(":/images/icons/appIcon.png"));

    ImagesManager imagesManager;
    load(&imagesManager);
    imagesManager.scanInputDirectory();

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("imagesManager", &imagesManager);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    int result = app.exec();
    save(&imagesManager);
    return result;
}

void load(ImagesManager *imagesManager)
{
    QSettings s;

    if (!s.contains("inputFolder")) {
        return;
    }

    imagesManager->setInputDirpath(s.value("inputFolder").toString());
    imagesManager->setOutputDirpath(s.value("outputFolder").toString());
    imagesManager->setWatermarkFilepath(s.value("watermark").toString());
    if (s.contains("horizontalPadding")) {
        imagesManager->setHorizontalPadding(s.value("horizontalPadding").toInt());
    }
    if (s.contains("verticalPadding")) {
        imagesManager->setVerticalPadding(s.value("verticalPadding").toInt());
    }
    if (s.contains("notShowToolTipAgain")) {
        imagesManager->setNotShowToolTipAgain(s.value("notShowToolTipAgain").toInt());
    }
}

void save(const ImagesManager *imagesManager)
{
    QSettings s;

    s.setValue("inputFolder", imagesManager->getInputDirpath());
    s.setValue("outputFolder", imagesManager->getOutputDirpath());
    s.setValue("watermark", imagesManager->getWatermarkFilepath());
    s.setValue("horizontalPadding", imagesManager->getHorizontalPadding());
    s.setValue("verticalPadding", imagesManager->getVerticalPadding());
    const int toolTipCountdown = imagesManager->getNotShowToolTipAgain();
    if (toolTipCountdown) {
        s.setValue("notShowToolTipAgain", toolTipCountdown - 1);
    }
}
