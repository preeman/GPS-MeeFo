#ifndef LISTITEM_H
#define LISTITEM_H

#include <QObject>

class ListItem : public QObject
{

    Q_OBJECT

    Q_PROPERTY(int prn READ getPrn WRITE setPrn NOTIFY prnChanged )
    Q_PROPERTY(int signalstrength READ getSignalstrength WRITE setSignalstrength NOTIFY signalstrengthChanged )
    Q_PROPERTY(float elevation READ getElevation WRITE setElevation NOTIFY elevationChanged )
    Q_PROPERTY(float azimuth READ getAzimuth WRITE setAzimuth NOTIFY azimuthChanged )
    Q_PROPERTY(int rectx READ getRectx WRITE setRectx NOTIFY rectxChanged )
    Q_PROPERTY(int recty READ getRecty WRITE setRecty NOTIFY rectyChanged )

public:

    ListItem(int prn, int signalstrength, float elevation, float azimuth, int rectx, int recty);

    int getPrn(){
        return _prn;
    }

    int getSignalstrength(){
        return _signalstrength;
    }

    float getElevation(){
        return _elevation;
    }

    float getAzimuth(){
        return _azimuth;
    }

    int getRectx(){
        return _rectx;
    }

    int getRecty(){
        return _recty;
    }

    void setPrn( int prn ){
        emit prnChanged();
        _prn = prn;
    }

    void setSignalstrength( int signalstrength ){
        emit signalstrengthChanged();
        _signalstrength = signalstrength;
    }

    void setElevation( float elevation ){
        emit elevationChanged();
        _elevation = elevation;
    }

    void setAzimuth( float azimuth ){
        emit azimuthChanged();
        _azimuth = azimuth;
    }

    void setRectx ( int rectx ){
        emit rectxChanged();
        _rectx = rectx;
    }

    void setRecty ( int recty ){
        emit rectyChanged();
        _recty = recty;
    }

private:
    int _prn, _signalstrength;
    float _elevation, _azimuth;
    int _rectx, _recty;

signals:
    void prnChanged();
    void signalstrengthChanged();
    void elevationChanged();
    void azimuthChanged();
    void rectxChanged();
    void rectyChanged();

};

#endif // LISTITEM_H
