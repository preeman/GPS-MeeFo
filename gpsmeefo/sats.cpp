#include "sats.h"
#include "listitem.h"

MySatsClass::MySatsClass(QObject *parent) : QObject(parent)
{
    m_sats = QGeoSatelliteInfoSource::createDefaultSource(this);
    connect(m_sats, SIGNAL(satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &)),this, SLOT(satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &)));
    connect(m_sats, SIGNAL(satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &)),this, SLOT(satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &)));
    m_sats->startUpdates();
}

QString MySatsClass::getSatsInView() const
{
    return yourSatsInView;
}

QString MySatsClass::getSatsInUse() const
{
    return yourSatsInUse;
}

QList<QObject*> MySatsClass::getViewData() const
{
    QList<QObject*> dataList;
    int rectx;
    int recty;
    foreach( QGeoSatelliteInfo x, satellitesInView){
        rectx = 0;
        recty = 0;
        rectx = floor(190 * cos(x.attribute(QGeoSatelliteInfo::Azimuth)));
        recty = floor(190 * sin(x.attribute(QGeoSatelliteInfo::Azimuth)));
        dataList.append( new ListItem( x.prnNumber(), x.signalStrength(), x.attribute(QGeoSatelliteInfo::Elevation), x.attribute(QGeoSatelliteInfo::Azimuth), rectx, recty  ) );
    }
    return dataList;
}

QList<QObject*> MySatsClass::getUseData() const
{
    QList<QObject*> dataListUse;
    int rectxUse;
    int rectyUse;
    foreach( QGeoSatelliteInfo x, satellitesInUse){
        rectxUse = 0;
        rectyUse = 0;
        rectxUse = floor(190 * cos(x.attribute(QGeoSatelliteInfo::Azimuth)));
        rectyUse = floor(190 * sin(x.attribute(QGeoSatelliteInfo::Azimuth)));
        dataListUse.append( new ListItem( x.prnNumber(), x.signalStrength(), x.attribute(QGeoSatelliteInfo::Elevation), x.attribute(QGeoSatelliteInfo::Azimuth), rectxUse, rectyUse  ) );
    }
    return dataListUse;
}



void MySatsClass::satellitesInViewUpdated(const QList<QGeoSatelliteInfo> &list)
{
    satellitesInView = list;
    int viewSize = satellitesInView.size();
    yourSatsInView = QString::number( viewSize );
    //m_sats->stopUpdates();
}

void MySatsClass::satellitesInUseUpdated(const QList<QGeoSatelliteInfo> &list)
{
    satellitesInUse = list;
    int useSize = satellitesInUse.size();
    yourSatsInUse = QString::number( useSize );
    //qDebug() << "here asking for sat in USE";
    //qDebug() << yourSatsInUse;
    //m_sats->stopUpdates();
}
