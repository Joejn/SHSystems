#ifndef WEATHERFORCAST_H
#define WEATHERFORCAST_H

#include <QObject>
#include <QDateTime>

#include <QNetworkAccessManager>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>

struct weatherStruct{
    QDate Date;
    QString temp;
    QString humidity;
    QString description;
    QString Icon;
};

class WeatherForcast : public QObject
{
    Q_OBJECT

private:
    QJsonValue weatherValue;
    QJsonArray weatherArray;
    QJsonObject weatherObject;
    QJsonObject weatherObjectSave;

    weatherStruct weatherInfos[5];

    QString city;

public:
    explicit WeatherForcast(QObject *parent = nullptr);

    void setWeatherValue(QJsonValue weatherValue);
    void setWeatherArray(QJsonArray weatherArray);
    void setWeatherObject(QJsonObject weatherObject);
    void setWeatherObjectSave(QJsonObject weatherObjectSave);
    QJsonValue getWeatherValue();
    QJsonArray getWeatherArray();
    QJsonObject getWeatherObject();
    QJsonObject setWeatherObjectSave();

    void setWeatherInfoDate(const int &position, const QDate &dateTime);
    void setWeatherInfotemp(const int &position, const float &temperature);
    void setWeatherInfoHumidity(const int &position, const float &humidity);
    void setWeatherInfoDescription(const int &position, const QString &description);
    void setWeatherInfoIcon(const int &position, const QString &Icon);
    void setCityName(QString city);

    QString getWeatherInfoDateTime(const int &position);
    QString getWeatherInfotemp(const int &position);
    QString getWeatherInfoHumidity(const int &position);
    QString getWeatherInfoDescription(const int &position);
    QString getWeatherInfoIcon(const int &position);
    QString getCityName();

    void setJsonData();

    QJsonObject getCity();
    QJsonObject getDescription(int firstArray, int secondArray);
    QJsonObject getTemperatureAndHumidity(int firstArray);
    QString getDateTime(int firstArray);

    void insertWeatherObject(QString City);

    void translation(const QString &description, const int &day);


    /////////////////////////////////////////////////////////////////////////////////////////////////

    Q_INVOKABLE void insertData();

    Q_INVOKABLE QString getWeatherLocation();
    Q_INVOKABLE QString getWeatherDescription(const int &position);
    Q_INVOKABLE QString getWeatherTemperature(const int &position);
    Q_INVOKABLE QString getWeatherHumidity(const int &position);
    Q_INVOKABLE QString getWeatherDay(const int &position);
    Q_INVOKABLE QString getWeatherIcon(const int &position);

    Q_INVOKABLE bool pingServer(QString ip);

signals:

};

#endif // WEATHERFORCAST_H
