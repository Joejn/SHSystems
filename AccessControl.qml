import QtQuick 2.5
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
import com.SmartHome.AccesControl 1.0

BackgroundPage {
    id: backgroundPage
    width: 1920
    height: 1080

    property int listViewHeaderFontSize: 16
    property int listViewEntrysFontSize: 14

    Rectangle {
        id: rectangle_overlay
        color: "#66000000"
        anchors.fill: parent
        visible: false

        Label {
            id: label_overlay
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

    AccesControl{
        id: accessControl;
    }

    //////////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangle_main
        color: "#00ffffff"
        border.width: 0
        anchors.fill: parent

        Rectangle {
            id: rectangle_listViewHeader
            height: 40
            color: "transparent"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.rightMargin: 40
            anchors.leftMargin: 40

            Row{
                id: rowHeader
                anchors.fill: parent
                Label {
                    id: headerId;
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: listViewHeaderFontSize
                    height: parent.height
                    width: parent.width / 3
                    text: qsTr("ID")
                }

                Label {
                    id: headerName;
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: listViewHeaderFontSize
                    height: parent.height
                    width: parent.width / 3
                    text: qsTr("Name")
                }

                Label {
                    id: headerScanDateTime;
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: listViewHeaderFontSize
                    height: parent.height
                    width: parent.width / 3
                    text: qsTr("Datum und Uhrzeit")
                }
            }
        }

        ListView {
            id: listView
            x: 40
            y: 40
            anchors.left: rectangle_listViewHeader.left
            anchors.right: rectangle_listViewHeader.right
            anchors.top: toolSeparator.bottom
            anchors.bottom: parent.bottom
            anchors.leftMargin: 0
            anchors.topMargin: 16
            anchors.rightMargin: 0
            anchors.bottomMargin: 40
            interactive: true
            clip: true
            model: accessControl.getAccesControlEntrys() // userCalendarBackend.getEntrysForDate(calendar.selectedDate)
            spacing: 10

            /* headerPositioning: listView.OverlayHeader
        header: Rectangle{

            id: headerRectangle
            width: listView.width;
            height: 40
            color: "transparent"

            Row{
                id: rowHeader
                anchors.fill: parent
                Text {
                    id: headerId;
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: listViewHeaderFontSize
                    height: parent.height
                    width: parent.width / 3
                    text: qsTr("ID")
                }

                Text {
                    id: headerName;
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: listViewHeaderFontSize
                    height: parent.height
                    width: parent.width / 3
                    text: qsTr("Name")
                }

                Text {
                    id: headerScanDateTime;
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: listViewHeaderFontSize
                    height: parent.height
                    width: parent.width / 3
                    text: qsTr("Datum und Uhrzeit")
                }
            }

            ToolSeparator {
                id: toolSeparator
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: rowHeader.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.topMargin: 0
                orientation: Qt.Horizontal
            }
        } */

            delegate: Rectangle{
                id: listViewDelegate
                width: listView.width
                height: 40
                color: "transparent"

                property int indexOfThisElement : index

                Column{
                    height: parent.height
                    width: parent.width
                    spacing: 8

                    Rectangle{
                        width: parent.width
                        height: 2
                        color: "transparent"

                        ToolSeparator {
                            id: toolSeparator_listView
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.right: parent.right
                            orientation: Qt.Horizontal
                            anchors.rightMargin: 0
                            anchors.leftMargin: 0
                        }

                        Component.onCompleted: {

                        }
                    }

                    Rectangle{
                        color: "transparent"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        height: 30
                        Row{
                            width: parent.width
                            spacing: 10

                            Label {
                                id: labelId
                                width: parent.width / 3
                                anchors.topMargin: 30
                                font.pointSize: listViewEntrysFontSize
                                wrapMode: "Wrap"
                                text: modelData.id
                            }

                            Label{
                                id: labelName
                                width: parent.width / 3
                                anchors.topMargin: 30
                                font.pointSize: listViewEntrysFontSize
                                wrapMode: "Wrap"
                                text: modelData.name
                            }

                            Label{
                                id: labelScanDateTime
                                width: parent.width / 3
                                anchors.topMargin: 30
                                font.pointSize: listViewEntrysFontSize
                                text: Qt.formatDateTime(modelData.scanDateTime, "dd.MM.yyyy hh:mm")
                            }
                        }
                    }
                }

                /* Component.onCompleted: {
                    if(listView.currentIndex == -1){
                        toolSeparator_listView.visible = false;
                    }
                } */
            }
        }

        ToolSeparator {
            id: toolSeparator
            x: 423
            y: 0
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: rectangle_listViewHeader.bottom
            orientation: Qt.Horizontal
            anchors.topMargin: 16
            anchors.rightMargin: 16
            anchors.leftMargin: 16
        }
    }

    Connections{
        target: accessControl
        onAccesControlEntrysChanged:{
            listView.model = accessControl.getAccesControlEntrys();
        }
    }

    Timer{
        id: timer_reconnect;
        interval: 20000
        running: true
        repeat: true
        onTriggered: accessControl.emitAccesControlEntrysChanged();
    }

    Connections{
        target: accessControl
        onIsConnectedChanged:{
            console.log("onIsConnectedChanged")
            if(isConnected){
                rectangle_main.enabled = true;
                rectangle_overlay.visible = false;
            } else {
                rectangle_main.enabled = false;
                rectangle_overlay.visible = true;

            }
        }

        Component.onCompleted: {
            accessControl.getAccesControlEntrys();
        }
    }

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue;
        }
    }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.33000001311302185}D{i:6}D{i:12}
}
##^##*/
