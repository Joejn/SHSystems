import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQml 2.12
import Qt.labs.folderlistmodel 2.12
import com.SmartHome.Entertainment 1.0

Item {
    id: item_audio_player
    visible: true
    width: 1400
    height: 800

    Material.theme: Material.Dark
    Material.accent: Material.DeepOrange

    Entertainment{
        id: entertainment
    }

    property var locale: Qt.locale()
    property string dateString
    property bool firstPressSlider: true
    property bool isPlaying: false
    property bool isLooped: false

    property string listViewDefaultTextColor: "white"

    property color backgroundColor: "#3a3a3a"

    Audio {
        id: audio
        onStatusChanged: {
            if(isPlaying){
                audio.pause()
                audio.play()
            } else {
                audio.pause()
            }
        }
    }

    Rectangle {
        id: rectangle_main
        color: backgroundColor
        anchors.fill: parent

        Rectangle {
            id: rectangle
            x: 20
            y: 20
            color: "#00ffffff"
            border.color: "#00000000"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            clip: true
            anchors.bottomMargin: 20
            anchors.topMargin: 20
            anchors.rightMargin: 300
            anchors.leftMargin: 20

            Label {
                id: label_duration
                x: 507
                y: 587
                text: entertainment.durationStr
                anchors.bottom: slider_duration.top
                anchors.bottomMargin: 8
                anchors.right: slider_duration.right
                anchors.rightMargin: 0
                verticalAlignment: Text.AlignBottom
                horizontalAlignment: Text.AlignRight
            }

            Label {
                id: label_current_duration
                x: -89
                y: 587
                text: entertainment.currentPositionStr
                anchors.left: slider_duration.left
                anchors.leftMargin: 0
                anchors.bottom: slider_duration.top
                anchors.bottomMargin: 8
            }

            Slider {
                id: slider_duration
                x: -89
                y: 608
                height: 40
                anchors.bottom: roundButton_play.top
                anchors.bottomMargin: 32
                from: 0
                to: entertainment.duration
                anchors.left: parent.left
                anchors.leftMargin: 160
                anchors.right: parent.right
                anchors.rightMargin: 40
                value: entertainment.currentPosition
                onPressedChanged: {
                    if(!pressed){
                        entertainment.setCurrentPosition(value)
                    }
                }
            }

            Label {
                id: label_album
                x: -134
                y: 79
                text: entertainment.albumTitle
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.left: roundButton_Volume_high.right
                anchors.leftMargin: 40
                font.pointSize: 16
                anchors.bottom: image_cover.top
                anchors.bottomMargin: 16
                anchors.horizontalCenter: image_cover.horizontalCenter
            }

            Label {
                id: label_artist
                x: -95
                y: 497
                text: entertainment.albumArtist
                anchors.left: label_Volume.right
                anchors.leftMargin: 40
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                anchors.top: label_song.bottom
                anchors.topMargin: 16
                anchors.horizontalCenter: image_cover.horizontalCenter
            }

            Label {
                id: label_song
                x: -95
                y: 456
                text: entertainment.title
                anchors.left: label_Volume.right
                anchors.leftMargin: 40
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 16
                anchors.top: image_cover.bottom
                anchors.topMargin: 16
                anchors.horizontalCenter: image_cover.horizontalCenter
            }

            Image {
                id: image_cover
                x: -11
                y: 120
                height: 100
                anchors.top: parent.top
                anchors.topMargin: 160
                anchors.left: slider_Volume.right
                anchors.right: parent.right
                anchors.leftMargin: 40
                anchors.verticalCenterOffset: -80
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/Icons/Icons_Media_Player/music-note-1275650_1920.png"
                anchors.rightMargin: 0
                fillMode: Image.PreserveAspectFit
            }

            RoundButton {
                id: roundButton_Mute
                x: 160
                y: 680
                icon.source: entertainment.isMuted ? "qrc:/Icons/Icons_Media_Player/bootstrap/volume-mute-fill.svg" : "qrc:/Icons/Icons_Media_Player/bootstrap/volume-up-fill.svg"
                icon.height: height / 3
                icon.width: width / 3
                anchors.right: roundButton_song_before.left
                anchors.rightMargin: 16
                anchors.verticalCenter: roundButton_play.verticalCenter
                highlighted: entertainment.isMuted ? true : false
                onClicked: {
                    entertainment.setMuted();
                }
            }

            Label {
                id: label_Volume
                x: -155
                y: 348
                font.pointSize: 14
                anchors.left: slider_Volume.right
                anchors.leftMargin: 16
                anchors.verticalCenter: slider_Volume.verticalCenter
                text: slider_Volume.value
            }

            RoundButton {
                id: roundButton_Volume_high
                x: -214
                y: 0
                text: "+"
                anchors.top: parent.top
                anchors.topMargin: 40
                anchors.horizontalCenter: roundButton_Volume_low.horizontalCenter
                onClicked: {
                    slider_Volume.value += 1;
                    entertainment.setVolume(slider_Volume.value)
                }
            }

            RoundButton {
                id: roundButton_Volume_low
                x: -214
                y: 680
                text: "-"
                anchors.verticalCenter: roundButton_play.verticalCenter
                anchors.right: slider_duration.left
                anchors.rightMargin: 80
                onClicked: {
                    slider_Volume.value -= 1;
                    entertainment.setVolume(slider_Volume.value)
                }
            }

            Slider {
                id: slider_Volume
                x: -218
                y: 48
                width: 47
                stepSize: 1
                anchors.top: roundButton_Volume_high.bottom
                anchors.topMargin: 8
                anchors.bottom: roundButton_Volume_low.top
                anchors.bottomMargin: 8
                anchors.horizontalCenter: roundButton_Volume_high.horizontalCenter
                orientation: Qt.Vertical
                to: 100
                value: entertainment.volume
                onPressedChanged: {
                    entertainment.setVolume(value)
                }
            }

            RoundButton {
                id: roundButton_isLooped
                x: 384
                y: 680
                icon.source: "qrc:/Icons/Icons_Media_Player/bootstrap/arrow-repeat.svg"
                icon.height: height / 3
                icon.width: width / 3
                highlighted: entertainment.isLooped ? true : false
                anchors.left: roundButton_song_next.right
                anchors.leftMargin: 16
                anchors.verticalCenter: roundButton_play.verticalCenter
                onClicked: {
                    entertainment.setLooped()
                }
            }

            RoundButton {
                id: roundButton_song_next
                x: 328
                y: 680
                icon.source: "qrc:/Icons/Icons_Media_Player/bootstrap/skip-end-fill.svg"
                icon.height: height / 3
                icon.width: width / 3
                anchors.left: roundButton_play.right
                anchors.leftMargin: 16
                anchors.verticalCenter: roundButton_play.verticalCenter
                onClicked: {
                    entertainment.nextSong()
                }
            }

            RoundButton {
                id: roundButton_song_before
                x: 216
                y: 680
                icon.source: "qrc:/Icons/Icons_Media_Player/bootstrap/skip-start-fill.svg"
                icon.height: height / 3
                icon.width: width / 3
                anchors.right: roundButton_play.left
                anchors.rightMargin: 16
                anchors.verticalCenter: roundButton_play.verticalCenter
                onClicked: {
                    entertainment.previewSong()
                }
            }

            RoundButton {
                id: roundButton_play
                x: 272
                y: 680
                icon.source: entertainment.isPlaying ? "qrc:/Icons/Icons_Media_Player/bootstrap/pause-fill.svg" : "qrc:/Icons/Icons_Media_Player/bootstrap/play-fill.svg"
                icon.height: height / 3
                icon.width: width / 3
                anchors.horizontalCenter: slider_duration.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
                onClicked: {
                    entertainment.setPlaying();
                }
            }
        }

        ToolSeparator {
            id: toolSeparator
            x: 1097
            y: 20
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.right: listView.left
            anchors.rightMargin: 10
        }

        ListView{
            id: listView
            x: 1120
            y: 20
            width: 300
            anchors.left: rectangle.right
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.topMargin: 20
            clip: true
            model: entertainment.myModel
            currentIndex: entertainment.currentSong
            delegate: Component {
                Item {
                    width: parent.width
                    height: 40
                    Column {
                        Text {
                            text: modelData
                            color: index == listView.currentIndex ? "#3F51B5" : listViewDefaultTextColor
                            font.pointSize: 11
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            entertainment.setCurrentSong(index)
                        }
                    }
                }
            }

            Label {
                id: label_mqttConnectionInfo
                anchors.fill: parent
                text: entertainment.mqttConnectionInfo
                wrapMode: Label.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 16
            }
        }


    }

    function changeTheme(theme){
        if(theme === "Dark"){
            Material.theme = Material.Dark;
            Material.accent = Material.DeepOrange;
            listViewDefaultTextColor = "white"
            backgroundColor = "#3a3a3a"
        } else {
            Material.theme = Material.Light;
            Material.accent = Material.LightBlue;
            listViewDefaultTextColor = "black"
            backgroundColor = "#ffffff"
        }
    }
}
