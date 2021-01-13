import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
import com.SmartHome.Lighting 1.0

BackgroundPage {
    id: backgroundPage
    width: 1920
    height: 1080

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

    Lighting{
        id: lightning;
    }

    property string imageColor: "#ffffff"

    ListModel{
        id: listModel

        Component.onCompleted: {
            creatListElement()
        }
    }

    //////////////////////////////////////////////////////////////////////////////////

    Popup{
        id: popup
        anchors.centerIn: parent
        width: 600
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        Label {
            id: label_Title
            text: qsTr("Beleuchtung Hinzufügen")
            anchors.left: parent.left
            anchors.right: textField_Name.right
            anchors.top: parent.top
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 0
            anchors.leftMargin: 40
            anchors.topMargin: 20
            font.pointSize: 24
        }

        ToolSeparator {
            id: toolSeparatorPopup
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: label_Title.bottom
            anchors.topMargin: 8
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            orientation: Qt.Horizontal
        }

        Label {
            id: label_description
            text: qsTr("Name")
            anchors.left: parent.left
            anchors.top: toolSeparatorPopup.bottom
            anchors.topMargin: 20
            anchors.leftMargin: 40
            width: parent.width / 4
            font.pointSize: 16
        }

        Label {
            id: label_topic
            text: qsTr("Topic")
            anchors.left: parent.left
            anchors.top: label_description.bottom
            anchors.topMargin: 20
            anchors.leftMargin: 40
            width: parent.width / 4
            font.pointSize: 16
        }

        TextField {
            id: textField_description
            anchors.verticalCenter: label_description.verticalCenter
            anchors.left: label_description.right
            anchors.leftMargin: 40
            width: parent.width / 2
            placeholderText: qsTr("Name")
        }

        TextField {
            id: textField_topic
            anchors.verticalCenter: label_topic.verticalCenter
            anchors.left: label_topic.right
            anchors.leftMargin: 40
            width: parent.width / 2
            placeholderText: qsTr("Topic")
        }

        Button {
            id: button_addButton
            anchors.top: label_topic.bottom
            anchors.topMargin: 40
            anchors.left: label_topic.right
            anchors.leftMargin: 40
            width: parent.width / 2
            text: qsTr("Hinzufügen")
            onClicked: {
                if(textField_description.text !== "" && textField_topic.text !== ""){
                    lightning.addLighting(textField_description.text, textField_topic.text)
                    listModel.append({"lightningName": textField_description.text, "lightningValue": 0, "topic": textField_topic.text})
                    popup.close()
                }
            }
        }
    }

    Timer{
        id: timer_reconnect;
        interval: 20000
        running: false
        repeat: true
        onTriggered: creatListElement();
    }

    Connections{
        target: lightning
        onLastStatusChanged:{
            setSliderValues();
        }
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
    }

    Rectangle {
        id: rectangle_main
        color: "#00ffffff"
        anchors.fill: parent

        ToolSeparator {
            id: toolSeparator1
            x: 226
            y: 676
            anchors.left: parent.left
            anchors.right: toolSeparator.left
            anchors.bottom: row.top
            anchors.bottomMargin: 10
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            orientation: Qt.Horizontal
        }

        Row {
            id: row
            x: 226
            y: 699
            height: parent.height / 16
            anchors.left: parent.left
            anchors.right: toolSeparator.left
            anchors.bottom: parent.bottom
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            layoutDirection: Qt.LeftToRight

            Label {
                id: label
                text: qsTr("Beleuchtung Hinzufügen")
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
                minimumPointSize: 4
                fontSizeMode: Text.Fit
                width: parent.width / 2
            }

            Button {
                id: button_addLightning
                text: qsTr("+")
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 0
                onClicked: {
                    popup.open()
                }
            }

        }

        Rectangle {
            id: rectangle_Lightbulb
            x: 1296
            y: -224
            color: "#00ffffff"
            border.color: "#00000000"
            anchors.left: toolSeparator1.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 80
            anchors.bottomMargin: 80
            anchors.topMargin: 80
            anchors.rightMargin: 80

            Image {
                id: image_Lightbulb
                anchors.fill: parent
                source: "qrc:/Icons/Lightning/Lightbulb.svg"
                sourceSize.width: 2048
                sourceSize.height: 2048
                fillMode: Image.PreserveAspectFit
            }

            ColorOverlay {
                anchors.fill: image_Lightbulb
                source: image_Lightbulb
                color: imageColor
            }
        }

        ToolSeparator {
            id: toolSeparator
            x: 1226
            y: -294
            anchors.left: listViewLightning.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.topMargin: 10
            anchors.bottomMargin: 10
        }

        ListView {
            id: listViewLightning
            width: parent.width / 2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: toolSeparator1.top
            anchors.leftMargin: 40
            anchors.bottomMargin: 10
            anchors.topMargin: 40
            clip: true
            spacing: 8
            property int delegateId: 0
            x: 256
            y: -264
            model: listModel
            delegate: Rectangle {
                width: listViewLightning.width
                height: listViewLightning.height /16
                color: "transparent"

                Row{
                    anchors.fill: parent

                    Label {
                        text: lightningName
                        width: parent.width / 2
                        height: parent.height
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 14
                    }

                    Slider {
                        from: 0;
                        to: 255;
                        stepSize: 1
                        value: lightningValue
                        width: parent.width / 2
                        height: parent.height
                        onPressedChanged: {
                            sendData(topic, value);
                        }
                    }
                }
            }
        }




    }

    function setSliderValues(){
        var topics = lightning.getTopicList()
        var brightness = lightning.getBrightness()
        for(var i = 0; i < listModel.count; i++){
            for(var j = 0; j < topics.length; j++){
                if(listModel.get(i).topic == topics[j]){
                    listModel.get(i).lightningValue = brightness[j];
                }
            }
        }
    }

    function creatListElement(){
        lightning.setDbData("SELECT * FROM lightning_info", "0;1");
        var lightningNames = lightning.getDbData(0);
        var topics = lightning.getDbData(1);
        listModel.clear();
        for(var i = 0; lightningNames.length > i; ++i){
            listModel.append({"lightningName": lightningNames[i], "lightningValue": 0, "topic": topics[i]})
        }
    }

    function sendData(topic, brightness){
        lightning.publishData(topic, brightness)
    }

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
            imageColor = "#ffffff";
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue;
            imageColor = "#000000";
        }
    }

}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.25}D{i:16}
}
##^##*/
