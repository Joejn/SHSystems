#ifndef SENSORDRAWCHARTBACKEND_H
#define SENSORDRAWCHARTBACKEND_H

#include <QObject>
#include <QVariant>
#include <QDateTime>
#include <QList>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QPair>
#include <QMqttClient>
#include <QTimer>

#include "config.h"
#include "dbadministration.h"

class SensorDrawChartBackend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList sensorTabeles READ getSensorTables NOTIFY sensorTabelesChanged)

public:
    explicit SensorDrawChartBackend(QObject *parent = nullptr);

    Q_INVOKABLE void setTable(QString table);
    Q_INVOKABLE void set_sensorValues();
    Q_INVOKABLE QList<QVariant> get_X_Axie();
    Q_INVOKABLE QList<QVariant> get_Y_Axie();

    Q_INVOKABLE QVariant get_X_min();
    Q_INVOKABLE QVariant get_X_max();

    Q_INVOKABLE QVariant get_Y_min();
    Q_INVOKABLE QVariant get_Y_max();
    Q_INVOKABLE QVariant tickCountAxisY();

    Q_INVOKABLE bool addSensor(QString sensorName, QString type, unsigned int pin);
    Q_INVOKABLE void publishDataAddSensor(QString name, QString type, int pin);

public slots:
    QStringList getSensorTables();
    Q_INVOKABLE void setSensorTables();
    void setIsConnected(const bool &isConnected);

private:
    DbAdministration *m_db;
    QString m_tableName;
    QPair<QList<QVariant>, QList<QVariant>> m_sensorValues;
    QMqttClient *m_client;
    QString m_dbHostname;
    QString m_dbName;
    QString m_dbUser;
    Config m_config;
    QString m_hostName;
    int m_port;
    QString m_dbConnectionInfo;
    QStringList m_sensorTables;
    QTimer *m_timer;
    bool m_isConnected;

signals:
    void sensorTabelesChanged();
    void isConnectedChanged(const bool &isConnected);
};

#endif // SENSORDRAWCHARTBACKEND_H
