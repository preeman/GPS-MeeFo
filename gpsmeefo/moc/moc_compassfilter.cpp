/****************************************************************************
** Meta object code from reading C++ file 'compassfilter.h'
**
** Created: Fri 23. Sep 01:00:06 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../compassfilter.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'compassfilter.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_CompassFilter[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: signature, parameters, type, tag, flags
      40,   15,   14,   14, 0x05,

       0        // eod
};

static const char qt_meta_stringdata_CompassFilter[] = {
    "CompassFilter\0\0azimuth,calibrationLevel\0"
    "azimuthChanged(QVariant,QVariant)\0"
};

const QMetaObject CompassFilter::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_CompassFilter,
      qt_meta_data_CompassFilter, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &CompassFilter::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *CompassFilter::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *CompassFilter::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_CompassFilter))
        return static_cast<void*>(const_cast< CompassFilter*>(this));
    if (!strcmp(_clname, "QCompassFilter"))
        return static_cast< QCompassFilter*>(const_cast< CompassFilter*>(this));
    return QObject::qt_metacast(_clname);
}

int CompassFilter::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: azimuthChanged((*reinterpret_cast< const QVariant(*)>(_a[1])),(*reinterpret_cast< const QVariant(*)>(_a[2]))); break;
        default: ;
        }
        _id -= 1;
    }
    return _id;
}

// SIGNAL 0
void CompassFilter::azimuthChanged(const QVariant & _t1, const QVariant & _t2)
{
    void *_a[] = { 0, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_END_MOC_NAMESPACE
