import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import com.SmartHome.UserCalendar 1.0
import QtQuick.Window 2.2

Item {
    width: 1080 /2
    height: 1920 / 2

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue
        }
    }

    UserCalendarBackend{
        id: userCalendarBackendAddEntrys
    }

    Rectangle {
        id: rectangle
        color: "transparent"
        anchors.fill: parent

        Label {
            id: label_Title
            height: 30
            text: qsTr("Title")
            font.pointSize: 16
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        Label {
            id: label_Anmerkung
            height: 30
            text: qsTr("Anmerkung")
            font.pointSize: 16
            anchors.top: textField_Title.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
        }

        /* Label {
            id: label_Von
            height: 30
            text: qsTr("Von")
            font.pointSize: 16
            anchors.top: textField_Anmerkung.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
        }*/


        TextField {
            id: textField_Title
            x: 20
            y: 146
            anchors.top: label_Title.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            placeholderText: qsTr("Title")
            wrapMode: TextEdit.Wrap
            maximumLength: 50
        }

        /* Label {
            id: label_Bis
            height: 30
            text: qsTr("Bis")
            font.pointSize: 16
            anchors.top: rowLayoutFrom.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
        } */

        TextField {
            id: textField_Anmerkung
            anchors.top: label_Anmerkung.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            placeholderText: qsTr("Anmerkung")
            wrapMode: TextEdit.WrapAnywhere
            maximumLength: 255
        }

        //////////////// Quelle: https://bit.ly/3eA48SI ////////////////

        /*RowLayout{
            id: rowLayoutFrom
            spacing: 0
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: label_Von.bottom

            Text{
                id: textFrom
                anchors.fill: parent
                property string tmpText: ""
                font.pixelSize: 30
                font.bold: true
                text: {
                    if(outer.isFrom)
                        outer.currentItem.text + ":" + inner.currentItem.text
                }
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                MouseArea{
                    width: 80
                    height:  parent.height
                    onClicked: {
                        outer.choiceActive = inner.choiceActive = !outer.choiceActive
                        outer.isFrom = true
                    }
                }
            }
        }*/

        /* RowLayout{
                    id: rowLayoutTo
                    spacing: 0
                    anchors.topMargin: 10
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: label_Bis.bottom
                    Text{
                        id: textTo
                        property string tmpText: ""
                        font.pixelSize: 30
                        font.bold: true
                        text: {
                            if(!outer.isFrom)
                                outer.currentItem.text + ":" + inner.currentItem.text
                        }
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignLeft
                        MouseArea{
                            width: 80
                            height:  parent.height
                            onClicked: {
                                outer.choiceActive = inner.choiceActive = !outer.choiceActive
                                outer.isFrom = false

                            }
                        }
                    }



                } */

        /* PathView{
            id: outer
            property bool pressed: false
            property bool isFrom: true

            model: 24

            interactive: false
            highlightRangeMode: PathView.NoHighlightRange
            property bool choiceActive: false
            anchors.bottomMargin: parent.height / 2
            anchors.leftMargin: parent.width /4
            anchors.bottom: parent.bottom
            clip: false
            anchors.left: parent.left

            highlight: Rectangle{
                width: 30 * 1.5
                height: width
                radius: width / 2
                border.color: "darkgray"
                color: "steelblue"
                visible: outer.choiceActive
            }

            delegate: Item {
                width: 30
                height: 30
                property bool currentItem: PathView.view.currentIndex == index
                property alias text: textHou.text
                Text{
                    id: textHou
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    font.bold: true
                    text: index
                    color: currentIndex ? "black" : "gray"
                }

                MouseArea{
                    anchors.fill: parent
                    enabled: outer.choiceActive
                    onClicked: outer.choiceActive = false
                    hoverEnabled: true
                    onEntered: outer.currentIndex = index
                }
            }

            path: Path{
                startX: 200
                startY: 0
                PathArc{
                    x: 80
                    y: 240
                    radiusX: 110
                    radiusY: 110
                    useLargeArc: false
                }

                PathArc{
                    x: 200
                    y: 0
                    radiusX: 110
                    radiusY: 110
                    useLargeArc: false
                }
            }
        }

        PathView{
            id: inner
            property bool pressed: false
            model: 12
            interactive: false
            highlightRangeMode: PathView.NoHighlightRange
            property bool choiceActive: false
            anchors.leftMargin: outer.anchors.leftMargin
            anchors.bottomMargin: outer.anchors.bottomMargin
            anchors.bottom: parent.bottom
            clip: false
            anchors.left: parent.left

            highlight: Rectangle{
                width: 30 * 1.5
                height: width
                radius: width / 2
                border.color: "darkgray"
                color: "lightgreen"
                visible: inner.choiceActive
            }

            delegate: Item {
                width: 30
                height: 30
                property bool currentItem: PathView.view.currentIndex == index
                property alias text: textMin.text
                Text{
                    id: textMin
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    text: index * 5
                    color: currentItem ? "black" : "gray"
                }

                MouseArea{
                    anchors.fill: parent
                    enabled: inner.choiceActive
                    onClicked: inner.choiceActive = false
                    hoverEnabled: true
                    onEntered: inner.currentIndex = index
                }
            }

            path: Path{
                startX: 140
                startY: 30

                PathArc{
                    x: 140
                    y: 220
                    radiusX: 40
                    radiusY: 40
                    useLargeArc: false
                }

                PathArc{
                    x: 140
                    y: 30
                    radiusX: 40
                    radiusY: 40
                    useLargeArc: false
                }
            }
        }

        onVisibleChanged: {
            var d = new Date();
            outer.currentIndex = 0
            inner.currentIndex = 0
        }

        */ Button {
            id: button_AddEntry
            y: 854
            text: qsTr("erstellen")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            onClicked: {

                if(calendar.selectedDate !== "" && textField_Title.text !== "" && textField_Anmerkung.text !== "" && label_from.text !== "" && label_to.text !== ""){

                    if(getHours(label_from.text) <= getHours(label_to.text)){
                        if(getMinutes(label_from.text) <= getMinutes(label_to.text)){
                            userCalendarBackendAddEntrys.insertIntoDatabase(calendar.selectedDate, textField_Title.text, textField_Anmerkung.text, label_from.text, label_to.text)
                            label_InputInfo.text = "";
                            textField_Title.text = "";
                            textField_Anmerkung.text = "";
                        } else {
                            label_InputInfo.text = "Das Von Datum darf nicht kleiner seine als das Bis Datum";
                        }
                    } else {
                        label_InputInfo.text = "Das Von Datum darf nicht kleiner seine als das Bis Datum";
                    }

                } else {
                    label_InputInfo.text = "Sie müsse alle Felder ausfüllen";
                }
            }
        }

        Label {
            id: label_InputInfo
            y: 836
            color: "#ff3b3b"
            font.pointSize: 16
            anchors.bottom: button_AddEntry.top
            anchors.bottomMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            wrapMode: "Wrap"
        }

        Rectangle {
            id: rectangle_timePicker
            color: "#00ffffff"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: textField_Anmerkung.bottom
            anchors.bottom: label_InputInfo.top
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            clip: true
            anchors.bottomMargin: 10
            anchors.topMargin: 20

            Label {
                id: label_minutes
                text: tumbler_minutes.currentIndex
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: tumbler_minutes.horizontalCenter
                font.pointSize: 14
            }

            Label {
                id: label_hours
                text: tumbler_hours.currentIndex
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: tumbler_hours.horizontalCenter
                font.pointSize: 14
            }

            Tumbler {
                id: tumbler_minutes
                anchors.top: label_minutes.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                clip: false
                anchors.horizontalCenterOffset: 40
                anchors.horizontalCenter: parent.horizontalCenter
                model: 60
                onCurrentIndexChanged: {
                    label_minutes.text = currentIndex
                }
            }

            Tumbler {
                id: tumbler_hours
                anchors.top: label_hours.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                anchors.bottomMargin: 10
                clip: false
                anchors.horizontalCenterOffset: -40
                anchors.horizontalCenter: parent.horizontalCenter
                model: 24
            }

            Label {
                id: label_time
                x: -73
                y: 231
                text: qsTr(":")
                anchors.verticalCenter: label_hours.verticalCenter
                anchors.left: label_hours.right
                anchors.right: label_minutes.left
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                font.pointSize: 14
            }

            Button {
                id: button_from
                text: qsTr("Von")
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.leftMargin: 0
                onClicked: {
                    var timeFormated = label_hours.text + ":" + label_minutes.text
                    label_from.text = timeFormated;
                }
            }

            Button {
                id: button_to
                text: qsTr("Bis")
                anchors.left: parent.left
                anchors.top: label_from.bottom
                anchors.topMargin: 20
                anchors.leftMargin: 0
                onClicked: {
                    var timeFormated = label_hours.text + ":" + label_minutes.text
                    label_to.text = timeFormated;
                }
            }

            Label {
                id: label_from
                x: 37
                text: qsTr("0:0")
                anchors.top: button_from.bottom
                anchors.horizontalCenter: button_from.horizontalCenter
                anchors.topMargin: 10
                font.pointSize: 14
            }

            Label {
                id: label_to
                x: 37
                text: qsTr("0:0")
                anchors.top: button_to.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: button_to.horizontalCenter
                font.pointSize: 14
            }



        }

    }

    function getHours(time){
        var isHours = true
        var tmp = "";
        for(var i = 0; i < 5; i++){

            if(time[i] === ':'){
                isHours = false;
            }

            if(typeof(time[i]) != "undefined" && isHours){
                tmp += time[i];
            }
        }

        return tmp *1
    }

    function getMinutes(time){
        var isMinutes = false
        var tmp = "";
        for(var i = 0; i < 5; i++){

            if(typeof(time[i]) != "undefined" && isMinutes){
                tmp += time[i];
            }

            if(time[i] === ':'){
                isMinutes = true;
            }
        }

        return tmp *1;
    }

    Component.onCompleted: {
        outer.isFrom = false
        outer.isFrom = true
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
