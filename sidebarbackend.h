#ifndef SIDEBARBACKEND_H
#define SIDEBARBACKEND_H

#include <QObject>
#include <QTime>

class SideBarBackend : public QObject
{
    Q_OBJECT

public:
    explicit SideBarBackend(QObject *parent = nullptr);

    Q_INVOKABLE QString getCurrentDateTime();

signals:

};

#endif // SIDEBARBACKEND_H
