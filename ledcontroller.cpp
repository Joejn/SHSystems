#include "ledcontroller.h"
#include <QSerialPort>
#include <QDebug>
#include <QProcess>

LedController::LedController(QObject *parent) : QObject(parent)
{
    m_hostName = m_config.getData("mqtt/hostname", false);
    m_port = (m_config.getData("mqtt/port", false)).toInt();
    m_username = m_config.getData("mqtt/username", false);

    m_client = new QMqttClient(this);
    m_client->setHostname(m_hostName);
    m_client->setPort(m_port);
    m_client->setUsername(m_username);
    m_client->setPassword(m_config.getData("mqtt/password", true));

    connectToBroker();

    connect(m_client, &QMqttClient::stateChanged, this, [this](const QMqttClient::ClientState &currentState) {
        if(currentState == QMqttClient::Connected){
            m_isConnected = true;
        } else {
            m_isConnected = false;
        }
    });
}

void LedController::connectToBroker()
{
    if(m_client->state() == QMqttClient::Disconnected){
        m_client->connectToHost();
    }
}

void LedController::publishData(const QString &topic, const QString &msg)
{
    if(m_client->state() == QMqttClient::Connected){
        m_client->publish(topic, msg.toUtf8());
        qDebug() << "QMqttClient::Connected";
        emit connectionStateChanged(true);
    } else {
        connectToBroker();
        emit connectionStateChanged(false);
    }
}
