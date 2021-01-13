#ifndef ACCESCONTROL_H
#define ACCESCONTROL_H

#include <QObject>
#include <QAbstractTableModel>

class AccesControl : public QObject
{
    Q_OBJECT

public:
    explicit AccesControl(QObject *parent = nullptr);
    Q_INVOKABLE QList<QObject *> getAccesControlEntrys();
};

#endif // ACCESCONTROL_H
