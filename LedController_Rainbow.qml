import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Item {
    id: element1
    width: 1920
    height: 1080

    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue
        }
    }

    Button {
        id: button
        x: 483
        y: 411
        text: qsTr("Anwenden")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 40
        onClicked: {
            var data = "c;" + 'n' + ";" + '0' + ";" + '0' + ";" + '0' + ";";
            ledController.publishData("ledController/command", data);
        }
    }

    Label {
        id: label
        x: 772
        y: 608
        text: qsTr("Regenbogen")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rotation: 305
        font.pointSize: 80
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.25}
}
##^##*/
