#include "accescontrol.h"
#include "accescontrolevent.h"

#include <QDebug>
#include <QTimer>

AccesControl::AccesControl(QObject *parent) : QObject(parent)
{
    m_hostName = m_config.getData("mqtt/hostname", false);
    m_port = (m_config.getData("mqtt/port", false)).toInt();
    m_username = m_config.getData("mqtt/username", false);

    m_client = new QMqttClient(this);
    m_client->setHostname(m_hostName);
    m_client->setPort(m_port);
    m_client->setUsername(m_username);
    m_client->setPassword(m_config.getData("mqtt/password", true));

    if(m_client->state() == QMqttClient::Disconnected){
        m_client->connectToHost();
    }

    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);
    m_db = new DbAdministration(this, m_dbHostname, m_dbName, m_dbUser, m_config.getData("db/password", true));

    connect(m_db, SIGNAL(isConnectedChanged(const bool&)), this, SLOT(setIsConnected(const bool&)));

    connect(this, SIGNAL(isConnectedChanged(const bool&)), this, SLOT(print()));

    connect(m_client, &QMqttClient::messageReceived, this, [this](const QByteArray &message, const QMqttTopicName &topic) {
        getAccesControlEntrys();
        emit accesControlEntrysChanged();

    });

    QTimer *timer = new QTimer(this);
    QObject::connect(timer, SIGNAL(timeout()), this, SLOT(setTopic()));
    timer->start(1000);
}

QList<QObject *> AccesControl::getAccesControlEntrys()
{
    QList <QObject*> EntrysList;

    QString statement = "SELECT * FROM accescontrol ORDER BY scandatetime DESC, id DESC;";
    if(m_db->setDataListFromDb(statement, "0;1;2")){

        for(int i = 0; i < m_db->getDataListFromDb(0).length(); ++i){
            AccesControlEvent *event = new AccesControlEvent(this);
            unsigned int id = m_db->getDataListFromDb(0).at(i).toUInt();
            QString name = m_db->getDataListFromDb(1).at(i);
            QDateTime scanDateTime = QDateTime::fromString(m_db->getDataListFromDb(2).at(i), Qt::ISODate);
            // qDebug() << m_db->getDataListFromDb(0).at(i);
            event->setId(id);
            event->setName(name);
            event->setScanDateTime(scanDateTime);

            EntrysList.append(event);
        }
    }

    return EntrysList;
}

void AccesControl::emitAccesControlEntrysChanged()
{
    getAccesControlEntrys();
    emit accesControlEntrysChanged();
}

void AccesControl::setIsConnected(const bool &isConnected)
{
    qDebug() << "setIsConnected: " << (isConnected ? "true" : "false");
    m_isConnected = isConnected;
    emit isConnectedChanged(m_isConnected);
}

void AccesControl::setTopic()
{
    QString topic = "AccesControl/Content";
    auto subscription = m_client->subscribe(topic);
    if (!subscription) {
        qDebug() << "can't Subscribe topic";
    }
}

void AccesControl::print()
{
    qDebug() << "khkjhdfsjkfhasjkdhfk";
}
