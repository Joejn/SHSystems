#include "accescontrol.h"
#include "accescontrolevent.h"

#include <QDebug>

AccesControl::AccesControl(QObject *parent) : QObject(parent)
{

}

QList<QObject *> AccesControl::getAccesControlEntrys()
{
    /* QList <QObject*> EntrysList;
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
    } */

    QList <QObject*> EntrysList;

    AccesControlEvent *event = new AccesControlEvent(this);

    unsigned int id = 8;
    QString name = "Alex";
    QDateTime scanDateTime = QDateTime::currentDateTime();

    event->setId(id);
    event->setName(name);
    event->setScanDateTime(scanDateTime);

    EntrysList.append(event);

    return EntrysList;
}
