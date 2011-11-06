import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: splashPage
    showStatusBar: appWindow.inPortrait

    MainPage {
        id: mainPage
    }

    SplashPage {
        id: splashPage
    }

    InfoPage {
        id: infoPage
    }

    Timer {
        id: splashpagetimer
        running: true
        repeat: false
        interval: 2500
        onTriggered: {
            appWindow.pageStack.push(mainPage)
        }
    }

}
