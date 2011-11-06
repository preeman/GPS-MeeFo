#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QDeclarativeContext>
#include <QCompass>

#include "sats.h"
#include "clippy.h"
//#include "compassfilter.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    app.setApplicationName(QString("GPSInfoMeeApp"));
    app.setApplicationVersion(QString("1.0 (Nokia; Qt)"));


    QmlApplicationViewer viewer;

    Clippy *h = new Clippy();
    //expose to qml
    viewer.rootContext()->setContextProperty("Clippy", h);
    viewer.rootContext()->setContextProperty("sats", new MySatsClass);

    /*QObject *rootObject = dynamic_cast<QObject*>(viewer->rootObject());

    QCompass compass;
    CompassFilter filter;
    compass.addfilter(&filter);

    connect(&filter, SIGNAL(azimuthChanged(const QVariant&, const QVariant&)),
            rootObject, SLOT(handleAzimuth(const QVariant&, const QVariant&)));

    compass.start();
    */

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.setMainQmlFile(QLatin1String("qml/gpsmeefo/main.qml"));
    viewer.showExpanded();

    return app.exec();
}
