#include "accescontrolevent.h"

AccesControlEvent::AccesControlEvent(QObject *parent) : QObject(parent)
{

}

void AccesControlEvent::setId(unsigned int &id)
{
    if(id != this->m_id){
        this->m_id = id;
        emit idChanged();
    }
}

void AccesControlEvent::setName(QString &name)
{
    if(name != this->m_name){
        this->m_name = name;
        emit nameChanged();
    }
}

void AccesControlEvent::setScanDateTime(QDateTime &scanDateTime)
{
    if(scanDateTime != this->m_scanDateTime){
        this->m_scanDateTime = scanDateTime;
        emit scanDateTimeChanged();
    }
}

unsigned int AccesControlEvent::id()
{
    return m_id;
}

QString AccesControlEvent::name()
{
    return m_name;
}

QDateTime AccesControlEvent::scanDateTime()
{
    return m_scanDateTime;
}
