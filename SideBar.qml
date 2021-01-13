import QtQuick 2.0
import QtQuick.Controls 2.12
import com.SmartHome.SideBarBackend 1.0

Rectangle{
    id: rectangle
    width: 300
    height: 800
    color: "#000000"

    SideBarBackend{
        id: sideBarBackend
    }

    Image {
        id: image
        height: 137
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Icons/SideBar/SHS_Logo.png"
    }

    Label {
        id: label_currentTime
        y: 492
        height: 160
        color: "#ffffff"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: sideBar.getCurrentDateTime()
        font.pointSize: 32
    }

    Timer{
        id: timer
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: label_currentTime.text = sideBarBackend.getCurrentDateTime();
    }
}
