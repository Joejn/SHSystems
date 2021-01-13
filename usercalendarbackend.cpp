#include "usercalendarbackend.h"
#include <QList>
#include <QDebug>
#include <QSqlQuery>

UserCalendarBackend::UserCalendarBackend(QObject *parent) : QObject(parent)
{
    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);

    m_dbHostname = m_config.getData("db/hostname", false);
    m_dbName = m_config.getData("db/name", false);
    m_dbUser = m_config.getData("db/user", false);

    m_db_02 = new DbAdministration(this, m_dbHostname, m_dbName, m_dbUser, m_config.getData("db/password", true));

    connect(m_db_02, SIGNAL(isConnectedChanged(const bool&)), this, SLOT(setIsConnected(const bool&)));
}

QList<QObject*> UserCalendarBackend::getEntrysForDate(const QDate &date)
{
    QList <QObject*> EntrysList;
    QString statement = "SELECT * FROM table_entrys WHERE ENTRYDATE = '" + date.toString("yyyy-MM-dd") + "';";

    if(m_db_02->setDataListFromDb(statement, "0;1;2;3;4")){
        QList<QStringList> dbContent;
        dbContent.append(m_db_02->getDataListFromDb(0));
        dbContent.append(m_db_02->getDataListFromDb(1));
        dbContent.append(m_db_02->getDataListFromDb(2));
        dbContent.append(m_db_02->getDataListFromDb(3));
        dbContent.append(m_db_02->getDataListFromDb(4));

        for(int i = 0; i < dbContent.at(0).length(); ++i){

            UserCalendarEvent *event = new UserCalendarEvent(this);

            QDate entryDate = QDate::fromString(dbContent.at(0).at(i));
            event->setEntryDate(entryDate);

            QDateTime entryTimeFrom = QDateTime::fromString(dbContent.at(1).at(i), Qt::ISODate);
            event->setEntryTimeFrom(entryTimeFrom);

            QDateTime entryTimeTo = QDateTime::fromString(dbContent.at(2).at(i), Qt::ISODate);
            event->setEntryTimeTo(entryTimeTo);

            event->setTitle(dbContent.at(3).at(i));
            event->setContent(dbContent.at(4).at(i));

            EntrysList.append(event);
        }
    }

    return EntrysList;
}

int getHours(QString &time){
    bool isHours = true;
    QString tmp = "";
    for(int i = 0; i < time.length(); i++){
        if(time[i] == ":")
            isHours = false;
        if(isHours)
            tmp += time[i];
    }

    return tmp.toInt();
}

int getMinutes(QString &time){
    bool isMinutes = false;
    QString tmp = "";
    for(int i = 0; i < time.length(); i++){

        if(isMinutes)
            tmp += time[i];

        if(time[i] == ":")
            isMinutes = true;
    }
    return tmp.toInt();
}

bool UserCalendarBackend::insertIntoDatabase(QDate selectedDate, QString title, QString content, QString timeFrom, QString timeTo)
{
    QDateTime dateTimeFrom;
    QDateTime dateTimeTo;
    dateTimeFrom.setDate(selectedDate);
    dateTimeFrom.setTime(QTime(getHours(timeFrom), getMinutes(timeFrom), 0));

    dateTimeTo.setDate(selectedDate);
    dateTimeTo.setTime(QTime(getHours(timeTo), getMinutes(timeTo), 0));
    QString statement = "INSERT INTO table_entrys (entrydate, entrytimefrom, entrytimeto, title, content)"
                        " VALUES ('" + selectedDate.toString("yyyy-MM-dd") + "', '" + dateTimeFrom.toString("yyyy-MM-dd hh:mm")
                        + "', '" + dateTimeTo.toString("yyyy-MM-dd hh:mm") + "', '" + title + "', '" + content + "');";

    return m_db_02->execStatement(statement);
}

void UserCalendarBackend::setCurrentDate()
{
    emit currentDateChanged();
}

void UserCalendarBackend::setIsConnected(const bool &isConnected)
{
    qDebug() << "slot";
    m_isConnected = isConnected;
    emit isConnectedChanged(m_isConnected);
}


