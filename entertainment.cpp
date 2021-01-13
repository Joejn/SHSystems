#include "entertainment.h"

Entertainment::Entertainment(QObject *parent) : QObject(parent)
{
    m_hostName = m_config.getData("mqtt/hostname", false);
    m_port = (m_config.getData("mqtt/port", false)).toInt();
    m_username = m_config.getData("mqtt/username", false);
    m_isPlaying = false;
    m_isLooped = false;
    m_currentSong = 0;

    m_client = new QMqttClient(this);
    m_client->setHostname(m_hostName);
    m_client->setPort(m_port);
    m_client->setUsername(m_username);
    m_client->setPassword(m_config.getData("mqtt/password", true));

    connectToBroker();

    connect(m_client, &QMqttClient::messageReceived, this, [this](const QByteArray &message, const QMqttTopicName &topic) {
            startCommand(message, topic);
        });

    m_timer = new QTimer(this);
    QObject::connect(m_timer, SIGNAL(timeout()), this, SLOT(setTopic()));
    m_timer->start(1000);

    /////////////////////////////////////////////////

    connect(m_client, SIGNAL(connected()), this, SLOT(connectedToBroker()));

}

void Entertainment::connectToBroker()
{
    if(m_client->state() == QMqttClient::Disconnected){
        m_client->connectToHost();
    }
}

void Entertainment::startCommand(const QByteArray &msg, const QMqttTopicName &topic)
{
    qDebug() << "Topic: " << topic.name();
    qDebug() << "Message: " << msg;

    if(topic.name() == "entertainment/songsList"){
        setPlaylist(msg);
    }

    if(topic.name() == "entertainment/currentSong" || topic.name() == "entertainment/clientCurrentSong"){
        m_currentSong = msg.toInt();
        emit currentSongChanged();
    }

    if(topic.name() == "entertainment/playing"){
        if(msg == "true"){
            m_isPlaying = true;
        } else {
            m_isPlaying = false;
        }
        getIsPlaying();
    }

    if(topic.name() == "entertainment/duration"){
        m_duration = msg.toUInt();
        getDurationStr();
        getDuration();
    }

    if(topic.name() == "entertainment/currentPosition"){
        m_currentPosition = msg.toInt();
        getCurrentPositionStr();
        getCurrentPosition();
    }

    if(topic.name() == "entertainment/volume"){
        m_volume = msg.toInt();
        getVolume();
    }

    if(topic.name() == "entertainment/title"){
        m_title = msg;
        emit titleChanged();
    }

    if(topic.name() == "entertainment/albumArtist"){
        m_albumArtist = msg;
        emit albumArtistChanged();
    }

    if(topic.name() == "entertainment/albumTitle"){
        m_albumTitle = msg;
        emit albumTitleChanged();
    }

    if(topic.name() == "entertainment/looped"){
        if(msg == "true"){
            m_isLooped = true;
        } else {
            m_isLooped = false;
        }
        emit isLoopedChanged();
    }

    if(topic.name() == "entertainment/muted"){
        if(msg == "true"){
            m_isMuted = true;
        } else {
            m_isMuted = false;
        }
        getIsMuted();
    }
}

void Entertainment::setPlaylist(QString const &playlist)
{
    m_playlist = playlist.split(";");
    // setCurrentSong(m_currentSong);
    getPlaylist();
}

void Entertainment::publishData(const QString &topic, const QString &msg)
{
    if(m_client->publish(topic, msg.toUtf8())){
            qDebug() << "Faild to publish";
        } else {
            qDebug() << "published";
    }
}

void Entertainment::setCurrentSong(const int &index)
{
    publishData("entertainment/currentSong", QString::number(index));
}

void Entertainment::setPlaying()
{
    QString isPlayingStr = m_isPlaying ? "false" : "true";
    publishData("entertainment/playing", isPlayingStr);
}

void Entertainment::nextSong()
{
    publishData("entertainment/next", QDateTime::currentDateTime().toString());
}

void Entertainment::previewSong()
{
    publishData("entertainment/back", QDateTime::currentDateTime().toString());
}

void Entertainment::setMuted()
{
    QString muted = m_isMuted ? "false" : "true";
    publishData("entertainment/muted", muted);
}

void Entertainment::setLooped()
{
    QString looped = m_isLooped ? "false" : "true";
    publishData("entertainment/looped", looped);
}

void Entertainment::setVolume(const int &volume)
{
    m_volume = volume;
    publishData("entertainment/volume", QString::number(m_volume));
}

void Entertainment::setCurrentPosition(const unsigned int &currentPosition)
{
    publishData("entertainment/setCurrentPosition", QString::number(currentPosition));
}

QStringList Entertainment::getPlaylist()
{
    emit modelChanged();
    return m_playlist;
}

bool Entertainment::getIsMuted()
{
    emit isMudedChanged();
    return m_isMuted;
}

bool Entertainment::getIsPlaying()
{
    emit isPlayingChanged();
    return m_isPlaying;
}

bool Entertainment::getIsLooped()
{
    return m_isLooped;
}

QString Entertainment::getDurationStr()
{
    const int milliseconds = m_duration;
    QTime vTime(0,0,0,0);
    vTime = vTime.addMSecs(milliseconds);
    QString durationStr = QString::number(vTime.minute()) + ":";
    if(vTime.second() < 10){
        durationStr += "0";
    }
    durationStr += QString::number(vTime.second());

    emit durationStrChanged();
    return durationStr;
}

QString Entertainment::getCurrentPositionStr()
{
    const int milliseconds = m_currentPosition;
    QTime vTime(0,0,0,0);
    vTime = vTime.addMSecs(milliseconds);
    QString currentPositionStr = QString::number(vTime.minute()) + ":";
    if(vTime.second() < 10){
        currentPositionStr += "0";
    }
    currentPositionStr += QString::number(vTime.second());

    emit currentPositionStrChanged();
    return currentPositionStr;
}

unsigned int Entertainment::getDuration()
{
    emit durationChanged();
    return m_duration;
}

unsigned int Entertainment::getCurrentPosition()
{
    emit currentPositionChanged();
    return m_currentPosition;
}

unsigned int Entertainment::getVolume()
{
    emit volumeChanged();
    return m_volume;
}

unsigned int Entertainment::getCurrentSong()
{
    return m_currentSong;
}

QString Entertainment::getTitle()
{
    return m_title;;
}

QString Entertainment::getAlbumArtist()
{
    return m_albumArtist;
}

QString Entertainment::getAlbumTitle()
{
    return m_albumTitle;
}

QString Entertainment::getMqttConnectionInfo()
{
    return m_mqttConnectionInfo;
}

void Entertainment::connectedToBroker()
{
    publishData("entertainment/clientConnect", QDateTime::currentDateTime().toString());
    publishData("entertainment/muted", "false");
}

void Entertainment::setTopic()
{
    QString topic = "entertainment/#";
    auto subscription = m_client->subscribe(topic);
    if (!subscription) {
        // qDebug() << "subscription of topic " + topic + " failed. Retry in one second";
        m_mqttConnectionInfo = "Es konnte keine Verbindung hergestellt werden";
        emit mqttConnectionInfoChanged();
        connectToBroker();
    } else {
        m_mqttConnectionInfo = "";
        emit mqttConnectionInfoChanged();
    }
}
