#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QApplication>
#include "sensordrawchartbackend.h"
#include "settingsbackend.h"
#include "weatherforcast.h"
#include "sidebarbackend.h"
#include "usercalendarbackend.h"
#include "exportsensordata.h"
#include "ledcontroller.h"
#include "lighting.h"
#include "config.h"
#include "entertainment.h"

#include <QStringListModel>
#include <QQmlContext>

#include <QQmlComponent>

int main(int argc, char *argv[])
{

    // qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQuickStyle::setStyle("Material");

    qmlRegisterType<SensorDrawChartBackend>("com.SmartHome.SensorDrawChartBackend", 1, 0, "SensorDrawChartBackend");
    qmlRegisterType<SettingsBackEnd>("com.SmartHome.SettingsBackEnd", 1, 0, "SettingsBackEnd");
    qmlRegisterType<WeatherForcast>("com.SmartHome.WeatherForcast", 1, 0, "WeatherForcast");
    qmlRegisterType<SideBarBackend>("com.SmartHome.SideBarBackend", 1, 0, "SideBarBackend");
    qmlRegisterType<UserCalendarBackend>("com.SmartHome.UserCalendar", 1, 0, "UserCalendarBackend");
    qmlRegisterType<ExportSensorData>("com.SmartHome.ExportSensorData", 1, 0, "ExportSensorData");
    qmlRegisterType<LedController>("com.SmartHome.LedController", 1, 0, "LedController");
    qmlRegisterType<Lighting>("com.SmartHome.Lighting", 1, 0, "Lighting");
    qmlRegisterType<Config>("com.SmartHome.Config", 1, 0, "Config");
    qmlRegisterType<Entertainment>("com.SmartHome.Entertainment", 1, 0, "Entertainment");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
