#include "weatherforcast.h"
#include <QDebug>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <QNetworkAccessManager>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>
#include <QEventLoop>
#include <QPixmap>
#include <QProcess>

#define NullGradKelvin -273.15

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

WeatherForcast::WeatherForcast(QObject *parent) : QObject(parent)
{

}

void WeatherForcast::insertWeatherObject(QString City){
    QString tmp = "";
    QNetworkAccessManager manager;
    QString QstrUrl = "http://api.openweathermap.org/data/2.5/forecast?q=";
    QstrUrl += City;
    QstrUrl += "&appid=0409301895061d7896356de3524aa9dd";
    QNetworkReply *response = manager.get(QNetworkRequest(QUrl(QstrUrl)));
    QEventLoop event;
    connect(response,SIGNAL(finished()),&event,SLOT(quit()));
    event.exec();
    QString html = response->readAll();
    QJsonDocument docsav = QJsonDocument::fromJson(html.toUtf8());
    this->weatherObjectSave = docsav.object();

    tmp = getCity().value("name").toString();
    tmp += " ";
    tmp += getCity().value("country").toString();
    this->city = tmp;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void WeatherForcast::setCityName(QString city){
    this->city = city;
}

void WeatherForcast::setWeatherValue(QJsonValue weatherValue)
{
    this->weatherValue = weatherValue;
}

void WeatherForcast::setWeatherArray(QJsonArray weatherArray)
{
    this->weatherArray = weatherArray;
}

void WeatherForcast::setWeatherObject(QJsonObject weatherObject)
{
    this->weatherObject = weatherObject;
}

void WeatherForcast::setWeatherObjectSave(QJsonObject weatherObjectSave){
    this->weatherObjectSave = weatherObjectSave;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

QString WeatherForcast::getCityName(){
    return this->city;
}

QJsonValue WeatherForcast::getWeatherValue()
{
    return this->weatherValue;
}

QJsonArray WeatherForcast::getWeatherArray()
{
    return this->weatherArray;
}

QJsonObject WeatherForcast::getWeatherObject()
{
    return this->weatherObject;
}

QJsonObject WeatherForcast::setWeatherObjectSave(){
    return this->weatherObjectSave;
}

bool WeatherForcast::pingServer(QString ip)
{

    qDebug() << "kjhdsfajkhfk" + ip;
    QString cmd;

    #if (defined (_WIN32) || defined (_WIN64))
        cmd = "ping " + ip + " -n 1";
    #else
        cmd = "ping " + m_hostname + " -c 1 -W " + m_connectionTimeout;
    #endif


    if(QProcess::execute(cmd) == 0){
        return true;
    }
    return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void WeatherForcast::setWeatherInfoDate(const int &position, const QDate &date)
{
    this->weatherInfos[position].Date = date;
}

void WeatherForcast::setWeatherInfotemp(const int &position, const float &temperature)
{
    this->weatherInfos[position].temp = QString::number(temperature, 'f' , 1) + "°C";
}

void WeatherForcast::setWeatherInfoHumidity(const int &position, const float &humidity)
{
    this->weatherInfos[position].humidity = QString::number(humidity) + "%";
}

void WeatherForcast::setWeatherInfoDescription(const int &position, const QString &description)
{
    this->weatherInfos[position].description = description;
}

void WeatherForcast::setWeatherInfoIcon(const int &position, const QString &Icon){
    this->weatherInfos[position].Icon = Icon;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

QString WeatherForcast::getWeatherInfoDateTime(const int &position)
{
    return this->weatherInfos[position].Date.toString("dddd");
}

QString WeatherForcast::getWeatherInfotemp(const int &position)
{
    return this->weatherInfos[position].temp;
}

QString WeatherForcast::getWeatherInfoHumidity(const int &position)
{
    return this->weatherInfos[position].humidity;
}

QString WeatherForcast::getWeatherInfoDescription(const int &position)
{
    return this->weatherInfos[position].description;
}

QString WeatherForcast::getWeatherInfoIcon(const int &position){
    return this->weatherInfos[position].Icon;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

QJsonObject WeatherForcast::getCity()
{
    this->weatherObject = this->weatherObjectSave;
    this->weatherValue = this->weatherObject.value(QStringLiteral("city"));
    this->weatherObject = this->weatherValue.toObject();
    return this->weatherObject;
}

QJsonObject WeatherForcast::getDescription(int firstArray, int secondArray)
{
    this->weatherObject = this->weatherObjectSave;
    this->weatherValue = this->weatherObject.value(QStringLiteral("list"));
    this->weatherArray = this->weatherValue.toArray();
    this->weatherValue = this->weatherArray.at(firstArray);
    this->weatherObject = this->weatherValue.toObject();
    this->weatherValue = this->weatherObject.value(QStringLiteral("weather"));
    this->weatherArray = this->weatherValue.toArray();
    this->weatherValue = this->weatherArray.at(secondArray);
    this->weatherObject = this->weatherValue.toObject();
    return this->weatherObject;
}

QJsonObject WeatherForcast::getTemperatureAndHumidity(int firstArray)
{
    this->weatherObject = this->weatherObjectSave;
    this->weatherValue = this->weatherObject.value(QStringLiteral("list"));
    this->weatherArray = this->weatherValue.toArray();
    this->weatherValue = this->weatherArray.at(firstArray);
    this->weatherObject = this->weatherValue.toObject();
    this->weatherValue = this->weatherObject.value(QStringLiteral("main"));
    this->weatherObject = this->weatherValue.toObject();
    return this->weatherObject;
}

QString WeatherForcast::getDateTime(int firstArray)
{
    this->weatherObject = this->weatherObjectSave;
    this->weatherValue = this->weatherObject.value(QStringLiteral("list"));
    this->weatherArray = this->weatherValue.toArray();
    this->weatherValue = this->weatherArray.at(firstArray);
    this->weatherObject = this->weatherValue.toObject();
    this->weatherValue = this->weatherObject.value(QStringLiteral("dt_txt"));
    return this->weatherValue.toString();
}

WeatherForcast weatherInfo;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void WeatherForcast::insertData(){

    QString dateTimeWeatherForcast = "";

    weatherInfo.insertWeatherObject("Linz");

    QString tmp = weatherInfo.getDateTime(0);
    tmp = tmp.left(10);

    weatherInfo.setWeatherInfotemp(0, weatherInfo.getTemperatureAndHumidity(0).value("temp").toDouble() + NullGradKelvin);
    weatherInfo.setWeatherInfoHumidity(0,weatherInfo.getTemperatureAndHumidity(0).value("humidity").toDouble());
    WeatherForcast::translation(weatherInfo.getDescription(0, 0).value("main").toString(), 0);

    int count = 1;
    for(int i = 0; i < 40 && count < 5; i++){

        if(weatherInfo.getDateTime(i).left(10) != tmp){
            if(weatherInfo.getDateTime(i).right(8) == "12:00:00"){
                weatherInfo.setWeatherInfotemp(count, weatherInfo.getTemperatureAndHumidity(i).value("temp").toDouble() + NullGradKelvin);
                WeatherForcast::translation(weatherInfo.getDescription(i, 0).value("main").toString(), count);
                weatherInfo.setWeatherInfoDate(count, QDate::fromString((weatherInfo.getDateTime(i)).left(10), "yyyy-MM-dd"));
                count++;
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void WeatherForcast::translation(const QString &description, const int &day){
    if(description == "Thunderstorm"){

        weatherInfo.setWeatherInfoDescription(day, "Gewitter");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Thunderstorm.png");

    }else if(description == "Drizzle"){

        weatherInfo.setWeatherInfoDescription(day, "Nieseln");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Drizzle.png");

    }else if(description == "Rain"){

        weatherInfo.setWeatherInfoDescription(day, "Regen");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Rain.png");

    }else if(description == "Snow"){

        weatherInfo.setWeatherInfoDescription(day, "Schnee");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Snow.png");

    }else if(description == "Mist"){

        weatherInfo.setWeatherInfoDescription(day, "Nebel");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Smoke"){

        weatherInfo.setWeatherInfoDescription(day, "Nebel");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Haze"){

        weatherInfo.setWeatherInfoDescription(day, "Nebel");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Dust"){

        weatherInfo.setWeatherInfoDescription(day, "Nebel");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Fog"){

        weatherInfo.setWeatherInfoDescription(day, "Nebel");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Sand"){

        weatherInfo.setWeatherInfoDescription(day, "Nebel");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Ash"){

        weatherInfo.setWeatherInfoDescription(day, "Nebel");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Tornado"){

        weatherInfo.setWeatherInfoDescription(day, "Sturm");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Mist.png");

    }else if(description == "Clear"){

        weatherInfo.setWeatherInfoDescription(day, "Sonnig");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Sun.png");

    }else if(description == "Clouds"){

        weatherInfo.setWeatherInfoDescription(day, "Bewölkt");
        weatherInfo.setWeatherInfoIcon(day, "qrc:/Icons/Weather/Cloud.png");

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

QString WeatherForcast::getWeatherLocation(){
    return weatherInfo.getCityName();
}

QString WeatherForcast::getWeatherDescription(const int &position){
    return weatherInfo.getWeatherInfoDescription(position);
}

QString WeatherForcast::getWeatherTemperature(const int &position){
    return weatherInfo.getWeatherInfotemp(position);
}

QString WeatherForcast::getWeatherHumidity(const int &position){
    return weatherInfo.getWeatherInfoHumidity(position);
}

QString WeatherForcast::getWeatherIcon(const int &position){
    return weatherInfo.getWeatherInfoIcon(position);
}

QString WeatherForcast::getWeatherDay(const int &position){
    return weatherInfo.getWeatherInfoDateTime(position);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
