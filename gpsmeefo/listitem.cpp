#include "listitem.h"

ListItem::ListItem(int prn, int signalstrength, float elevation, float azimuth, int rectx, int recty) : QObject(0)
{
    _prn = prn;
    _signalstrength = signalstrength;
    _elevation = elevation;
    _azimuth = azimuth;
    _rectx = rectx;
    _recty = recty;
}
