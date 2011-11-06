import QtQuick 1.1
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants


Page {
    tools: splashpageTools
    orientationLock: PageOrientation.LockPortrait
    Component.onCompleted: {
    theme.inverted = true
    }

    Rectangle {
    id: splashpage
    width: parent.width
    height: parent.height
    color: "black"

        Image {
            id: splash_image
            source: "meego_gpsinfoqt.png"
            anchors.centerIn: parent
        }
        Text {
            id: splash_title
            text: "GPS MeeFo"
            anchors.top: splash_image.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            font.pixelSize: UIConstants.FONT_XLARGE
            color: UIConstants.COLOR_INVERTED_FOREGROUND
            font.capitalization: Font.SmallCaps
            smooth: true
        }
        Text {
            id: splash_intro
            text: "The application is loading. v1.2.0"
            anchors.top: splash_title.bottom
            anchors.topMargin: 15
            font.pixelSize: UIConstants.FONT_XSMALL
            color: UIConstants.COLOR_INVERTED_FOREGROUND
            wrapMode: Text.WordWrap
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    ToolBarLayout {
        id: splashpageTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: parent.left
            onClicked: Qt.quit()
        }
    }
}
