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

    ListView {
        id: listView
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: button.top
        anchors.rightMargin: 0
        anchors.bottomMargin: 40
        interactive: true
        clip: true
        model: accessControl.getAccesControlEntrys() // userCalendarBackend.getEntrysForDate(calendar.selectedDate)
        spacing: 10

        headerPositioning: listView.OverlayHeader
        header: Row{
            id: headerItem
            width: listView.width;
            height: 40

            Text {
                id: headerId;
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: listViewHeaderFontSize
                width: parent.width / 3
                text: qsTr("ID")
            }

            Text {
                id: headerName;
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: listViewHeaderFontSize
                width: parent.width / 3
                text: qsTr("Name")
            }

            Text {
                id: headerScanDateTime;
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: listViewHeaderFontSize
                width: parent.width / 3
                text: qsTr("Datum und Uhrzeit")
            }
        }

        delegate: Row{
            width: parent.width

            spacing: 10

            Label {
                id: labelId
                width: parent.width / 3
                anchors.topMargin: 30
                // color: "white"
                font.pointSize: listViewEntrysFontSize
                wrapMode: "Wrap"
                text: modelData.id
            }

            Label{
                id: labelName
                width: parent.width / 3
                anchors.topMargin: 30
                // color: "white"
                font.pointSize: listViewEntrysFontSize
                wrapMode: "Wrap"
                text: modelData.name
            }

            Label{
                id: labelScanDateTime
                width: parent.width / 3
                anchors.topMargin: 30
                // color: "white"
                font.pointSize: listViewEntrysFontSize
                text: Qt.formatDateTime(modelData.scanDateTime, "hh:mm")
            }

            Component.onCompleted: {
                console.log("listViewModel")
                console.log(labelId.text)
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////////

    /* Timer{
        id: timer_reconnect;
        interval: 20000
        running: false
        repeat: true
        onTriggered: creatListElement();
    }

     Connections{
        target: lightning
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
    } */

    Button {
        id: button
        x: 264
        y: 812
        text: qsTr("Button")
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.rightMargin: 40
        onClicked: {
            listView.model = accessControl.getAccesControlEntrys();
        }
    }

    Rectangle {
        id: rectangle_main
        color: "#00ffffff"
        border.width: 0
        anchors.left: parent.left
        anchors.right: button.left
        anchors.top: parent.top
        anchors.bottom: button.top
        anchors.bottomMargin: 40
        anchors.rightMargin: 40

        Text {
            id: text1
            x: 348
            y: 544
            width: 532
            height: 334
            text: qsTr("Text")
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
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
    D{i:0;formeditorZoom:0.25}
}
##^##*/
