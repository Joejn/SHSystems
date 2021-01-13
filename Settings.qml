import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.12
import com.SmartHome.SettingsBackEnd 1.0
import com.SmartHome.ExportSensorData 1.0
import com.SmartHome.Config 1.0
import QtQuick.Dialogs 1.2

BackgroundPage {
    id: backgroundPage
    height: 900

    SettingsBackEnd{
        id: settingsBackEnd
    }

    ExportSensorData{
        id: exportSensorData
    }

    Config{
        id: config
    }

    Popup{
        id: popup
        anchors.centerIn: parent
        width: parent.width / 8
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        ColumnLayout{
            anchors.fill: parent

            CheckBox{
                id: checkBox_exportCSV
                text: "CSV"
                anchors.top: parent.top
                anchors.topMargin: 0
            }

            CheckBox{
                id: checkBox_exportXML
                text: "XML"
                anchors.top: checkBox_exportCSV.top
                anchors.topMargin: 40
            }

            CheckBox{
                id: checkBox_exportHTML
                text: "HTML"
                anchors.top: checkBox_exportXML.top
                anchors.topMargin: 40
            }

            Button{
                id: button_export_popup
                text: "Exportieren"
                anchors.top: checkBox_exportHTML.top
                anchors.topMargin: 40
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                implicitHeight: parent.height / 5
                implicitWidth: parent.width
                onClicked: {
                    popup.close()
                    exportSensorData.exportData(checkBox_exportCSV.checked, checkBox_exportXML.checked, checkBox_exportHTML.checked)
                    checkBox_exportCSV.checked = false
                    checkBox_exportXML.checked = false
                    checkBox_exportHTML.checked = false
                }
            }
        }

        FileDialog{
            id: fileDialog_exportSensorData
            title: "Wählen Sie einen Ordner"
            folder: shortcuts.documents
            selectFolder: true
            onAccepted: {
                var path = fileDialog_exportSensorData.folder.toString()
                path = path.replace("file:///", "")
                if(Qt.platform.os === "windows"){
                    path = path.split("/").join("\\")
                }
                textField_exportPath.text = path
            }
        }
    }

    ScrollView {
        id: scrollView
        height: 900
        visible: true
        anchors.fill: parent
        anchors.bottomMargin: 0
        clip: true
        contentWidth: parent.width
        contentHeight: 1200
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn



        Label {
            id: label_MqttPort
            x: 20
            y: 734
            text: qsTr("Port")
            anchors.left: parent.left
            anchors.top: label_MqttHostname.bottom
            anchors.topMargin: 30
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Label {
            id: label_MqttHostname
            x: 20
            y: 681
            text: qsTr("Hostname")
            anchors.left: parent.left
            anchors.top: label_Mqtt.bottom
            anchors.topMargin: 40
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Label {
            id: label_Mqtt
            x: 20
            y: 616
            text: qsTr("MQTT Einstellungen")
            anchors.left: parent.left
            anchors.top: toolSeparator1.bottom
            anchors.leftMargin: 20
            anchors.topMargin: 10
            font.pointSize: 16
        }

        ToolSeparator {
            id: toolSeparator1
            x: 10
            y: 593
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: button_databaseApply.bottom
            anchors.rightMargin: 10
            orientation: Qt.Horizontal
            anchors.topMargin: 10
            anchors.leftMargin: 10
        }


        Button {
            id: button_databaseApply
            x: 670
            y: 543
            text: qsTr("Anwenden")
            anchors.right: parent.right
            anchors.top: spinBox_databaseConnectionTimeout.bottom
            anchors.rightMargin: 30
            anchors.topMargin: 20
            onClicked: {
                config.setData("db/hostname", textField_databaseServerName.text, false);
                config.setData("db/name", textField_databaseName.text, false);
                config.setData("db/user", textField_databaseUser.text, false);
                config.setData("db/password", textField_databaseUserPassword.text, true);
                config.setData("db/timeout", spinBox_databaseConnectionTimeout.value.toString(), false);
                label_database_restart.text = "Sie müssen das Programm neu starten damit die Einstellungen übernommen werden"
            }
        }


        Label {
            id: label_databaseUserPassword
            x: 20
            y: 491
            text: qsTr("Passwort")
            anchors.left: parent.left
            anchors.top: label_databaseUser.bottom
            anchors.topMargin: 30
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Label {
            id: label_databaseUser
            x: 20
            y: 438
            text: qsTr("Benutzer")
            anchors.left: parent.left
            anchors.top: label_databaseName.bottom
            anchors.topMargin: 30
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Label {
            id: label_databaseName
            x: 20
            y: 385
            text: qsTr("Datenbank Name")
            anchors.left: parent.left
            anchors.top: label_databaseServerName.bottom
            anchors.topMargin: 30
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Label {
            id: label_databaseServerName
            x: 20
            y: 332
            text: qsTr("Host Name")
            anchors.left: parent.left
            anchors.top: label_Database.bottom
            anchors.topMargin: 40
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        TextField {
            id: textField_databaseServerName
            x: 186
            y: 324
            width: parent.width / 3
            anchors.verticalCenter: label_databaseServerName.verticalCenter
            anchors.left: label_databaseName.right
            anchors.leftMargin: 20
            placeholderText: qsTr("Server Name")
        }


        TextField {
            id: textField_databaseName
            x: 186
            y: 377
            width: parent.width / 3
            anchors.verticalCenter: label_databaseName.verticalCenter
            anchors.left: label_databaseName.right
            anchors.leftMargin: 20
            placeholderText: qsTr("Datenbank")
        }

        TextField {
            id: textField_databaseUser
            x: 186
            y: 430
            width: parent.width / 3
            anchors.verticalCenter: label_databaseUser.verticalCenter
            anchors.left: label_databaseName.right
            anchors.leftMargin: 20
            placeholderText: qsTr("Benutzer")
        }

        TextField {
            id: textField_databaseUserPassword
            x: 186
            y: 483
            width: parent.width / 3
            anchors.verticalCenter: label_databaseUserPassword.verticalCenter
            anchors.left: label_databaseName.right
            anchors.leftMargin: 20
            echoMode: TextInput.Password
            placeholderText: qsTr("Password")
        }

        Label {
            id: label_Database
            x: 20
            y: 267
            text: qsTr("Datenbankeinstellungen")
            anchors.left: parent.left
            anchors.top: toolSeparator.bottom
            anchors.topMargin: 10
            anchors.leftMargin: 20
            font.pointSize: 16
        }

        Label {
            id: label_databaseConnectionTimeout
            x: 24
            y: 640
            text: qsTr("Timeout (ms)")
            anchors.left: parent.left
            anchors.top: label_databaseUserPassword.bottom
            font.pointSize: 14
            anchors.leftMargin: 20
            anchors.topMargin: 30
        }

        SpinBox {
            id: spinBox_databaseConnectionTimeout
            y: 652
            anchors.verticalCenter: label_databaseConnectionTimeout.verticalCenter
            anchors.left: textField_databaseUserPassword.left
            anchors.right: textField_databaseUserPassword.right
            editable: true
            value: 10
            to: 999
            anchors.rightMargin: 0
            anchors.leftMargin: 0
        }

        Button {
            id: button_exportFolder
            y: 213
            text: qsTr("Durchsuchen")
            anchors.verticalCenter: textField_exportPath.verticalCenter
            anchors.left: textField_exportPath.right
            anchors.leftMargin: 10
            onClicked: {
                fileDialog_exportSensorData.visible = true
            }
        }

        TextField {
            id: textField_exportPath
            x: 127
            y: 313
            width: parent.width / 3
            anchors.verticalCenter: label_exportPath.verticalCenter
            anchors.left: label_exportPath.right
            anchors.verticalCenterOffset: 0
            anchors.leftMargin: 20
            placeholderText: qsTr("Pfad")
            onTextChanged: {
                config.setData("general/export_path", text, false)
            }
        }

        ToolSeparator {
            id: toolSeparator
            x: 10
            y: 244
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: button_export.bottom
            anchors.topMargin: 10
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            orientation: Qt.Horizontal
        }

        TextField {
            id: textField_MqttHostname
            y: 673
            width: parent.width / 3
            anchors.verticalCenter: label_MqttHostname.verticalCenter
            anchors.left: label_MqttHostname.right
            anchors.leftMargin: 20
            placeholderText: qsTr("Hostname")
        }

        SpinBox {
            id: spinBox_MqttPort
            y: 726
            anchors.verticalCenter: label_MqttPort.verticalCenter
            anchors.left: label_MqttHostname.right
            anchors.leftMargin: 20
            to: 65535
            anchors.verticalCenterOffset: 0
            editable: true
        }

        Button {
            id: button_export
            x: 574
            text: qsTr("Exportieren")
            anchors.right: parent.right
            anchors.top: textField_exportPath.bottom
            anchors.rightMargin: 30
            anchors.topMargin: 20
            onClicked: popup.open()
        }

        Label {
            id: label_darkMode
            text: qsTr("Dark Mode")
            anchors.left: parent.left
            anchors.top: label_general.bottom
            Layout.preferredHeight: 40
            Layout.preferredWidth: 116
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 40
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Switch {
            id: element_darkMode
            y: 68
            anchors.verticalCenter: label_darkMode.verticalCenter
            anchors.left: label_darkMode.right
            anchors.leftMargin: 20
            checked: getPosition();
            onCheckedChanged: {
                config.setData("general/dark_mode", position, false);
                window.changeTheme(getTheme());
            }
        }

        Label {
            id: label_exportData
            width: 277
            height: 40
            text: qsTr("Sensor Daten Exportieren")
            anchors.left: parent.left
            anchors.top: toolSeparator2.bottom
            font.pointSize: 17
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 10
            anchors.leftMargin: 20
            Layout.preferredHeight: 40
            Layout.preferredWidth: 116
        }

        Button {
            id: button_MqttApply
            x: 516
            text: "Anwenden"
            anchors.right: parent.right
            anchors.top: textField_MqttPassword.bottom
            anchors.topMargin: 20
            anchors.rightMargin: 30
            onClicked: {
                config.setData("mqtt/hostname", textField_MqttHostname.text, false);
                config.setData("mqtt/port", spinBox_MqttPort.value, false);
                config.setData("mqtt/username", textField_MqttUsername.text, false);
                config.setData("mqtt/password", textField_MqttPassword.text, true);
                label_mqtt_restart.text = "Sie müssen das Programm neu starten damit die Einstellungen übernommen werden"
            }
        }

        ToolSeparator {
            id: toolSeparator2
            x: 9
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: element_darkMode.bottom
            anchors.topMargin: 10
            orientation: Qt.Horizontal
            anchors.leftMargin: 10
            anchors.rightMargin: 10
        }

        Label {
            id: label_exportPath
            text: qsTr("Export Ordner")
            anchors.left: parent.left
            anchors.top: label_exportData.bottom
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.topMargin: 40
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Label {
            id: label_general
            text: qsTr("Allgemein")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.leftMargin: 20
            font.pointSize: 16
        }

        Label {
            id: label_database_restart
            y: 334
            anchors.verticalCenter: button_databaseApply.verticalCenter
            anchors.left: parent.left
            anchors.right: button_databaseApply.left
            clip: true
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            font.pointSize: 14
        }

        Label {
            id: label_mqtt_restart
            y: 334
            anchors.verticalCenter: button_MqttApply.verticalCenter
            anchors.left: parent.left
            anchors.right: button_MqttApply.left
            clip: true
            font.pointSize: 14
            anchors.leftMargin: 20
            anchors.rightMargin: 20
        }

        Label {
            id: label_MqttUsername
            x: 10
            y: 928
            text: qsTr("Benutzer")
            anchors.left: parent.left
            anchors.top: label_MqttPort.bottom
            anchors.topMargin: 30
            font.pointSize: 14
            anchors.leftMargin: 20
        }

        Label {
            id: label_MqttPassword
            x: 23
            y: 957
            text: qsTr("Passwort")
            anchors.left: parent.left
            anchors.top: label_MqttUsername.bottom
            anchors.topMargin: 30
            font.pointSize: 14
            anchors.leftMargin: 20
        }

        TextField {
            id: textField_MqttUsername
            y: 673
            width: parent.width / 3
            anchors.verticalCenter: label_MqttUsername.verticalCenter
            anchors.left: label_MqttHostname.right
            placeholderText: qsTr("Benutzer")
            anchors.leftMargin: 20
        }

        TextField {
            id: textField_MqttPassword
            y: 673
            width: parent.width / 3
            anchors.verticalCenter: label_MqttPassword.verticalCenter
            anchors.left: label_MqttHostname.right
            echoMode: TextInput.Password
            placeholderText: qsTr("Passwort")
            anchors.leftMargin: 20
        }

        Label {
            id: label_export_connection
            y: 334
            anchors.verticalCenter: button_export.verticalCenter
            anchors.left: parent.left
            anchors.right: button_export.left
            anchors.rightMargin: 20
            font.pointSize: 14
            clip: true
            anchors.leftMargin: 20
        }

        Component.onCompleted: {
            textField_databaseServerName.text = config.getData("db/hostname", false)
            textField_databaseName.text = config.getData("db/name", false)
            textField_databaseUser.text = config.getData("db/user", false)
            textField_databaseUserPassword.text = config.getData("db/password", true)
            textField_MqttHostname.text = config.getData("mqtt/hostname", false)
            spinBox_MqttPort.value = config.getData("mqtt/port", false)
            textField_exportPath.text = config.getData("general/export_path", false)
            textField_MqttUsername.text =  config.getData("mqtt/username", false)
            textField_MqttPassword.text =  config.getData("mqtt/password", true)
        }
    }

    Connections{
        target: exportSensorData
        onIsConnectedChanged:{
            if(isConnected){
                label_export_connection.text = "";
            } else {
                label_export_connection.text = "Es konnten keine Daten abgefragt werden.";
            }
        }
    }

    function getPosition(){
        var theme = config.getData("general/dark_mode", false);
        var position;
        if(theme === "1"){
            position = 1;
        } else {
            position = 0;
        }

        return position;
    }

    function getTheme(){
        var theme = config.getData("general/dark_mode", false);
        var themeFunction;
        if(theme === "1"){
            themeFunction = "Dark";
        } else {
            themeFunction = "Light";
        }

        return themeFunction;
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

}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
