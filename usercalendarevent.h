#ifndef USERCALENDAREVENT_H
#define USERCALENDAREVENT_H

#include <QObject>
#include <QDate>
#include <QTime>
#include <QString>

class UserCalendarEvent : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QDate entryDate READ entryDate WRITE setEntryDate NOTIFY entryDateChanged)
    Q_PROPERTY(QDateTime entryTimeFrom READ entryTimeFrom WRITE setEntryTimeFrom NOTIFY entryTimeFromChanged)
    Q_PROPERTY(QDateTime entryTimeTo READ entryTimeTo WRITE setEntryTimeTo NOTIFY entryTimeToChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString content READ content WRITE setContent NOTIFY contentChanged)

private:
    QDate m_entryDate;
    QDateTime m_entryTimeFrom;
    QDateTime m_entryTimeTo;
    QString m_title;
    QString m_content;

public:
    explicit UserCalendarEvent(QObject *parent = nullptr);

    void setEntryDate(QDate &date);
    void setEntryTimeFrom(QDateTime &time);
    void setEntryTimeTo(QDateTime &time);
    void setTitle(QString title);
    void setContent(QString content);

    QDate entryDate();
    QDateTime entryTimeFrom();
    QDateTime entryTimeTo();
    QString title();
    QString content();

signals:
    void entryDateChanged();
    void entryTimeFromChanged();
    void entryTimeToChanged();
    void titleChanged();
    void contentChanged();
};

#endif // USERCALENDAREVENT_H
