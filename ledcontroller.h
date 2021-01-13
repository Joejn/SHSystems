#ifndef LEDCONTROLLER_H
#define LEDCONTROLLER_H

#include <QObject>
#include <QMqttClient>

#include "config.h"

class LedController : public QObject
{
    Q_OBJECT
public:
    explicit LedController(QObject *parent = nullptr);
    void connectToBroker();
    Q_INVOKABLE void publishData(const QString &topic, const QString &msg);

signals:
    void connectionStateChanged(const bool &isConnected);

private:
    QMqttClient *m_client;
    Config m_config;
    QString m_hostName;
    int m_port;
    QString m_username;
    bool m_isConnected;
};

#endif // LEDCONTROLLER_H
