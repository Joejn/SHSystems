import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0

Window {
    id: window
    visible: true
    width: 1600
    height: 800
    flags: Qt.Window | Qt.FramelessWindowHint

    Material.theme: Material.Light;
    Material.accent: Material.LightBlue;

    property bool hover_exit: false
    property bool hover_window: false
    property bool hover_max: false

    property color titleBarIconsColorNormal: "#ffffff"
    property color titleBarIconsColorHover: "#8a8a8a"
    property color titleBarLeftColor: sideBar.color
    property color titleBarRightColor: "#3a3a3a"

    property int minimumWidth: 1400
    property int minimumHeight: 600

    Rectangle {
        id: rectangle_titlebar
        height: 40
        color: "#ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        Rectangle {
            id: rectangle_titleBarRight
            color: titleBarRightColor
            anchors.left: rectangle_titleBarLeft.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.leftMargin: 0

            MouseArea {
                id: mouseArea_exit
                x: 1238
                width: 60
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                hoverEnabled: true
                onHoveredChanged: {
                    if(hover_exit){
                        colorOverlay_exit.color = titleBarIconsColorNormal
                    } else {
                        colorOverlay_exit.color = titleBarIconsColorHover
                    }

                    hover_exit = !hover_exit
                }

                onClicked: {
                    window.close()
                }

                Image {
                    id: image_exit
                    anchors.fill: parent
                    source: "qrc:/Icons/Titlebar/x.svg"
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                    fillMode: Image.PreserveAspectFit
                }

                ColorOverlay{
                    id: colorOverlay_exit
                    anchors.fill: image_exit
                    source: image_exit
                    color: titleBarIconsColorNormal
                }
            }

            MouseArea {
                id: mouseArea_window
                x: 1238
                width: 60
                anchors.right: mouseArea_exit.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                hoverEnabled: true
                anchors.rightMargin: 0
                onHoveredChanged: {
                    if(hover_window){
                        colorOverlay_window.color = titleBarIconsColorNormal
                    } else {
                        colorOverlay_window.color = titleBarIconsColorHover
                    }

                    hover_window = !hover_window
                }

                onClicked: {
                    if(window.visibility === 4){
                        window.visibility = "Windowed"
                        image_window.source = "qrc:/Icons/Titlebar/square.svg"
                    } else if(window.visibility === 2) {
                        window.visibility = "Maximized"
                        image_window.source = "qrc:/Icons/Titlebar/double_square.svg"
                    }
                }

                Image {
                    id: image_window
                    anchors.fill: parent
                    source: "qrc:/Icons/Titlebar/square.svg"
                    anchors.rightMargin: 8
                    anchors.leftMargin: 8
                    anchors.bottomMargin: 8
                    anchors.topMargin: 8
                    sourceSize.height: parent.height
                    sourceSize.width: parent.width
                    fillMode: Image.PreserveAspectFit
                }

                ColorOverlay{
                    id: colorOverlay_window
                    anchors.fill: image_window
                    source: image_window
                    color: titleBarIconsColorNormal
                }
            }

            MouseArea {
                id: mouseArea_max
                x: 1238
                width: 60
                anchors.right: mouseArea_window.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                hoverEnabled: true
                anchors.rightMargin: 0
                onHoveredChanged: {
                    if(hover_max){
                        colorOverlay_max.color = titleBarIconsColorNormal
                    } else {
                        colorOverlay_max.color = titleBarIconsColorHover
                    }

                    hover_max = !hover_max
                }

                onClicked: {
                    window.visibility = "Minimized"
                }

                Image {
                    id: image_max
                    anchors.fill: parent
                    source: "qrc:/Icons/Titlebar/max.svg"
                    sourceSize.height: parent.height
                    fillMode: Image.PreserveAspectFit
                    sourceSize.width: parent.width
                }

                ColorOverlay{
                    id: colorOverlay_max
                    anchors.fill: image_max
                    source: image_max
                    color: titleBarIconsColorNormal
                }
            }

            MouseArea {
                id: mouseArea_drag_02
                anchors.left: parent.left
                anchors.right: mouseArea_max.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0

                property variant clickPos: "1,1"

                onPressed: {
                    clickPos = Qt.point(mouse.x, mouse.y)
                }

                onPositionChanged: {
                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    window.x += delta.x
                    window.y += delta.y
                }
            }
        }

        Rectangle {
            id: rectangle_titleBarLeft
            width: 300
            color: titleBarLeftColor
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.topMargin: 0
            anchors.leftMargin: 0

            MouseArea {
                id: mouseArea_drag_01
                anchors.fill: parent

                property variant clickPos: "1,1"

                onPressed: {
                    clickPos = Qt.point(mouse.x, mouse.y)
                }

                onPositionChanged: {
                    var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                    window.x += delta.x
                    window.y += delta.y
                }
            }
        }

    }

    Rectangle {
        id: rectangle_main
        color: "#ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rectangle_titlebar.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 0

        BackgroundPage{
            id: backgroundPage
            width: 0;
            height: 0;
        }

        SideBar {
            id: sideBar
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.rightMargin: 1100
        }

        TabBar{
            id: tabBar
            x: 469
            y: 606
            anchors.left: sideBar.right
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            currentIndex: swipeView.currentIndex

            TabButton{
                text: qsTr("Wetter")
            }

            TabButton{
                text: qsTr("Sensoren")
            }

            TabButton{
                text: qsTr("Kalendar")
            }

            TabButton{
                text: qsTr("Beleuchtung")
            }

            TabButton{
                text: qsTr("Led Steuerung")
            }

            TabButton{
                text: qsTr("Entertainment")
            }

            TabButton{
                text: qsTr("Zugangskontrolle")
            }

            TabButton{
                text: qsTr("Einstellungen")
            }
        }

        StackLayout{
            id: swipeView
            x: 469
            y: -154
            anchors.leftMargin: 0
            anchors.bottom: tabBar.top
            anchors.rightMargin: 0
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.left: sideBar.right
            anchors.top: parent.top
            anchors.bottomMargin: 0
            currentIndex: tabBar.currentIndex

            WeatherForecast{
                id: weatherForecast
            }

            SensorChart{
                id: sensorChart
            }

            UserCalendar{
                id: userCalendar
            }

            Lightning{
                id: lightning
            }

            LedController{
                id: ledController
            }

            AudioPlayer{
                id: audioPlayer
            }

            AccessControl{
                id: accessControl
            }

            Settings{
                id: settings
            }
        }



    }

    MouseArea {
        id: mouseArea_Left
        width: 8
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeHorCursor
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0

        property int previousX

        onPressed: {
            previousX = mouse.x
        }

        onMouseXChanged: {
            var delta = mouse.x - previousX
            if((window.width - delta) > minimumWidth){
                window.setX(window.x + delta)
                window.setWidth(window.width - delta)
            } else {
                window.setWidth(minimumWidth);
            }
        }
    }

    MouseArea {
        id: mouseArea_Right
        x: 376
        width: 8
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeHorCursor
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0

       property int previousX

        onPressed: {
            previousX = mouse.x
        }

        onMouseXChanged: {
            var delta = mouse.x - previousX
            if((window.width + delta) > minimumWidth){
                window.setWidth(window.width + delta)
            } else {
                window.setWidth(minimumWidth)
            }
        }
    }

    MouseArea {
        id: mouseArea_Top
        width: 100
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.SizeVerCursor
        anchors.topMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        property int previousY

        onPressed: {
            previousY = mouse.y
        }

        onMouseYChanged: {
            var delta = mouse.y - previousY
            if((window.height - delta) > minimumHeight){
                window.setY(window.y + delta)
                window.setHeight(window.height - delta)
            } else {
                window.setHeight(minimumHeight)
            }
        }
    }

    MouseArea {
        id: mouseArea_Bottom
        y: 884
        width: 100
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeVerCursor
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        property int previousY

        onPressed: {
            previousY = mouse.y
        }

        onMouseYChanged: {
            var delta = mouse.y - previousY
            if((window.height + delta) > minimumHeight){
                window.setHeight(window.height + delta)
            } else {
                window.setHeight(minimumHeight)
            }
        }
    }

    MouseArea {
        id: mouseArea_TopLeft
        width: 8
        height: 8
        anchors.left: parent.left
        anchors.top: parent.top
        cursorShape: Qt.SizeFDiagCursor
        hoverEnabled: false
        anchors.topMargin: 0
        anchors.leftMargin: 0

        property int previousX
        property int previousY

        onPressed: {
            previousX = mouse.x
            previousY = mouse.y
        }

        onMouseXChanged: {
            var delta = mouse.x - previousX
            if((window.width - delta) > minimumWidth){
                window.setX(window.x + delta)
                window.setWidth(window.width - delta)
            } else {
                window.setWidth(minimumWidth);
            }
        }

        onMouseYChanged: {
            var delta = mouse.y - previousY
            if((window.height - delta) > minimumHeight){
                window.setY(window.y + delta)
                window.setHeight(window.height - delta)
            } else {
                window.setHeight(minimumHeight)
            }
        }
    }

    MouseArea {
        id: mouseArea_TopRight
        x: 538
        width: 8
        height: 8
        anchors.right: parent.right
        anchors.top: parent.top
        cursorShape: Qt.SizeBDiagCursor
        anchors.topMargin: 0
        anchors.rightMargin: 0

        property int previousX
        property int previousY

        onPressed: {
            previousX = mouse.x
            previousY = mouse.y
        }

        onMouseXChanged: {
            var delta = mouse.x - previousX
            if((window.width + delta) > minimumWidth){
                window.setWidth(window.width + delta)
            } else {
                window.setWidth(minimumWidth)
            }
        }

        onMouseYChanged: {
            var delta = mouse.y - previousY
            if((window.height - delta) > minimumHeight){
                window.setY(window.y + delta)
                window.setHeight(window.height - delta)
            } else {
                window.setHeight(minimumHeight)
            }
        }
    }

    MouseArea {
        id: mouseArea_BottomRight
        x: 614
        y: -242
        width: 8
        height: 8
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeFDiagCursor
        anchors.bottomMargin: 0
        anchors.rightMargin: 0

        property int previousX
        property int previousY

        onPressed: {
            previousX = mouse.x
            previousY = mouse.y
        }

        onMouseXChanged: {
            var delta = mouse.x - previousX
            if((window.width + delta) > minimumWidth){
                window.setWidth(window.width + delta)
            } else {
                window.setWidth(minimumWidth)
            }
        }

        onMouseYChanged: {
            var delta = mouse.y - previousY
            if((window.height + delta) > minimumHeight){
                window.setHeight(window.height + delta)
            } else {
                window.setHeight(minimumHeight)
            }
        }
    }

    MouseArea {
        id: mouseArea_BottomLeft
        y: 872
        width: 8
        height: 8
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        cursorShape: Qt.SizeBDiagCursor
        anchors.bottomMargin: 0
        anchors.leftMargin: 0

        property int previousX
        property int previousY

        onPressed: {
            previousX = mouse.x
            previousY = mouse.y
        }

        onMouseXChanged: {
            var delta = mouse.x - previousX
            if((window.width - delta) > minimumWidth){
                window.setX(window.x + delta)
                window.setWidth(window.width - delta)
            } else {
                window.setWidth(minimumWidth);
            }
        }

        onMouseYChanged: {
            var delta = mouse.y - previousY
            if((window.height + delta) > minimumHeight){
                window.setHeight(window.height + delta)
            } else {
                window.setHeight(minimumHeight)
            }
        }
    }


    Component.onCompleted: {
        changeTheme(settings.getTheme());
    }

    function changeTheme(theme){
        if(theme === "Light"){
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue;
            color = "#ffffff";
            weatherForecast.color = "#ffffff";
            sensorChart.color = "#ffffff";
            settings.color = "#ffffff";
            lightning.color = "#ffffff";
            accessControl.color = "#ffffff";
            titleBarRightColor = "#ffffff"
            titleBarIconsColorNormal = "#000000"
        } else {
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
            color = "#3a3a3a";
            weatherForecast.color = "#3a3a3a";
            sensorChart.color = "#3a3a3a";
            settings.color = "#3a3a3a";
            lightning.color = "#3a3a3a";
            accessControl.color = "#3a3a3a";
            titleBarRightColor = "#3a3a3a"
            titleBarIconsColorNormal = "#ffffff"
        }

        colorOverlay_exit.color =  titleBarIconsColorNormal
        colorOverlay_window.color = titleBarIconsColorNormal
        colorOverlay_max.color = titleBarIconsColorNormal

        weatherForecast.changeTheme(theme);
        sensorChart.changeTheme(theme);
        lightning.changeTheme(theme);
        settings.changeTheme(theme);
        ledController.changeTheme(theme);
        audioPlayer.changeTheme(theme);
        accessControl.changeTheme(theme);
        userCalendar.changeTheme(theme);
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.3300000429153442}D{i:14}D{i:38}D{i:39}D{i:41}
}
##^##*/
