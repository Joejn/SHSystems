import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12
import com.SmartHome.UserCalendar 1.0

Item {
    id: element

    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange

    property color sameMonthDateTextColor: "white"
    property color selectedDateColor: "#FF5722"
    property color selectedDateTextColor: "white"
    property color differentMonthDateTextColor: "#696969"
    property color invalidDateColor: "#dddddd"
    property color notSelectedTextColor: "white"
    property color notSelectedColor: "#3a3a3a"
    property color normalTextColor: "black";
    property color backgroundColor: "#3a3a3a"

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;

            sameMonthDateTextColor = "white"
            selectedDateColor = "#FF5722"
            selectedDateTextColor = "white"
            invalidDateColor = "#dddddd"
            notSelectedTextColor = "white"
            notSelectedColor = "#3a3a3a"
            normalTextColor = "white"
            backgroundColor = "#3a3a3a"
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue

            sameMonthDateTextColor = "black"
            selectedDateColor = "#2196F3"
            selectedDateTextColor = "white"
            invalidDateColor = "#3a3a3a"
            notSelectedTextColor = "black"
            notSelectedColor = "#dddddd"
            normalTextColor = "black"
            backgroundColor = "#ffffff"
        }

        userCalendarAddEntrys.changeTheme(theme)
    }

    UserCalendarBackend{
        id: userCalendarBackend
    }

    SystemPalette{
        id: systemPalette
    }

    Rectangle {
        id: rectangle_overlay
        color: "#66000000"
        anchors.fill: parent
        z: 1
        visible: false

        Label {
            id: label_overlay
            visible: true
            color: "#ffffff"
            text: qsTr("Verbindung nicht möglich")
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            styleColor: "#f3f2f2"
            font.pointSize: 36
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        id: rectangle_main
        visible: true
        color: backgroundColor
        anchors.fill: parent

        Rectangle {
            id: rectangle
            x: 240
            y: 20
            color: "#00ffffff"
            border.color: "#00000000"
            anchors.left: parent.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 20
            anchors.bottomMargin: 80
            anchors.rightMargin: 20
            anchors.leftMargin: -400

            Rectangle{
                id: listViewHeader
                x: 238
                y: 0
                height: 80
                anchors.rightMargin: 10
                color: "transparent"
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 40

                Label{
                    id: labelDate
                    color: normalTextColor
                    font.pointSize: 32
                    text: calendar.selectedDate.toLocaleString(calendar.locale, "dddd\ndd.MM.yyyy\n")
                    anchors.fill: parent
                    anchors.bottomMargin: 0
                    onTextChanged: {
                        userCalendarBackend.setCurrentDate();
                    }
                }
            }

            StackLayout{
                id: swipeViewEntrys
                x: 238
                y: 140
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top: listViewHeader.bottom
                anchors.leftMargin: 10
                anchors.bottomMargin: 10
                anchors.topMargin: 38
                currentIndex: entryTabBar.currentIndex

                ListView {
                    id: listView
                    interactive: true
                    clip: true
                     // model: userCalendarBackend.getEntrysForDate(calendar.selectedDate)
                    spacing: 10

                    delegate: Column{
                        width: parent.width

                        spacing: 10

                        Label {
                            id: labelTitle
                            width: parent.width
                            anchors.topMargin: 30
                            color: normalTextColor
                            font.pointSize: 16
                            wrapMode: "Wrap"
                            text: modelData.title
                        }

                        Label{
                            id: labelContent
                            width: parent.width
                            anchors.topMargin: 30
                            color: normalTextColor
                            font.pointSize: 16
                            wrapMode: "Wrap"
                            text: modelData.content
                        }

                        Label{
                            id: labelTimeFrom
                            width: parent.width
                            anchors.topMargin: 30
                            color: normalTextColor
                            font.pointSize: 16
                            text: "Von: " + Qt.formatDateTime(modelData.entryTimeFrom, "hh:mm")
                        }

                        Label{
                            id: labelTimeTo
                            width: parent.width
                            anchors.topMargin: 30
                            color: normalTextColor
                            font.pointSize: 16
                            text: "Bis: " + Qt.formatDateTime(modelData.entryTimeTo, "hh:mm")
                        }

                        ToolSeparator{
                            width: parent.width
                            antialiasing: false
                            smooth: true
                            layer.wrapMode: ShaderEffectSource.ClampToEdge
                            layer.smooth: false
                            enabled: true
                            orientation: Qt.Horizontal
                        }
                    }
                }

                UserCalendarAddEntrys{

                }


            }


        }

        TabBar{
            id: entryTabBar
            x: 250
            y: 410
            anchors.top: rectangle.bottom
            anchors.topMargin: 10
            anchors.left: calendar.right
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 30

            TabButton{
                width: listView.width / 2
                text: qsTr("Meine Termine")
            }
            TabButton{
                width: listView.width / 2
                text: qsTr("Termin erstellen")
            }
        }

        ToolSeparator{
            x: 223
            y: 60
            anchors.bottomMargin: 10
            antialiasing: false
            smooth: true
            layer.wrapMode: ShaderEffectSource.ClampToEdge
            layer.smooth: false
            rightPadding: 3
            leftPadding: 3
            bottomPadding: 0
            topPadding: 0
            wheelEnabled: false
            orientation: Qt.Vertical
            enabled: true
            anchors.rightMargin: 10
            anchors.right: rectangle.left
            anchors.bottom: parent.bottom
            anchors.topMargin: 60
            anchors.top: parent.top

        }

        Calendar{
            id: calendar
            x: 30
            y: 30
            anchors.right: rectangle.left
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.top: parent.top
            antialiasing: true
            smooth: true
            clip: false
            activeFocusOnTab: false
            frameVisible: false
            navigationBarVisible: true
            weekNumbersVisible: true

            anchors.leftMargin: 30
            anchors.bottomMargin: 30
            anchors.topMargin: 30

            style: CalendarStyle{

                gridVisible: false

                background: Item{
                    anchors.fill: parent
                    Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }
                }

                dayDelegate: Item{

                    Rectangle{
                        anchors.fill: parent
                        border.color: "transparent"
                        color: styleData.selected ? selectedDateColor : "transparent"
                    }

                    Label{
                        id: dayDekegateText
                        text: styleData.date.getDate()
                        font.pointSize: 14
                        anchors.centerIn: parent
                        color: {
                            var color = invalidDateColor;
                            if(styleData.valid){
                                color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                if(styleData.selected){
                                    color: selectedDateTextColor;
                                } else{
                                    color: color;
                                }
                            }
                        }
                    }

                }

                weekNumberDelegate: Item{
                    width: 80;

                    Rectangle{
                        anchors.fill: parent
                        border.color: "transparent"
                        color: "transparent"
                    }

                    Label{
                        text: styleData.weekNumber
                        color: normalTextColor
                        anchors.centerIn: parent
                        font.pointSize: 14
                    }
                }

                dayOfWeekDelegate: Item {
                    height: 80;

                    Rectangle{
                        anchors.fill: parent
                        border.color: "transparent"
                        color: "transparent"
                    }

                    Label{
                        text: getDayName(styleData.dayOfWeek)
                        color: normalTextColor
                        anchors.centerIn: parent
                        font.pointSize: 16
                        font.bold: true
                    }

                    function getDayName(day){
                        switch (day){
                        case 0: return "Sonntag";
                        case 1: return "Montag";
                        case 2: return "Dienstag";
                        case 3: return "Mittwoch";
                        case 4: return "Donnerstag";
                        case 5: return "Freitag";
                        case 6: return "Samstag";
                        }
                    }
                }

                navigationBar: Item {
                    height: titleLabel.height + 8
                    Rectangle{
                        anchors.fill: parent
                        color: "transparent"
                    }

                    Label{
                        id: titleLabel
                        anchors.centerIn: parent
                        text: styleData.title
                        color: normalTextColor
                        font.pointSize: 32
                    }
                }

            }

        }

        Component.onCompleted: {
            userCalendarBackend.setCurrentDate();
        }

        Timer{
            id: timer_reconnect;
            interval: 20000
            running: false
            repeat: true
            onTriggered: userCalendarBackend.setCurrentDate();
        }

        Connections{
            target: userCalendarBackend
            onCurrentDateChanged:{
                listView.model = userCalendarBackend.getEntrysForDate(calendar.selectedDate)
            }
        }

        Connections{
            target: userCalendarBackend
            onIsConnectedChanged:{
                if(isConnected){
                    rectangle_main.enabled = true;
                    rectangle_overlay.visible = false;
                    timer_reconnect.running = false;
                } else {
                    rectangle_main.enabled = false;
                    rectangle_overlay.visible = true;
                    timer_reconnect.running = true;

                }
            }
        }

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
