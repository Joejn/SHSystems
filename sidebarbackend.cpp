#include "sidebarbackend.h"
#include <QDebug>

SideBarBackend::SideBarBackend(QObject *parent) : QObject(parent)
{

}

QString SideBarBackend::getCurrentDateTime(){
    return QDateTime::currentDateTime().toString("dddd \n hh:mm");
}
