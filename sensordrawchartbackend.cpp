#include "sensordrawchartbackend.h"

#include <QDebug>
#include <QDateTime>
#include <fstream>

SensorDrawChartBackend::SensorDrawChartBackend(QObject *parent) :
    QObject(parent),
    m_dbConnectionInfo("Es konnten keine Daten abgerufen werden")
{
    m_hostName = m_config.getData("mqtt/hostname", false);
    m_port = (m_config.getData("mqtt/port", false)).toInt();

    m_client = new QMqttClient(this);
    m_client->setHostname(m_hostName);
    m_client->setPort(m_port);

    if(m_client->state() == QMqttClient::Disconnected){
        m_client->connectToHost();
    }

    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);

    //////////////////////////////

    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);
    m_db = new DbAdministration(this, m_dbHostname, m_dbName, m_dbUser, m_config.getData("db/password", true));

    connect(m_db, SIGNAL(isConnectedChanged(const bool&)), this, SLOT(setIsConnected(const bool&)));
}

void SensorDrawChartBackend::setTable(QString table)
{
    m_tableName = table;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

QList<QVariant> SensorDrawChartBackend::get_X_Axie()
{
    get_X_min();
    get_X_max();
    return m_sensorValues.first;
}

QList<QVariant> SensorDrawChartBackend::get_Y_Axie()
{
    return m_sensorValues.second;
}

QVariant SensorDrawChartBackend::get_X_min()
{
    if(m_sensorValues.first.empty()){
        return QDateTime::currentDateTime();
    }
    return *std::min_element(m_sensorValues.first.begin(), m_sensorValues.first.end());
}

QVariant SensorDrawChartBackend::get_X_max()
{
    if(m_sensorValues.first.empty()){
        return QDateTime::currentDateTime().addDays(1);
    }

    return *std::max_element(m_sensorValues.first.begin(), m_sensorValues.first.end());
}

QVariant SensorDrawChartBackend::get_Y_min()
{
    if(m_sensorValues.second.empty()){
        return 0;
    }

    int min = std::min_element(m_sensorValues.second.begin(), m_sensorValues.second.end())->toInt();
    int min_rounded = ((min + 10 / 2) / 10) * 10;
    if(min_rounded > min){
        min_rounded -= 10;
    }

    return min_rounded;
}

QVariant SensorDrawChartBackend::get_Y_max()
{
    if(m_sensorValues.second.empty()){
        return 30;
    }

    int max = std::max_element(m_sensorValues.second.begin(), m_sensorValues.second.end())->toInt();
    int max_rounded = ((max + 10 / 2) / 10) * 10;
    if(max_rounded > max){
        max_rounded += 10;
    }

    return max_rounded;
}

QVariant SensorDrawChartBackend::tickCountAxisY()
{
    int tickCount = ((get_Y_max().toInt() - get_Y_min().toInt()) + 10) / 10;
    return tickCount;
}

bool SensorDrawChartBackend::addSensor(QString sensorName, QString type, unsigned int pin)
{
    bool isInserted = false;

    QString tableName = "sensore_" + type + "_" + sensorName;
    QString statement = "INSERT INTO table_sensor_info (table_name, pin) VALUES ('" + tableName + "', " + QString::number(pin) + ");";

    if(m_db->execStatement(statement)){
        qDebug() << "db";
        statement = "CREATE TABLE " + tableName + " (measurementdatetime timestamp without time zone PRIMARY KEY NOT NULL, "
                                                           "sensorevalue numeric NOT NULL);";
        if(m_db->execStatement(statement)){
            isInserted = true;
        } else {
            statement = "DELETE FROM table_sensor_pin WHERE table_name = '" + tableName + "'";
            m_db->execStatement(statement);
        }
    }

    if(isInserted)
        emit sensorTabelesChanged();

    return isInserted;
}

void SensorDrawChartBackend::publishDataAddSensor(QString name, QString type, int pin)
{
    QString topic = "Sensors/addSensorGet";
    m_client->publish(topic, name.toUtf8());
}

///////////////////////////////////////////////////////////////////////////

void SensorDrawChartBackend::setSensorTables()
{
    QString statement = "SELECT * FROM information_schema.tables WHERE table_name LIKE 'sensore%'";
     if(m_db->setDataListFromDb(statement, "2")){
        m_sensorTables.clear();
        m_sensorTables = m_db->getDataListFromDb(0);
        emit sensorTabelesChanged();
    }
}

void SensorDrawChartBackend::setIsConnected(const bool &isConnected)
{
    m_isConnected = isConnected;
    emit isConnectedChanged(m_isConnected);
}

///////////////////////////////////////////////////////////////////////////

QStringList SensorDrawChartBackend::getSensorTables()
{
    return m_sensorTables;
}

void SensorDrawChartBackend::set_sensorValues()
{
    m_sensorValues.first.clear();
    m_sensorValues.second.clear();
    QDateTime currentDateTime = QDateTime::currentDateTime();
    QString statement = "SELECT * FROM " + m_tableName + " WHERE measurementdatetime BETWEEN '" + currentDateTime.addDays(-1).toString("yyyy-MM-dd hh:mm") + "'::timestamp AND '" + currentDateTime.toString("yyyy-MM-dd hh:mm") + "'::timestamp";
    qDebug() << statement;
    if(m_db->setDataListFromDb(statement, "0;1")){
        QStringList dateTime = m_db->getDataListFromDb(0);
        QStringList value = m_db->getDataListFromDb(1);
        int lenght = dateTime.length();
        if(dateTime.length() < value.length()){
            lenght = dateTime.length();
        } else if (dateTime.length() > value.length()){
            lenght = value.length();
        }
        for(int i = 0; i < lenght; ++i){
            m_sensorValues.first.append(QDateTime::fromString(dateTime.at(i), Qt::ISODate));
            m_sensorValues.second.append(value.at(i).toFloat());
        }
    }
}

