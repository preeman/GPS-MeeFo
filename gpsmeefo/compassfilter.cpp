#include "compassfilter.h"

CompassFilter::CompassFilter()
{
}

bool CompassFilter::filter(QCompassReading *reading)
{
    // The azimuth and calibration level are retrieved through the
    // reading object. The calibration level has values 0..1 where
    // the 1.0 means that the sensor is fully calibrated.
    emit azimuthChanged(reading->azimuth(), reading->calibrationLevel());
    return false;
}
