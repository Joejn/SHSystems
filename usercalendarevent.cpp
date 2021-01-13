#include "usercalendarevent.h"
#include <QDebug>

UserCalendarEvent::UserCalendarEvent(QObject *parent) : QObject(parent)
{

}

void UserCalendarEvent::setEntryDate(QDate &date)
{
    if(date != this->m_entryDate){
        this->m_entryDate = date;
        emit entryDateChanged();
    }
}

void UserCalendarEvent::setEntryTimeFrom(QDateTime &time)
{
    if(time != this->m_entryTimeFrom){
        this->m_entryTimeFrom = time;
        emit entryTimeFrom();
    }
}

void UserCalendarEvent::setEntryTimeTo(QDateTime &time)
{
    if(time != this->m_entryTimeTo){
        this->m_entryTimeTo = time;
        emit entryTimeTo();
    }
}

void UserCalendarEvent::setTitle(QString title)
{
    if(title != this->m_title){
        this->m_title = title;
        emit titleChanged();
    }
}

void UserCalendarEvent::setContent(QString content)
{
    if(content != this->m_content){
        this->m_content = content;
        emit contentChanged();
    }
}

QDate UserCalendarEvent::entryDate()
{
    return this->m_entryDate;
}

QDateTime UserCalendarEvent::entryTimeFrom()
{
    return this->m_entryTimeFrom;
}

QDateTime UserCalendarEvent::entryTimeTo()
{
    return this->m_entryTimeTo;
}

QString UserCalendarEvent::title()
{
    return this->m_title;
}

QString UserCalendarEvent::content()
{
    return this->m_content;
}
