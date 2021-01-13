#ifndef USERCALENDARBACKEND_H
#define USERCALENDARBACKEND_H

#include <QObject>
#include <QList>
#include "usercalendarevent.h"
#include "config.h"
#include "dbadministration.h"

class UserCalendarBackend : public QObject
{
    Q_OBJECT

public:
    explicit UserCalendarBackend(QObject *parent = nullptr);

    Q_INVOKABLE QList<QObject*> getEntrysForDate(const QDate &date);
    Q_INVOKABLE bool insertIntoDatabase(QDate selectedDate, QString title, QString content, QString timeFrom, QString timeTo);
    Q_INVOKABLE void setCurrentDate();

public slots:
    void setIsConnected(const bool &isConnected);

private:
    DbAdministration *m_db_02;
    QSqlDatabase m_db;
    QString m_dbHostname;
    QString m_dbName;
    QString m_dbUser;
    Config m_config;
    bool m_isConnected;

signals:
    void isConnectedChanged(const bool &isConnected);
    void currentDateChanged();

};

#endif // USERCALENDARBACKEND_H
