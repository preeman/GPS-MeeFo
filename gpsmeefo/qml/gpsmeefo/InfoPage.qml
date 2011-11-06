import QtQuick 1.1
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Page {
    tools: infopageTools
    orientationLock: PageOrientation.LockPortrait
    Component.onCompleted: {
    //theme.inverted = true
    }

    Rectangle {
    id: infopage
    width: parent.width
    height: parent.height
    color: !theme.inverted ? "White" : "Black"

    Flickable {
        id: infoflickable
        width: parent.width - 40
        height: parent.height - 40
        clip: true
        anchors.centerIn: parent
        contentHeight: 1250
        contentWidth: parent.width - 40
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: infocolumn
            spacing: 40
            width: parent.width
            Row {
                spacing: 20
                Image {
                    source: "meego_gpsinfoqt.png"
                    smooth: true
                    width: 80
                    height: 80
                }
                Column {
                    spacing: 10
                    Text {
                        text: "GPS MeeFo"
                        font.pixelSize: UIConstants.FONT_XLARGE
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        //font.pointSize: 30
                        //color: "white"
                        font.capitalization: Font.SmallCaps
                        smooth: true
                        width: paintedWidth
                        height: paintedHeight
                        verticalAlignment: Text.AlignTop
                    }
                    Text {
                        text: "made in Qt for N950/N9 v1.2.0"
                        font.pixelSize: UIConstants.FONT_XSMALL
                        color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                        //font.pointSize: 30
                        //color: "darkgrey"
                        smooth: true
                        width: infoflickable.width - 120
                        height: paintedHeight
                        wrapMode: Text.WordWrap
                    }
                }
            }
            Row {
                spacing: 20
                Image {
                    source: theme.inverted ? "refresh.png" : "refreshW.png"
                }
                Text {
                    text: "Click on Refresh Icon to refresh Current Data. This will restart timers and restart GPS info collection."
                    width: infoflickable.width - 40
                    wrapMode: Text.WordWrap
                    smooth: true
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    //font.pointSize: 30
                    //color: "white"
                }
            }
            Row {
                spacing: 20
                Image {
                    source: theme.inverted ? "share.png" : "shareW.png"
                }
                Text {
                    text: "Click on the Share Icon to Copy your average position to the clipboard."
                    width: infoflickable.width - 40
                    wrapMode: Text.WordWrap
                    smooth: true
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    //font.pointSize: 30
                    //color: "white"
                }
            }
            Row {
                spacing: 20
                Image {
                    source: theme.inverted ? "info.png" : "infoW.png"
                }
                Text {
                    text: "The Info Icon brings up this help page."
                    width: infoflickable.width - 40
                    wrapMode: Text.WordWrap
                    smooth: true
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    //font.pointSize: 30
                    //color: "white"
                }
            }
            Row {
                spacing: 20
                Image {
                    source: theme.inverted ? "back.png" : "backW.png"
                }
                Text {
                    text: "The Back button will take you back one step or Quit if you are on the main page." //+
                          //" This App will Auto Quit after 20 minutes of no use."
                    width: infoflickable.width - 40
                    wrapMode: Text.WordWrap
                    smooth: true
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    //font.pointSize: 30
                    //color: "white"
                }
            }
            Text {
                text: "Comparative data is counted once the first valid signal is received by the unit; average is based on the number of valid signals, not time. " +
                "The green bars show the power level and use of each satellite."
                width: infoflickable.width - 40
                wrapMode: Text.WordWrap
                smooth: true
                font.pixelSize: UIConstants.FONT_DEFAULT
                color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                //font.pointSize: 30
                //color: "white"
            }
            Text {
                text: "GPS accuracy mapping shows the accuracy in metres for the last valid signal (Light Green Bar). " +
                "The Dark Green bar represents the average accuracy level."
                width: infoflickable.width - 40
                wrapMode: Text.WordWrap
                smooth: true
                font.pixelSize: UIConstants.FONT_DEFAULT
                color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                //font.pointSize: 30
                //color: "white"
            }
            Text {
                text: "The GPS location mapping shows the positions of the last 5 coordinates received and the average position, " +
                "if you have a good signal in the same spot all the red dots should be very close to the centre."
                width: infoflickable.width - 40
                wrapMode: Text.WordWrap
                smooth: true
                font.pixelSize: UIConstants.FONT_DEFAULT
                color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                //font.pointSize: 30
                //color: "white"
            }
            Text {
                text: "Check out http://www.preesworld.com/mobile or follow @mjjagpal for more."
                width: infoflickable.width - 40
                wrapMode: Text.WordWrap
                smooth: true
                font.pixelSize: UIConstants.FONT_DEFAULT
                color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                //font.pointSize: 30
                //color: "white"
            }
        }
    }
    }

    ToolBarLayout {
        id: infopageTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: parent.left
            onClicked: appWindow.pageStack.push(mainPage)
        }
    }
}
