#ifndef EXPORTSENSORDATA_H
#define EXPORTSENSORDATA_H

#include <QObject>
#include <QtSql/QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QList>

#include "config.h"
#include "dbadministration.h"

class ExportSensorData : public QObject
{
    Q_OBJECT

public:
    explicit ExportSensorData(QObject *parent = nullptr);

    Q_INVOKABLE void exportData(bool CSV, bool XML, bool HTML);
    void exportDataCSV(const QList<QString> &tables);
    void exportDataXML(const QList<QString> &tables);
    void exportDataHTML(const QList<QString> &tables);

public slots:
    void setIsConnected(const bool &isConnected);

private:
    DbAdministration *m_db;
    QString m_dbHostname;
    QString m_dbName;
    QString m_dbUser;
    QString m_exportFolderPath;
    Config m_config;
    bool m_isConnected;

signals:
    void isConnectedChanged(const bool &isConnected);

};

#endif // EXPORTSENSORDATA_H
