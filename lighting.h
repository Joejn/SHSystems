#ifndef LIGHTING_H
#define LIGHTING_H

#include <QObject>
#include <QMqttClient>
#include <QTimer>
#include <QStringList>
#include <QSqlDatabase>
#include <QSqlQuery>

#include "config.h"
#include "dbadministration.h"

class Lighting : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString lastStatus READ getLastStatus NOTIFY lastStatusChanged)

public:
    explicit Lighting(QObject *parent = nullptr);
    Q_INVOKABLE bool publishData(QString topic, QString brightness);
    Q_INVOKABLE void setDbData(const QString &statement, const QString &positions);
    Q_INVOKABLE QStringList getDbData(const unsigned int &index);
    void startCommand(const QString &message, const QString &topic);
    void setLightningData(const QString &message, const QString &topic);
    Q_INVOKABLE QList<QPair<QString, int>> getLightningData();
    Q_INVOKABLE QStringList getTopicList();
    Q_INVOKABLE QList<int> getBrightness();
    Q_INVOKABLE void addLighting(const QString &description, const QString &topic);

public slots:
    void setTopic();
    QString getLastStatus();
    void setIsConnected(const bool &isConnected);

signals:
    void lastStatusChanged();
    void isConnectedChanged(const bool &isConnected);

private:
    QMqttClient *m_client;
    Config m_config;
    QString m_hostName;
    int m_port;
    bool m_isConnected;
    QString m_username;
    QTimer *m_timer;
    QStringList m_lightningInfo;
    QString m_dbHostname;
    QString m_dbName;
    QString m_dbUser;
    DbAdministration *m_db;
    QString m_topic;
    QList<QPair<QString, int>> m_lightningData;
    QString m_lastStatus;
    QString m_connectionStatus;
};

#endif // LIGHTING_H
