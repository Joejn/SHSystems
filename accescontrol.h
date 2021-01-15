#ifndef ACCESCONTROL_H
#define ACCESCONTROL_H

#include <QObject>
#include <QAbstractTableModel>
#include <QMqttClient>

#include "dbadministration.h"
#include "config.h"

class AccesControl : public QObject
{
    Q_OBJECT

public:
    explicit AccesControl(QObject *parent = nullptr);
    Q_INVOKABLE QList<QObject *> getAccesControlEntrys();
    Q_INVOKABLE void emitAccesControlEntrysChanged();

public slots:
    void setIsConnected(const bool &isConnected);

signals:
    void isConnectedChanged(const bool &isConnected);
    void accesControlEntrysChanged();

private:
    QString m_username;
    DbAdministration *m_db;
    QString m_dbHostname;
    QString m_dbName;
    QString m_dbUser;
    Config m_config;
    bool m_isConnected;
};

#endif // ACCESCONTROL_H
