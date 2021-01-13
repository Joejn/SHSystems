#ifndef ACCESCONTROLEVENT_H
#define ACCESCONTROLEVENT_H

#include <QObject>
#include <QDate>
#include <QTime>
#include <QString>

class AccesControlEvent : public QObject
{
    Q_OBJECT

    Q_PROPERTY(unsigned int id READ id WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QDateTime scanDateTime READ scanDateTime WRITE setScanDateTime NOTIFY scanDateTimeChanged)

private:
    /* QDate m_entryDate;
    QDateTime m_entryTimeFrom;
    QDateTime m_entryTimeTo;
    QString m_title;
    QString m_content; */

    unsigned int m_id;
    QString m_name;
    QDateTime m_scanDateTime;

public:
    explicit AccesControlEvent(QObject *parent = nullptr);

    /* void setEntryDate(QDate &date);
    void setEntryTimeFrom(QDateTime &time);
    void setEntryTimeTo(QDateTime &time);
    void setTitle(QString title);
    void setContent(QString content);

    QDate entryDate();
    QDateTime entryTimeFrom();
    QDateTime entryTimeTo();
    QString title();
    QString content(); */

    void setId(unsigned int &id);
    void setName(QString &name);
    void setScanDateTime(QDateTime &scanDateTime);

    unsigned int id();
    QString name();
    QDateTime scanDateTime();

signals:
    /* void entryDateChanged();
    void entryTimeFromChanged();
    void entryTimeToChanged();
    void titleChanged();
    void contentChanged(); */

    void idChanged();
    void nameChanged();
    void scanDateTimeChanged();

};

#endif // ACCESCONTROLEVENT_H
