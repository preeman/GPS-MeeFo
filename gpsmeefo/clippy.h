#ifndef CLIPPY_H
#define CLIPPY_H

#include <QObject>
#include <QClipboard>

//QTM_USE_NAMESPACE

class Clippy : public QObject
{
    Q_OBJECT

    public:
    explicit Clippy(QObject *parent = 0);
    Q_INVOKABLE void setText( QString copyLocation);

    signals:

    public slots:

};

#endif // CLIPPY_H
