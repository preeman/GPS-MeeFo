/****************************************************************************
** Meta object code from reading C++ file 'listitem.h'
**
** Created: Sat 17. Sep 04:05:57 2011
**      by: The Qt Meta Object Compiler version 62 (Qt 4.7.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../listitem.h"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'listitem.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 62
#error "This file was generated using the moc from 4.7.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_ListItem[] = {

 // content:
       5,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       6,   44, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       6,       // signalCount

 // signals: signature, parameters, type, tag, flags
      10,    9,    9,    9, 0x05,
      23,    9,    9,    9, 0x05,
      47,    9,    9,    9, 0x05,
      66,    9,    9,    9, 0x05,
      83,    9,    9,    9, 0x05,
      98,    9,    9,    9, 0x05,

 // properties: name, type, flags
     117,  113, 0x02495103,
     121,  113, 0x02495103,
     142,  136, 0x87495103,
     152,  136, 0x87495103,
     160,  113, 0x02495103,
     166,  113, 0x02495103,

 // properties: notify_signal_id
       0,
       1,
       2,
       3,
       4,
       5,

       0        // eod
};

static const char qt_meta_stringdata_ListItem[] = {
    "ListItem\0\0prnChanged()\0signalstrengthChanged()\0"
    "elevationChanged()\0azimuthChanged()\0"
    "rectxChanged()\0rectyChanged()\0int\0prn\0"
    "signalstrength\0float\0elevation\0azimuth\0"
    "rectx\0recty\0"
};

const QMetaObject ListItem::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_ListItem,
      qt_meta_data_ListItem, 0 }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &ListItem::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *ListItem::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *ListItem::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_ListItem))
        return static_cast<void*>(const_cast< ListItem*>(this));
    return QObject::qt_metacast(_clname);
}

int ListItem::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: prnChanged(); break;
        case 1: signalstrengthChanged(); break;
        case 2: elevationChanged(); break;
        case 3: azimuthChanged(); break;
        case 4: rectxChanged(); break;
        case 5: rectyChanged(); break;
        default: ;
        }
        _id -= 6;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = getPrn(); break;
        case 1: *reinterpret_cast< int*>(_v) = getSignalstrength(); break;
        case 2: *reinterpret_cast< float*>(_v) = getElevation(); break;
        case 3: *reinterpret_cast< float*>(_v) = getAzimuth(); break;
        case 4: *reinterpret_cast< int*>(_v) = getRectx(); break;
        case 5: *reinterpret_cast< int*>(_v) = getRecty(); break;
        }
        _id -= 6;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setPrn(*reinterpret_cast< int*>(_v)); break;
        case 1: setSignalstrength(*reinterpret_cast< int*>(_v)); break;
        case 2: setElevation(*reinterpret_cast< float*>(_v)); break;
        case 3: setAzimuth(*reinterpret_cast< float*>(_v)); break;
        case 4: setRectx(*reinterpret_cast< int*>(_v)); break;
        case 5: setRecty(*reinterpret_cast< int*>(_v)); break;
        }
        _id -= 6;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 6;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void ListItem::prnChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void ListItem::signalstrengthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void ListItem::elevationChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void ListItem::azimuthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}

// SIGNAL 4
void ListItem::rectxChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, 0);
}

// SIGNAL 5
void ListItem::rectyChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, 0);
}
QT_END_MOC_NAMESPACE
