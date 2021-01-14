#include "exportsensordata.h"

#include <QDateTime>
#include <QDebug>
#include <QDir>
#include <QList>

ExportSensorData::ExportSensorData(QObject *parent) : QObject(parent)
{
    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);
    m_db = new DbAdministration(this, m_dbHostname, m_dbName, m_dbUser, m_config.getData("db/password", true));
    connect(m_db, SIGNAL(isConnectedChanged(const bool&)), this, SLOT(setIsConnected(const bool&)));
}

void ExportSensorData::exportData(bool CSV, bool XML, bool HTML)
{
    m_exportFolderPath = m_config.getData("general/export_path", false);
    m_exportFolderPath.replace("\\", "/");
    m_exportFolderPath += "/" + QDateTime::currentDateTime().toString("dd_MM_yyyy_hh_mm") + "_sensor_data_export/";

    QList<QString> tableNames;
    QString statement = "SELECT * FROM information_schema.tables WHERE table_name LIKE 'sensore%'";

    if(m_db->setDataListFromDb(statement, "2")){

        if(!(QDir(m_exportFolderPath).exists())){
            QDir().mkdir(m_exportFolderPath);
        }

        tableNames = m_db->getDataListFromDb(0);

        QList<QString> tables;

            if(CSV)
                ExportSensorData::exportDataCSV(tableNames);

            if(XML)
                ExportSensorData::exportDataXML(tableNames);

            if(HTML)
                ExportSensorData::exportDataHTML(tableNames);
    }
}

void ExportSensorData::exportDataCSV(const QList<QString> &tables){
    QString filePath = m_exportFolderPath + QDateTime::currentDateTime().toString("dd_MM_yyyy_hh_mm") + "_export_data.csv";
    QFile fileExport(filePath);
    QTextStream streamExport(&fileExport);
    QString statement;

    if(fileExport.open(QIODevice::WriteOnly)){
        for(int i = 0; i < tables.size(); ++i){
            statement = "SELECT * FROM " + tables.at(i);
            m_db->setDataListFromDb(statement, "0;1");
            QStringList data = m_db->getDataListFromDb(1);

            streamExport << "\n" << tables.at(i) << "\n\n";
            unsigned int j = 0;
            for(const auto &val : m_db->getDataListFromDb(0)){
                streamExport << (QDateTime::fromString(val, Qt::ISODate)).toString("dd.MM.yyyy hh:mm") << ";" << data.at(j) << "\n";
                ++j;
            }
        }
        fileExport.close();
    }
}

void ExportSensorData::exportDataXML(const QList<QString> &tables){
    QString filePath = m_exportFolderPath + QDateTime::currentDateTime().toString("dd_MM_yyyy_hh_mm") + "_export_data.xml";
    QFile fileExport(filePath);
    QTextStream streamExport(&fileExport);
    QString statement;

    if(fileExport.open(QIODevice::WriteOnly)){
        streamExport << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
        streamExport << "<all_sensors>\n\n";

        for(int i = 0; i < tables.size(); ++i){
            streamExport << "<sensor>\n";
            streamExport << "<name>";
            streamExport << tables.at(i);
            streamExport << "</name>\n";
            streamExport << "<values>\n";

            statement = "SELECT * FROM " + tables.at(i);
            m_db->setDataListFromDb(statement, "0;1");
            QStringList data = m_db->getDataListFromDb(1);

            unsigned int j = 0;
            for(const auto &val : m_db->getDataListFromDb(0)){
                streamExport << "<date_time>" << (QDateTime::fromString(val, Qt::ISODate)).toString("dd.MM.yyyy hh:mm") << "<date_time>\n";
                streamExport << "<value>" << data.at(j) << "<value>\n";
                ++j;
            }

            streamExport << "</values>\n";
            streamExport << "</sensor>\n";
        }

        streamExport << "</all_sensors>";
        fileExport.close();
    }
}

void ExportSensorData::exportDataHTML(const QList<QString> &tables){
    QString filePath = m_exportFolderPath + QDateTime::currentDateTime().toString("dd_MM_yyyy_hh_mm") + "_export_data.html";
    QFile fileExport(filePath);
    QTextStream streamExport(&fileExport);
    QString statement;

    if(fileExport.open(QIODevice::WriteOnly)){
        streamExport << "<!DOCTYPE html> \n\n";
        streamExport << "<html>\n";
        streamExport << "\t<head>\n";
        streamExport << "\t\t<meta charset=\"UTF-8\">\n";
        streamExport << "\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">";
        streamExport << "\t\t<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css\">";
        streamExport << "\t\t<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js\"></script>";
        streamExport << "\t\t<script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js\"></script>";
        streamExport << "\t</head>\n";
        streamExport << "\t<body>\n";

        streamExport << "\t<div class=\"container\">";
        streamExport << "\t\t<h2> Sensoren </h2>";

        //////////////

        for(const auto &val : tables){
            QStringList tableStringList = (val.split(QLatin1Char('_')));
            QString name = "";
            if(tableStringList.at(1) == "temperature")
                name += "Temperatursensor: ";
            else
                name += "Luftfeuchtigkeitssensor: ";
            name += tableStringList.at(2);
            QString id = "collapse_" + val;
            streamExport << "\t\t<div class=\"panel-group\">\n";
            streamExport << "\t\t<div class=\"panel panel-default\">\n";
            streamExport << "\t\t<div class=\"panel-heading\">\n";
            streamExport << "\t\t<h4 class=\"panel-title\">\n";
            streamExport << "\t\t<a data-toggle=\"collapse\" href=\"#" + id + "\">" + name + "</a>\n";
            streamExport << "\t\t</h4>\n";
            streamExport << "\t\t</div>\n";
            streamExport << "\t\t<div id=\"" + id + "\" class=\"panel-collapse collapse\">\n";
            streamExport << "\t\t<div class=\"panel-body\">\n";

            streamExport << "\t\t<table class=\"table\">\n";
            streamExport << "\t\t<thead>\n";
            streamExport << "\t\t<tr>\n";
            streamExport << "\t\t<th scope=\"col\">Datum und Zeit</th>\n";
            streamExport << "\t\t<th scope=\"col\">Wert</th>\n";
            streamExport << "\t\t</tr>\n";
            streamExport << "\t\t</thead>\n";
            streamExport << "\t\t<tbody>\n";

            //////////////

            statement = "SELECT * FROM " + val;
            m_db->setDataListFromDb(statement, "0;1");
            QStringList data = m_db->getDataListFromDb(1);

            unsigned int j = 0;
            for(const auto &val : m_db->getDataListFromDb(0)){
                streamExport << "\t\t<tr>\n";
                streamExport << "\t\t<td>" + (QDateTime::fromString(val, Qt::ISODate)).toString("dd.MM.yyyy hh:mm") + "</td>\n";
                streamExport << "\t\t<td>" + data.at(j) + "</td>\n";
                streamExport << "\t\t</tr>\n";
                ++j;
            }

            streamExport << "\t\t<tr>\n";
            streamExport << "\t\t</tr>\n";

            streamExport << "\t\t</tbody>\n";
            streamExport << "\t\t</table>\n";

            streamExport << "\t\t</div>\n";
            streamExport << "\t\t</div>\n";
            streamExport << "\t\t</div>\n";
            streamExport << "\t\t</div>\n";
            streamExport << "\t\t</div>\n";
            streamExport << "\t\t</div>\n";
            streamExport << "\t\t</html>\n";
        }
    }
}

void ExportSensorData::setIsConnected(const bool &isConnected)
{
    m_isConnected = isConnected;
    emit isConnectedChanged(m_isConnected);
}
