import QtQuick 2.0
import QtQuick.Controls 2.12
import QtCharts 2.14
import com.SmartHome.SensorDrawChartBackend 1.0
import QtQml 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Dialogs 1.2
// import com.SmartHome.AddSensor 1.0

BackgroundPage {
    id: backgroundPage

    property string textColor: "white"
    property string listViewHighlightColor: "#FF5722"

    ChartView{
        id: chart
        height: parent.height/2
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        animationOptions: ChartView.SeriesAnimations
        legend.visible: false
        antialiasing: true
        backgroundColor: "transparent"

        theme: ChartView.ChartThemeDark

        SensorDrawChartBackend{
            id: backendChart
        }

        LineSeries{
            axisX: axisX
            axisY: axisY
            id: lineSeriesSensor
        }

        DateTimeAxis{
            id: axisX
            min: new Date().setHours(Date.getHours - 48)
            max: new Date().setHours(Date.getHours - 24)
            tickCount: 6
        }

        ValueAxis{
            id: axisY
            min: 0
            max: 40
            tickCount: backendChart.tickCountAxisY()
        }

        Label {
            id: label_dbConnection
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 16
        }
    }

    ListView{
        id: listView_sensors
        anchors.top: toolSeparator1.bottom
        anchors.topMargin: 0
        anchors.bottom: toolSeparator3.top
        spacing: 8
        clip: true
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: parent.width / 2
        model: listModel
        delegate: Rectangle{
            width: listView_sensors.width
            height: listView_sensors.height /5
            color: listView_sensors.currentIndex === index ? listViewHighlightColor : "transparent"

            Row {
                anchors.fill: parent

                Text {
                    text: sensor
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    verticalAlignment: Text.AlignVCenter
                    color: textColor
                    height: parent.height
                    width: parent.width / 2
                    font.pointSize: 16
                    minimumPointSize: 4
                    fontSizeMode: Text.Fit
                }

                Button {
                    text: "auswälen"
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    height: parent.height
                    onClicked: {
                        setCurrentSensor(tableName)
                        listView_sensors.currentIndex = index;
                    }
                }
            }
        }
    }

    Timer {
            interval: 200000; running: true; repeat: true
            onTriggered: {
                backendChart.setSensorTables();
                creatListElement();

                backendChart.set_sensorValues()
                axisY.tickCount = backendChart.tickCountAxisY()

                axisX.min = backendChart.get_X_min();
                axisX.max = backendChart.get_X_max();

                axisY.min = backendChart.get_Y_min();
                axisY.max = backendChart.get_Y_max();

                appendLineSeriesSensorValue();
            }
        }

    ListModel{
        id: listModel

        Component.onCompleted: {
            creatListElement()
        }
    }

    ToolSeparator {
        id: toolSeparator1
        x: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: chart.bottom
        anchors.topMargin: 0
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        orientation: Qt.Horizontal
    }

    function creatListElement(){
        backendChart.setSensorTables()
        var tableName = backendChart.sensorTabeles
        listModel.clear();
        var isFirst = true
        for(var i = 0; tableName.length > i; ++i){
            var sensorName = tableName[i]
            var sensor = sensorName.split('_')

            if(sensor[1] === "temperature"){
                sensorName = "Temperatursensor "
            } else {
                sensorName = "Luftfeuchtigkeitssensor "
            }

            sensorName += sensor[2]

            listModel.append({"sensor": sensorName, "tableName": tableName[i]})

            if(isFirst){
                setCurrentSensor(tableName[0])
                listView_sensors.currentIndex = 0;
            }
        }
    }

    function setCurrentSensor(tableName){
        backendChart.setTable(tableName)
        backendChart.set_sensorValues()
        axisY.tickCount = backendChart.tickCountAxisY()

        axisX.min = backendChart.get_X_min();
        axisX.max = backendChart.get_X_max();

        axisY.min = backendChart.get_Y_min();
        axisY.max = backendChart.get_Y_max();

        appendLineSeriesSensorValue();
    }

    function appendLineSeriesSensorValue(){
        var valX = backendChart.get_X_Axie()
        var valY = backendChart.get_Y_Axie()

        lineSeriesSensor.clear();

        for(var i = 0; i < valX.length; ++i){
            lineSeriesSensor.append(valX[i], valY[i]);
        }
    }

    Row {
        id: row
        y: 0
        height: 46
        anchors.left: parent.left
        anchors.right: toolSeparator2.left
        anchors.bottom: parent.bottom
        layoutDirection: Qt.LeftToRight
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        Label {
            id: label
            text: qsTr("Sensor Hinzufügen")
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 16
            minimumPointSize: 4
            fontSizeMode: Text.Fit
            width: parent.width / 2
        }

        Button {
            id: button_addSensor
            text: qsTr("+")
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0
            onClicked: {
                popup.open()
            }
        }

    }

    ToolSeparator {
        id: toolSeparator3
        y: 529
        anchors.left: parent.left
        anchors.right: toolSeparator2.left
        anchors.bottom: row.top
        anchors.bottomMargin: 0
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        orientation: Qt.Horizontal
    }

    Popup{
        id: popup
        anchors.centerIn: parent
        width: 400
        height: 480
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onClosed: {
            text_addSensor.text = "";
        }

        Label {
            id: label_Title
            text: qsTr("Sensor Hinzufügen")
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
            id: toolSeparator
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: label_Title.bottom
            anchors.topMargin: 8
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            orientation: Qt.Horizontal
        }

        Label {
            id: label_Name
            text: qsTr("Name")
            anchors.left: parent.left
            anchors.top: toolSeparator.bottom
            anchors.topMargin: 20
            anchors.leftMargin: 40
            width: parent.width / 4
            font.pointSize: 16
        }

        Label {
            id: label_Type
            text: qsTr("Typ")
            anchors.left: parent.left
            anchors.top: label_Name.bottom
            anchors.topMargin: 40
            anchors.leftMargin: 40
            width: parent.width / 4
            font.pointSize: 16
        }

        Label {
            id: label_Pin
            text: qsTr("Pin")
            anchors.left: parent.left
            anchors.top: label_Type.bottom
            anchors.topMargin: 40
            anchors.leftMargin: 40
            width: parent.width / 4
            font.pointSize: 16
        }

        Text {
            id: text_addSensor
            text: qsTr("")
            anchors.left: parent.left
            anchors.top: label_Pin.bottom
            anchors.topMargin: 40
            anchors.leftMargin: 40
            color: "red"
            width: parent.width / 4
            font.pointSize: 16
        }

        TextField {
            id: textField_Name
            anchors.verticalCenter: label_Name.verticalCenter
            anchors.left: label_Name.right
            anchors.leftMargin: 40
            width: parent.width / 2
            placeholderText: qsTr("Text Field")
        }

        ComboBox {
            id: comboBox_Type
            anchors.verticalCenter: label_Type.verticalCenter
            anchors.left: label_Name.right
            anchors.leftMargin: 40
            width: parent.width / 2
            textRole: "text"
            valueRole: "value"
            model: [
                { value: "temperature", text: qsTr("Temperatursensor") },
                { value: "humidity", text: qsTr("Luftfeuchtigkeitssensor") }

            ]
        }

        SpinBox {
            id: spinBox_Pin
            anchors.verticalCenter: label_Pin.verticalCenter
            anchors.left: label_Name.right
            anchors.leftMargin: 40
            width: parent.width / 2
            from: 20
            to: 30
        }

        Button {
            id: button_addButton
            anchors.top: text_addSensor.bottom
            anchors.topMargin: 40
            anchors.left: label_Name.right
            anchors.leftMargin: 40
            width: parent.width / 2
            text: qsTr("Hinzufügen")
            onClicked: {
                if(textField_Name.text === ""){
                    text_addSensor.text = "Bitte füllen Sie die Felder aus";
                    return
                } else {
                    text_addSensor.text = "";
                }

                popup.close()
                if(backendChart.addSensor(textField_Name.text, comboBox_Type.currentValue, spinBox_Pin.value)){
                    backendChart.publishDataAddSensor(textField_Name.text, comboBox_Type.currentValue, spinBox_Pin.value)
                    creatListElement()
                } else {
                    popupConnection.open()
                }
            }
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
            text: qsTr("Sensor konnte nicht hizugefügt werden")
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

    ToolSeparator {
        id: toolSeparator2
        anchors.left: listView_sensors.right
        anchors.top: chart.bottom
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
    }

    Connections{
        target: backendChart
        onIsConnectedChanged:{
            if(isConnected){
                label_dbConnection.text = "";
            } else {
                label_dbConnection.text = "Es konnten keine Daten abgefragt werden.";
            }
        }
    }

    function addSensor(){
        backendChart.addSensor(textField_Name.text, comboBox_Type.currentValue, spinBox_Pin.value)
    }

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
            textColor = "white";
            listViewHighlightColor = "#FF5722";
            chart.theme = ChartView.ChartThemeDark;
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue;
            textColor = "black";
            listViewHighlightColor = "#03A9F4";
            chart.theme = ChartView.ChartThemeLight;
        }
        chart.backgroundColor = "transparent";
    }
}


