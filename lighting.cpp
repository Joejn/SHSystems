#include "lighting.h"

Lighting::Lighting(QObject *parent) : QObject(parent)
{
    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);

    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);
    m_db = new DbAdministration(this, m_dbHostname, m_dbName, m_dbUser, m_config.getData("db/password", true));

    m_hostName = m_config.getData("mqtt/hostname", false);
    m_port = (m_config.getData("mqtt/port", false)).toInt();
    m_username = m_config.getData("mqtt/username", false);
    m_topic = "";

    m_client = new QMqttClient(this);
    m_client->setHostname(m_hostName);
    m_client->setPort(m_port);
    m_client->setUsername(m_username);
    m_client->setPassword(m_config.getData("mqtt/password", true));

    if(m_client->state() == QMqttClient::Disconnected){
        m_client->connectToHost();
    }

    connect(m_client, &QMqttClient::messageReceived, this, [this](const QByteArray &message, const QMqttTopicName &topic) {
        // (message, topic.name());
        setLightningData(message, topic.name());
    });

    connect(m_client, &QMqttClient::stateChanged, this, [this](const QMqttClient::ClientState &currentState) {
        qDebug() << "Current State: " << currentState;
    });

    connect(m_client, &QMqttClient::errorChanged, this, [this](const QMqttClient::ClientError &currentError) {
        qDebug() << "Current error: " << currentError;
    });

    connect(m_client, &QMqttClient::disconnected, this, [this]() {
        qDebug() << "disconected";
    });

    connect(m_db, SIGNAL(isConnectedChanged(const bool&)), this, SLOT(setIsConnected(const bool&)));

    m_timer = new QTimer(this);
    QObject::connect(m_timer, SIGNAL(timeout()), this, SLOT(setTopic()));
    m_timer->start(1000);
}

bool Lighting::publishData(QString topic, QString brightness)
{
   if(m_client->publish(topic, brightness.toUtf8()) == -1)
       return false;
   else
       return true;
}

void Lighting::setDbData(const QString &statement, const QString &positions)
{
    m_db->setDataListFromDb(statement, positions);
}

QStringList Lighting::getDbData(const unsigned int &index)
{
    return m_db->getDataListFromDb(index);
}

void Lighting::startCommand(const QString &message, const QString &topic)
{
    setLightningData(message, topic);
}

void Lighting::setLightningData(const QString &message, const QString &topic)
{
    QStringList data;
    for(const auto &val : m_lightningData){
        data.append(val.first);
    }

    if(data.contains(topic)){
        for(auto &val : m_lightningData){
            if(val.first == topic){
                val.second = message.toInt();
            }
        }
    } else {
        m_lightningData.append(qMakePair(topic, message.toUInt()));
    }

    m_lastStatus = QDateTime::currentDateTime().toString("yyyy.MM.dd hh:mm:ss:zzz");
    emit lastStatusChanged();
}

QList<QPair<QString, int>> Lighting::getLightningData()
{
    return m_lightningData;
}

QStringList Lighting::getTopicList()
{
    QStringList data;
    for(const auto &val : m_lightningData){
        data.append(val.first);
    }
    return data;
}

QList<int> Lighting::getBrightness()
{
    QList<int> data;
    for(const auto &val : m_lightningData){
        data.append(val.second);
    }
    return data;
}

void Lighting::addLighting(const QString &description, const QString &topic)
{
    QString statement = "INSERT INTO lightning_info (description, topic) VALUES ('" + description + "', '" + topic + "');";
    m_db->execStatement(statement);
}

void Lighting::setTopic()
{
    QString topic = "Lightning/#";
    auto subscription = m_client->subscribe(topic);
    if (!subscription) {
        // qDebug() << "can't Subscribe topic";
    }
}

QString Lighting::getLastStatus()
{
    return m_lastStatus;
}

void Lighting::setIsConnected(const bool &isConnected)
{
    m_isConnected = isConnected;
    emit isConnectedChanged(m_isConnected);
}
