import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Item {
    id: element
    width: 1920
    height: 1080
    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange

    property int colorR: 0
    property int colorG: 0
    property int colorB: 0

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue
        }
    }

    Rectangle {
        id: rectangle_PreviewColor
        x: 1494
        width: parent.width / 3
        color: Qt.rgba(colorR / 255, colorG / 255, colorB / 255, 1)
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: button_execute.top
        anchors.topMargin: 80
        anchors.bottomMargin: 80
        anchors.rightMargin: 80
    }

    Rectangle {
        id: rectangle
        color: "#00ffffff"
        anchors.left: parent.left
        anchors.right: rectangle_PreviewColor.left
        anchors.top: parent.top
        anchors.bottom: button_execute.top
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 80

        SpinBox {
            id: spinBox_ColorB
            x: 1350
            y: -198
            anchors.verticalCenter: slider_ColorB.verticalCenter
            editable: true
            to: 255
            anchors.rightMargin: 40
            anchors.right: parent.right
            value: colorB
            onValueChanged: {
                colorB = value
            }
        }

        SpinBox {
            id: spinBox_ColorG
            x: 1350
            y: -310
            anchors.verticalCenter: slider_ColorG.verticalCenter
            editable: true
            to: 255
            anchors.rightMargin: 40
            anchors.right: parent.right
            value: colorG
            onValueChanged: {
                colorG = value
            }
        }

        SpinBox {
            id: spinBox_ColorR
            x: 1350
            y: -422
            anchors.verticalCenter: slider_ColorR.verticalCenter
            editable: true
            to: 255
            anchors.right: parent.right
            anchors.rightMargin: 40
            value: colorR
            onValueChanged: {
                colorR = value
            }
        }

        Label {
            id: label_ColorB
            y: -248
            width: 36
            height: 52
            text: qsTr("B")
            anchors.left: slider_ColorB.left
            anchors.bottom: slider_ColorB.top
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            font.pointSize: 32
        }

        Label {
            id: label_ColorG
            y: -360
            width: 36
            height: 52
            text: qsTr("G")
            anchors.left: slider_ColorR.left
            anchors.bottom: slider_ColorG.top
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            font.pointSize: 32
        }

        Label {
            id: label_ColorR
            y: -474
            width: 36
            height: 52
            text: qsTr("R")
            anchors.left: slider_ColorR.left
            anchors.bottom: slider_ColorR.top
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            font.pointSize: 32
        }

        Slider {
            id: slider_ColorB
            x: -350
            y: -214
            height: 72
            anchors.top: slider_ColorG.bottom
            anchors.topMargin: 40
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 40
            to: 255
            anchors.right: spinBox_ColorB.left
            stepSize: 1
            value: colorB
            onValueChanged: {
                colorB = value
            }
        }

        Slider {
            id: slider_ColorG
            x: -344
            y: -326
            height: 72
            anchors.top: slider_ColorR.bottom
            anchors.topMargin: 40
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 46
            to: 255
            anchors.right: spinBox_ColorG.left
            stepSize: 1
            value: colorG
            onValueChanged: {
                colorG = value
            }
        }

        Slider {
            id: slider_ColorR
            x: -350
            y: -438
            height: 72
            anchors.top: parent.top
            anchors.topMargin: 110
            stepSize: 1
            to: 255
            anchors.right: spinBox_ColorR.left
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 40
            value: colorR
            onValueChanged: {
                colorR = value
            }

        }
    }

    Button {
        id: button_execute
        x: 1366
        y: 1018
        text: qsTr("Anwenden")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 100
        onClicked: {
            var data = "p;" + spinBox_Intervall.value + ";" + colorR + ";" + colorG + ";" + colorB + ";";
            ledController.publishData("ledController/command", data);
        }
    }

    Label {
        id: label_Intervall
        x: 1072
        y: 994
        text: qsTr("Intervalldauer")
        anchors.bottom: spinBox_Intervall.verticalCenter
        anchors.bottomMargin: -26
        anchors.right: spinBox_Intervall.left
        anchors.rightMargin: 20
        font.pointSize: 32
    }

    SpinBox {
        id: spinBox_Intervall
        x: 1552
        y: 1000
        from: 1
        to: 10
        anchors.bottom: button_execute.verticalCenter
        anchors.bottomMargin: -20
        anchors.right: button_execute.left
        anchors.rightMargin: 40
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
