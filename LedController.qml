import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import com.SmartHome.LedController 1.0

Item {
    id: element
    width: 1920
    height: 1080

    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange

    property color backgroundColor: "#3a3a3a"

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
            backgroundColor = "#3a3a3a"
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue
            backgroundColor = "#ffffff"
        }

        ledController_blink.changeTheme(theme);
        ledController_Monochrome.changeTheme(theme);
        ledController_Pulsating.changeTheme(theme);
        ledController_Rainbow.changeTheme(theme);
        ledController_RunningLight.changeTheme(theme);

    }

    LedController{
        id: ledController
    }

    Rectangle {
        id: rectangle_main
        color: backgroundColor
        anchors.fill: parent

        ToolSeparator {
            id: toolSeparator
            x: 20
            y: 957
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: tabBar_LedController.top
            anchors.bottomMargin: 20
            orientation: Qt.Horizontal
        }

        TabBar{
            id: tabBar_LedController
            x: 160
            y: 990
            height: 50
            anchors.right: parent.right
            anchors.rightMargin: 160
            anchors.left: parent.left
            anchors.leftMargin: 160
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40

            TabButton{
                text: qsTr("Einfarbig")
            }

            TabButton{
                text: qsTr("Blinken")
            }

            TabButton{
                text: qsTr("Regenbogen")
            }

            TabButton{
                text: qsTr("Lauflicht")
            }

            TabButton{
                text: qsTr("Pulsierend")
            }

        }

        StackLayout{
            id: swipeView
            x: 10
            y: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            anchors.leftMargin: 10
            anchors.bottom: toolSeparator.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottomMargin: 8
            currentIndex: tabBar_LedController.currentIndex

            LedController_Monochrome{
                id: ledController_Monochrome
            }

            LedController_blink{
                id: ledController_blink
            }

            LedController_Rainbow{
                id: ledController_Rainbow
            }

            LedController_RunningLight{
                id: ledController_RunningLight
            }

            LedController_Pulsating{
                id: ledController_Pulsating
            }

        }

        Popup{
            id: popupConnection
            anchors.centerIn: parent
            width: 400
            height: 270
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

            Label {
                id: label_Title_popupConnection
                width: parent.width - 10;
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                clip: true
                text: qsTr("Daten konnten nicht gesendet werden")
                anchors.centerIn: parent;
                font.pointSize: 24
                wrapMode: "WordWrap"
            }

            Button {
                id: button_popupConnection
                width: parent.width - 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                text: qsTr("Ok")
                onClicked: {
                    popupConnection.close()
                }
            }
        }

        Connections{
            target: ledController
            onConnectionStateChanged:{
                if(!isConnected){
                    popupConnection.open();
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
