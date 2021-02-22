import QtQuick 2.0
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import com.SmartHome.WeatherForcast 1.0

BackgroundPage {
    id: ackgroundPage
    width: 1920
    height: 1080

    WeatherForcast{
        id: weatherForecast
    }

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue
        }
    }

    Component.onCompleted: {
        getDate();
    }

    RowLayout {
        id: weatherForecastRowLayout
        y: 745
        height: 239
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        anchors.bottomMargin: 80
        transformOrigin: Item.Center
        clip: false
        spacing: 0

        Column {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 8


            Image {
                id: image_WeatherForcast1
                width: weatherForecastRowLayout.width / 6
                height: 140
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: label_WeatherForcastDescription1
                width: image_WeatherForcast1.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }


            Label {
                id: label_WeatherForcastTemperature1
                width: image_WeatherForcast1.width
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }

            Label {
                id: label_WeatherForcastDay1
                width: image_WeatherForcast1.width
                height: 25
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }
        }

        Column {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 8
            Image {
                id: image_WeatherForcast2
                width: weatherForecastRowLayout.width / 6
                height: 140
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: label_WeatherForcastDescription2
                width: image_WeatherForcast2.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }


            Label {
                id: label_WeatherForcastTemperature2
                width: image_WeatherForcast2.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }

            Label {
                id: label_WeatherForcastDay2
                width: image_WeatherForcast2.width
                height: 25
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }
        }

        Column {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 8
            Image {
                id: image_WeatherForcast3
                width: weatherForecastRowLayout.width / 6
                height: 140
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: label_WeatherForcastDescription3
                width: image_WeatherForcast3.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }


            Label {
                id: label_WeatherForcastTemperature3
                width: image_WeatherForcast3.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }

            Label {
                id: label_WeatherForcastDay3
                width: image_WeatherForcast3.width
                height: 25
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }
        }

        Column {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 8
            Image {
                id: image_WeatherForcast4
                width: weatherForecastRowLayout.width / 6
                height: 140
                fillMode: Image.PreserveAspectFit
            }

            Label {
                id: label_WeatherForcastDescription4
                width: image_WeatherForcast4.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }


            Label {
                id: label_WeatherForcastTemperature4
                width: image_WeatherForcast4.width
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }

            Label {
                id: label_WeatherForcastDay4
                width: image_WeatherForcast4.width
                height: 25
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
            }
        }
    }

    Row {
        id: currentWeatherRowLayout
        height: 400
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.leftMargin: 80
        anchors.rightMargin: 80

        Column {
            id: currentWeatherColumnLayout
            width: parent.width / 4
            height: 208
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 0
            spacing: 16

            Label {
                id: label_CurrentLocation
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 21
                minimumPointSize: 4
                fontSizeMode: Text.Fit
                width: parent.width
            }

            Label {
                id: label_CurrentDesciption
                font.pointSize: 21
                minimumPointSize: 4
                fontSizeMode: Text.Fit
                width: parent.width
            }

            Label {
                id: label_CurrentTemperature
                font.pointSize: 21
                minimumPointSize: 4
                fontSizeMode: Text.Fit
                width: parent.width
            }

            Label {
                id: label_CurrentHumidity
                font.pointSize: 21
                minimumPointSize: 4
                fontSizeMode: Text.Fit
                width: parent.width
            }
        }

        Image {
            id: image_currentWeather
            width: parent.width / 4
            anchors.left: currentWeatherColumnLayout.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            fillMode: Image.PreserveAspectFit
        }
    }

    Timer{
        id: timer_reconnect;
        interval: 200000
        running: true
        repeat: true
        onTriggered: getDate();
    }

    function getDate(){
        if(weatherForecast.pingServer("api.openweathermap.org")){
            weatherForecast.insertData();

            label_CurrentLocation.text = weatherForecast.getWeatherLocation();
            label_CurrentDesciption.text = weatherForecast.getWeatherDescription(0);
            label_CurrentTemperature.text = weatherForecast.getWeatherTemperature(0);
            label_CurrentHumidity.text = weatherForecast.getWeatherHumidity(0);
            image_currentWeather.source = weatherForecast.getWeatherIcon(0);

            label_WeatherForcastDescription1.text = weatherForecast.getWeatherDescription(1);
            label_WeatherForcastTemperature1.text = weatherForecast.getWeatherTemperature(1);
            label_WeatherForcastDay1.text = weatherForecast.getWeatherDay(1);
            image_WeatherForcast1.source = weatherForecast.getWeatherIcon(1);

            label_WeatherForcastDescription2.text = weatherForecast.getWeatherDescription(2);
            label_WeatherForcastTemperature2.text = weatherForecast.getWeatherTemperature(2);
            label_WeatherForcastDay2.text = weatherForecast.getWeatherDay(2);
            image_WeatherForcast2.source = weatherForecast.getWeatherIcon(2);

            label_WeatherForcastDescription3.text = weatherForecast.getWeatherDescription(3);
            label_WeatherForcastTemperature3.text = weatherForecast.getWeatherTemperature(3);
            label_WeatherForcastDay3.text = weatherForecast.getWeatherDay(3);
            image_WeatherForcast3.source = weatherForecast.getWeatherIcon(3);

            label_WeatherForcastDescription4.text = weatherForecast.getWeatherDescription(4);
            label_WeatherForcastTemperature4.text = weatherForecast.getWeatherTemperature(4);
            label_WeatherForcastDay4.text = weatherForecast.getWeatherDay(4);
            image_WeatherForcast4.source = weatherForecast.getWeatherIcon(4);
        } else {

            label_CurrentLocation.text = "Daten konnten nicht abgefragt werden";
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
