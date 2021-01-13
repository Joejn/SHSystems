#ifndef SETTINGSBACKEND_H
#define SETTINGSBACKEND_H

#include <QObject>

class SettingsBackEnd : public QObject
{
    Q_OBJECT
public:
    explicit SettingsBackEnd(QObject *parent = nullptr);

signals:

};

#endif // SETTINGSBACKEND_H
