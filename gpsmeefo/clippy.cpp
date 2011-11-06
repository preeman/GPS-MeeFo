#include "clippy.h"
#include <QDebug>
#include <QApplication>

Clippy::Clippy(QObject *parent) :
    QObject(parent)
{
}

void Clippy::setText( QString copyLocation){
        QClipboard *c = QApplication::clipboard();
        c->setText(copyLocation);
}
