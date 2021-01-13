#ifndef ENTERTAINMENT_H
#define ENTERTAINMENT_H

#include <QObject>
#include <QMqttClient>
#include <QTimer>
#include <QStringListModel>

#include "config.h"

class Entertainment : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList myModel READ getPlaylist NOTIFY modelChanged)

    Q_PROPERTY(bool isMuted READ getIsMuted NOTIFY isMudedChanged)
    Q_PROPERTY(bool isPlaying READ getIsPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(bool isLooped READ getIsLooped NOTIFY isLoopedChanged)

    Q_PROPERTY(QString mqttConnectionInfo READ getMqttConnectionInfo NOTIFY mqttConnectionInfoChanged)
    Q_PROPERTY(QString durationStr READ getDurationStr NOTIFY durationStrChanged)
    Q_PROPERTY(QString currentPositionStr READ getCurrentPositionStr NOTIFY currentPositionStrChanged)
    Q_PROPERTY(QString title READ getTitle NOTIFY titleChanged)
    Q_PROPERTY(QString albumArtist READ getAlbumArtist NOTIFY albumArtistChanged)
    Q_PROPERTY(QString albumTitle READ getAlbumTitle NOTIFY albumTitleChanged)

    Q_PROPERTY(unsigned int duration READ getDuration NOTIFY durationChanged)
    Q_PROPERTY(unsigned int currentPosition READ getCurrentPosition NOTIFY currentPositionChanged)

    Q_PROPERTY(unsigned int volume READ getVolume NOTIFY volumeChanged)
    Q_PROPERTY(unsigned int currentSong READ getCurrentSong NOTIFY currentSongChanged)

public:
    explicit Entertainment(QObject *parent = nullptr);
    void connectToBroker();
    void startCommand(const QByteArray &msg, const QMqttTopicName &topic);
    void setPlaylist(QString const &playlist);
    void publishData(const QString &topic, const QString &msg);

    Q_INVOKABLE void setCurrentSong(const int &index);
    Q_INVOKABLE void setPlaying();

    Q_INVOKABLE void nextSong();
    Q_INVOKABLE void previewSong();
    Q_INVOKABLE void setMuted();
    Q_INVOKABLE void setLooped();

    Q_INVOKABLE void setVolume(const int &volume);
    Q_INVOKABLE void setCurrentPosition(const unsigned int &currentPosition);

public slots:
    void setTopic();

    Q_INVOKABLE QStringList getPlaylist();

    Q_INVOKABLE bool getIsMuted();
    Q_INVOKABLE bool getIsPlaying();
    Q_INVOKABLE bool getIsLooped();

    Q_INVOKABLE QString getDurationStr();
    Q_INVOKABLE QString getCurrentPositionStr();
    Q_INVOKABLE QString getTitle();
    Q_INVOKABLE QString getAlbumArtist();
    Q_INVOKABLE QString getAlbumTitle();
    Q_INVOKABLE QString getMqttConnectionInfo();

    Q_INVOKABLE unsigned int getDuration();
    Q_INVOKABLE unsigned int getCurrentPosition();
    Q_INVOKABLE unsigned int getVolume();
    Q_INVOKABLE unsigned int getCurrentSong();

    void connectedToBroker();

signals:
    void mqttConnectionInfoChanged();
    void modelChanged();
    void isMudedChanged();
    void durationStrChanged();
    void currentPositionStrChanged();
    void durationChanged();
    void currentPositionChanged();
    void volumeChanged();
    void currentSongChanged();
    void isPlayingChanged();
    void titleChanged();
    void albumArtistChanged();
    void albumTitleChanged();
    void isLoopedChanged();

private:
    QMqttClient *m_client;
    Config m_config;
    QString m_hostName;
    QString m_title;
    QString m_albumArtist;
    QString m_albumTitle;
    QString m_mqttConnectionInfo;
    QString m_username;
    QTimer *m_timer;
    QStringList m_playlist;
    bool m_isPlaying;
    bool m_isMuted;
    bool m_isLooped;
    int m_volume;
    int m_port;
    unsigned int m_duration;
    unsigned int m_currentPosition;
    unsigned int m_currentSong;
};

#endif // ENTERTAINMENT_H
