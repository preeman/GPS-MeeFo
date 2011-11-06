import QtQuick 1.1
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import QtWebKit 1.0
import QtMobility.location 1.1


Page {
    tools: mainTools
    id: mainpage
    orientationLock: PageOrientation.LockPortrait
    Component.onCompleted: {
        theme.inverted = true
        //get old SMS number is stored in SQLite
        //getSMSnumber();
    }

    property int samplenumber: 0
    property int accnumber: 0
    property real avglat: 0
    property real totallat: 0
    property real avglong: 0
    property real totallong: 0
    property real avgalt: 0
    property real totalalt: 0
    property real avgspeed: 0
    property real totalspeed: 0
    property real avgaccx: 0
    property real totalaccx: 0
    property real avgaccy: 0
    property real totalaccy: 0

    property string units: "m"
    property string unitsD: "g"



    //Timer to show Sats in View at the start of the application
    Timer {
        id: applicationstartingtimer
        running: true
        repeat: true
        interval: 3000
        onTriggered: {
            bootupdetailtext.text = "Still looking for a valid signal. " +
                    "Right now we have " + sats.getSatsInView() + " satellites in view."
            satsdata.model = sats.getViewData()
            satsViewdisplaydata.model = sats.getViewData()
            activesignaltext = "No"
            satsinviewtext.text = sats.getSatsInView()
        }
    }
    //Timer to update the details on screen
    Timer {
        id: applicationupdatetimer
        running: true
        repeat: true
        interval: 3000
        onTriggered: {
            gpsWorker()
        }
    }
    //Timer to see current running time of the session
    Timer {
        id: sessiontimer
        running: false
        repeat: false
        interval: 300000 // 40000 //
        onTriggered: {
            applicationupdatetimer.stop()
            applicationstartingtimer.stop()
            positionSource.active = false
            searchingoverlay.visible = true
            nextoptionbox.visible = true
        }
    }


    // Detailed list Model for accuracy mapping
    ListModel {
        id: accuracyModel
        ListElement {countid: 1; accx: 0; accy: 0; }
        ListElement {countid: 2; accx: 0; accy: 0; }
        ListElement {countid: 3; accx: 0; accy: 0; }
        ListElement {countid: 4; accx: 0; accy: 0; }
        ListElement {countid: 5; accx: 0; accy: 0; }
    }

    //Shows what is being used for the position in PositionSource
    function printableMethod(method) {
        if (method == PositionSource.SatellitePositioningMethod)
            return "Satellite";
        else if (method == PositionSource.NoPositioningMethod)
            return "Not available"
        else if (method == PositionSource.NonSatellitePositioningMethod)
            return "Non-satellite"
        else if (method == PositionSource.AllPositioningMethods)
            return "All/multiple"
        return "source error";
    }
    //Uses the details from PositionSource to provide updates
    function gpsWorker() {

        if (positionSource.position.longitudeValid == true && positionSource.position.latitudeValid == true && positionSource.position.altitudeValid == true) {
            //Hide the searching for signal
            searchingbox.visible = false
            //Stop covering the rest of the screen with black overaly
            searchingoverlay.visible = false

            //General work for updates
            satsinviewtext.text = sats.getSatsInView()
            satsinusetext.text = sats.getSatsInUse()
            satsViewdisplaydata.model = sats.getViewData()
            satsUsedisplaydata.model = sats.getUseData()
            satsusedata.model = sats.getUseData()
            activesignaltext.text = "Yes"
            samplenumber ++


            if (positionSource.position.verticalAccuracyValid  == true && positionSource.position.horizontalAccuracyValid  == true) {
                accuracyModel.insert(accnumber, {"accx": positionSource.position.coordinate.latitude, "accy": positionSource.position.coordinate.longitude})
                //console.log ("model parts: ",accnumber,accuracyModel.get(accnumber).accx, accuracyModel.get(accnumber).accy)
                accnumber = accnumber + 1
                if (accnumber==5) {accnumber = 0}
                //console.log (avglat, avglong)
            }

            // Avg Lat work
            if (avglat === 0) {
                totallat = positionSource.position.coordinate.latitude
                avglat = positionSource.position.coordinate.latitude
            }
            else {
                totallat = totallat + positionSource.position.coordinate.latitude
                avglat = totallat / ( samplenumber )
            }
            // Avg Long Work
            if (avglong == 0) {
                totallong = positionSource.position.coordinate.longitude
                avglong = positionSource.position.coordinate.longitude
            }
            else {
                totallong = totallong + positionSource.position.coordinate.longitude
                avglong = totallong / ( samplenumber )
            }
            // Avg Alt Work
            if (avgalt == 0) {
                totalalt = positionSource.position.coordinate.altitude
                avgalt = positionSource.position.coordinate.altitude
            }
            else {
                totalalt = totalalt + positionSource.position.coordinate.altitude
                avgalt = totalalt / ( samplenumber )
            }
            // Avg Speed Work
            if (avgspeed == 0) {
                avgspeed = positionSource.position.speed
                totalspeed = positionSource.position.speed
            }
            else {
                totalspeed = totalspeed + positionSource.position.speed
                avgspeed = totalspeed / ( samplenumber )
            }
            // ACC X Work
            if (avgaccx === 0) {
                totalaccx = positionSource.position.horizontalAccuracy
                avgaccx = positionSource.position.horizontalAccuracy
            }
            else {
                totalaccx = totalaccx + positionSource.position.horizontalAccuracy
                avgaccx = totalaccx /  ( samplenumber )
                avgaccxdot.opacity = 1
            }
            // ACC Y Work
            if (avgaccy === 0) {
                avgaccy = positionSource.position.verticalAccuracy
                totalaccy = positionSource.position.verticalAccuracy
            }
            else {
                totalaccy = totalaccy + positionSource.position.verticalAccuracy
                avgaccy = totalaccy /  ( samplenumber )
                avgaccydot.opacity = 1
            }
            //Load Map to the correct position after first fix.
            //Start the session timer to stop after certain run time.
            if(samplenumber===1) {
                map3.url = "http://m.ovi.me/?c="+avglat+","+avglong+"&z=16&w=420&h=420&nord"
                //console.log(map3.url)
                //Stop the updates to the bootup screen that says searching for signal
                applicationstartingtimer.running = false
                //Get the session timer to start
                sessiontimer.restart()

            }
            //SMS Work
            //smsmessage = "Lat " + avglat + ", Long " + avglong + "\n\n" +
            //        "http://m.ovi.me/?c=" + avglat + "," + avglong + "&z=13&nord"
        }

    }
    //Convert the Decimal Lat,Lon values to Degree Format
    function convertdectodeg(degvalue){
        var wholedeg
        var wholemins
        var wholesecs
        var degvalueR
        degvalueR = Math.abs(degvalue)
        wholedeg = Math.floor(degvalueR)
        wholemins = Math.floor((degvalueR - wholedeg) * 60)
        wholesecs = Math.floor((((degvalueR - wholedeg) * 60) - wholemins) * 60)
        return wholedeg + "° " + wholemins + "\' " + wholesecs + "\""
    }
    //Get SMS Number if in SQLite
    /*function getSMSnumber() {
        var db = openDatabaseSync("gpsinfoqt01", "1.0", "GPS Info Qt 01", 1000);
        db.transaction(
            //Actual SQL Work
            function(tx) {
                        // Create the database if it doesn't already exist
                        tx.executeSql('CREATE TABLE IF NOT EXISTS gpsinfoqt(smsnumber TEXT)');
                        var rs = tx.executeSql('SELECT smsnumber FROM gpsinfoqt');
                        if(rs.rows.length === 0) {
                            console.log("New Table made, row count gpsinfoqt for was 0")
                        }
                        else {
                            phonenumber = rs.rows.item(0).smsnumber
                            console.log("Old number:",rs.rows.item(0).smsnumber)
                        }
                    }
                    )
    }*/

    //GPS Location call
    PositionSource {
                id: positionSource
                updateInterval: 1500
                active: true
            }

    //Dark Screen Overlay 80%
    Rectangle {
        id: searchingoverlay
        anchors.fill: parent
        color: "black"
        opacity: 0.8
        z:2
    }
    //Searching for Signal Box with View Details
    Rectangle {
        id: searchingbox
        anchors.centerIn: parent
        radius: 20
        height: childrenRect.height + 20
        width: parent.width * 0.8
        color: "#2D7707"
        opacity: 1
        clip: true
        smooth: true
        z: 5
        Column {
            anchors.centerIn: parent
            width: parent.width - 30
            spacing: 10
            Text {
                id: bootuptext
                font.pixelSize: UIConstants.FONT_LARGE
                color: UIConstants.COLOR_INVERTED_FOREGROUND
                smooth:true
                text: "Searching for signal"
                height: paintedHeight
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                id: bootupdetailtext
                font.pixelSize: UIConstants.FONT_SMALL
                color: UIConstants.COLOR_INVERTED_FOREGROUND
                smooth:true
                text: "We are still looking for an active signal."
                height: paintedHeight
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
            // Use details from getViewData QList, We make a power bar using signal strength scaled by 6
            ListView {
                anchors.horizontalCenter: parent.horizontalCenter
                id: satsdata
                clip: true
                width: searchingbox.width - 20
                height: childrenRect.height
                interactive: false
                model: sats.getViewData()
                delegate:
                    Row {
                    width: parent.width
                    spacing: 20
                    height: 30
                    Text {
                    font.pixelSize: UIConstants.FONT_XSMALL
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                    text: "Satellite " + modelData.prn
                    verticalAlignment: Text.AlignVCenter
                    height: 30
                    width: 80
                    }
                    Rectangle {
                        color: "#36880B"
                        height: 20
                        width: 260
                        clip: true
                        anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                color: "#5BB600"
                                height: 20
                                width: modelData.signalstrength < 1 ? 1 : modelData.signalstrength *6
                            }
                    }
                }
                }
        }
    }
    //Next Option Box
    Rectangle {
        id: nextoptionbox
        anchors.centerIn: parent
        radius: 20
        height: childrenRect.height + 30
        width: parent.width * 0.8
        color: "#2D7707"
        opacity: 1
        visible: false
        clip: true
        smooth: true
        z: 20
        Column {
            anchors.centerIn: parent
            width: parent.width - 30
            height: childrenRect.height
            spacing: 10
            Text {
                font.pixelSize: UIConstants.FONT_LARGE
                color: UIConstants.COLOR_INVERTED_FOREGROUND
                smooth:true
                text: "Session has finished"
                height: paintedHeight
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                font.pixelSize: UIConstants.FONT_SMALL
                color: UIConstants.COLOR_INVERTED_FOREGROUND
                smooth:true
                text: "The current session has ended what would you like to do?"
                height: paintedHeight
                width: parent.width
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
            Rectangle {
                smooth:true
                color: "#5BB600"
                radius: 10
                width: parent.width - 50
                height: childrenRect.height + 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                    smooth:true
                    text: "View last session"
                    height: paintedHeight
                    width: parent.width - 10
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        nextoptionbox.visible = false
                        searchingoverlay.visible = false
                        activesignaltext.text = "No"
                    }
                }
            }
            Rectangle {
                smooth:true
                color: "#5BB600"
                radius: 10
                width: parent.width - 50
                height: childrenRect.height + 10
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: UIConstants.COLOR_INVERTED_FOREGROUND
                    smooth:true
                    text: "Start new session"
                    height: paintedHeight
                    width: parent.width - 10
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        positionSource.active = true
                        samplenumber = 0
                        avglat = 0
                        totallat = 0
                        avglong = 0
                        totallong = 0
                        avgalt = 0
                        totalalt = 0
                        avgspeed = 0
                        totalspeed = 0
                        avgaccx = 0
                        totalaccx = 0
                        avgaccy = 0
                        totalaccy = 0
                        applicationstartingtimer.running = true
                        applicationupdatetimer.running = true
                        sessiontimer.running = false
                        //Show the searching for signal
                        searchingbox.visible = true
                        //Show the box covering the rest of the screen with black overaly
                        searchingoverlay.visible = true
                        nextoptionbox.visible = false
                        activesignaltext.text = "No"
                    }
                }
            }
        }
    }


    // Display ViewSats based Azimuth from C++
    // This makes the VIEW sats on the Radar style image
    Component {
        id: satsViewDelegate
        Rectangle {
            color: "#2C6500"
            smooth: true
            x: 230 + modelData.rectx - 15 //Half of box size to re-center
            y: 230 + modelData.recty - 15 //Half of box size to re-center
            width: 30
            height: 30
            radius: modelData.prn
            Text {
                anchors.centerIn: parent
                text: modelData.prn
                font.pixelSize: UIConstants.FONT_XSMALL
                color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
            }
        }
    }

    // Display UseSats based Azimuth from C++
    // This makes the USE sats on teh Radar style image
    Component {
        id: satsUseDelegate
        Rectangle {
            color: "#5BB600"
            smooth: true
            x: 230 + modelData.rectx - 20 //Half of box size to re-center
            y: 230 + modelData.recty - 20 //Half of box size to re-center
            z: 5
            width: 40
            height: 40
            radius: modelData.prn
            Text {
                anchors.centerIn: parent
                text: modelData.prn
                font.pixelSize: UIConstants.FONT_SMALL
                color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
            }
        }
    }

    //Main Data View - A big flickable
    Flickable {
    id: flick
    anchors.fill: parent
    contentWidth: mainframe.width
    contentHeight: mainframe.height
    flickableDirection: Flickable.VerticalFlick
    clip:true

    Rectangle {
        color: !theme.inverted ? "White" : "Black"
        id: mainframe
        width: mainpage.width
        height: childrenRect.height + 40

        Column {
            width: mainframe.width - 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 20
            anchors.top: parent.top
            spacing: 10

            // ### Header Grey - Data Feeds
            Rectangle {
                color: !theme.inverted ? "lightgrey" : "#222222"
                height: 45
                radius: 10
                smooth: true
                width: parent.width
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Data from GPS unit"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Valid Signal
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Active Signal"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    id: activesignaltext
                    text: "No"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Positioning from
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Source"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: printableMethod(positionSource.positioningMethod)
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Current Latitude
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Latitude"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: unitsD == "g" ? (positionSource.position.coordinate.latitude < 0 ? convertdectodeg(positionSource.position.coordinate.latitude)  + " South" : convertdectodeg(positionSource.position.coordinate.latitude) + " North") : positionSource.position.coordinate.latitude
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Current Longitude
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Longitude"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: unitsD == "g" ? (positionSource.position.coordinate.longitude < 0 ? convertdectodeg(positionSource.position.coordinate.longitude) + " West" : convertdectodeg(positionSource.position.coordinate.longitude)+ " East") : positionSource.position.coordinate.longitude
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Current Altitude
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Altitude"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: (units == "m") ? (positionSource.position.coordinate.altitude).toPrecision(5) + " metres." : (positionSource.position.coordinate.altitude*3.28084).toPrecision(6) + " feet."
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Current Speeed
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Speed"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: (units == "m") ? (positionSource.position.speed).toPrecision(4) + " metres/second." : ((positionSource.position.speed)*3.28084).toPrecision(5) + " feet/second."
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Current TimeStamp
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Time"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: (positionSource.position.timestamp).toString()
                    width: parent.width - 180
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    wrapMode: Text.WordWrap
                }
            }
            // ### Header Spacer
            Rectangle {
                color: "transparent"
                height: 20
                width: parent.width
            }

            // ### Header Grey - Satellite Data
            Rectangle {
                color: !theme.inverted ? "lightgrey" : "#222222"
                height: 45
                radius: 10
                smooth: true
                width: parent.width
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Satellite data"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            //Number of Valid Samples
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Valid samples"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 240
                }
                Text {
                    text: samplenumber
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            //Number of  View Sats
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Satellites in view"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 240
                }
                Text {
                    id: satsinviewtext
                    text: "1"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            //Number of  Use Sats
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Satellites in use"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 240
                }
                Text {
                    id: satsinusetext
                    text: "0"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Shows Power Bar of the Satellites in Use
            ListView {
                anchors.horizontalCenter: parent.horizontalCenter
                id: satsusedata
                clip: true
                width: parent.width
                height: childrenRect.height
                interactive: false
                model: sats.getUseData()
                delegate:
                    Row {
                    width: parent.width
                    spacing: 20
                    height: 30
                    Text {
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                    text: "Satellite " + modelData.prn
                    verticalAlignment: Text.AlignVCenter
                    height: 30
                    width: 145
                    }
                    Rectangle {
                        color: "#36880B"
                        height: 20
                        width: 260
                        clip: true
                        anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                color: "#5BB600"
                                height: 20
                                width: modelData.signalstrength < 1 ? 1 : modelData.signalstrength *6
                            }
                    }
                }
                }
            //Show realative Satellite positions (In View and In Use)
            //In Use we have different color and size, along with higher Z value to be on top.
            Image {
                //Background Image to look like Radar Map
                source: !theme.inverted ? "gpsradarW.png" : "gpsradar.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 460
                height: 460
                smooth: true
                clip: true
                // Use the VIEW Data to plot rectangles
                Repeater {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    id: satsViewdisplaydata
                    clip: true
                    width: parent.width
                    height: parent.height
                    model: sats.getViewData()
                    delegate: satsViewDelegate
                }
                // Use the USE data to plot, this has different delegate to show brighter bigger boxes.
                // Also higher Z to show on top of  View Data above. There will be overlap in view and use sats
                Repeater {
                    z: 5
                    anchors.top: parent.top
                    anchors.left: parent.left
                    id: satsUsedisplaydata
                    clip: true
                    width: parent.width
                    height: parent.height
                    model: sats.getUseData()
                    delegate: satsUseDelegate
                }
            }
            // ### Header Spacer
            Rectangle {
                color: "transparent"
                height: 20
                width: parent.width
            }

            // ### Header Grey - Average Data
            Rectangle {
                color: !theme.inverted ? "lightgrey" : "#222222"
                height: 45
                radius: 10
                smooth: true
                width: parent.width
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Average data"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Average Latitude
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Avg Latitude"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: unitsD == "g" ? (avglat < 0 ? convertdectodeg(avglat) + " South" : convertdectodeg(avglat)+ " North") : avglat
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Average Longitude
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Avg Longitude"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: unitsD == "g" ? (avglong < 0 ? convertdectodeg(avglong) + " West" : convertdectodeg(avglong) + " East") : avglong
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Avg Altitude
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Avg Altitude"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: (units == "m") ? avgalt.toPrecision(5) + " metres." : (avgalt*3.28084).toPrecision(6) + " feet."
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Avg Speed
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Avg Speed"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 180
                }
                Text {
                    text: (units=="m") ? avgspeed.toPrecision(4) + " metres/second." : (avgspeed*3.28084).toPrecision(5) + " feet/second."
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Horizontal accuracy
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Horizontal Accuracy"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 240
                }
                Text {
                    text:  (units=="m") ? positionSource.position.horizontalAccuracy.toPrecision(4) + " metres." : (positionSource.position.horizontalAccuracy*3.28084).toPrecision(5) + " feet."
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Horizontal accuracy bar
            Rectangle {
                color: "#2C6500"
                height: 20
                anchors.left: parent.left
                width: 1 + Math.floor(avgaccx)*3

                Rectangle {
                    id: avgaccxdot
                    opacity: 0
                    color: "#5BB600"
                    width: 1
                    height: 20
                    x: 1 + Math.floor(positionSource.position.horizontalAccuracy)*3
                    anchors.verticalCenter: parent.verticalCenter
                }

            }
            // Vertical accuracy
            Row {
                width:  parent.width
                spacing: 5
                Text {
                    text: "Vertical Accuracy"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: "#818181"
                    width: 240
                }
                Text {
                    text:  (units=="m") ? positionSource.position.verticalAccuracy.toPrecision(4) + " metres." : (positionSource.position.verticalAccuracy*3.28084).toPrecision(5) + " feet."
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // Vertical accuracy bar
            Rectangle {
                color: "#2C6500"
                height: 20
                anchors.left: parent.left
                width: 1 + Math.floor(avgaccy)*3

                Rectangle {
                    id: avgaccydot
                    opacity: 0
                    color: "#5BB600"
                    width: 1
                    height: 20
                    x: 1 + Math.floor(positionSource.position.verticalAccuracy)*5
                    anchors.verticalCenter: parent.verticalCenter
                }

            }
            // ### SUB Spacer
            Rectangle {
                color: "transparent"
                height: 10
                width: parent.width
            }
            // Relative Dots plotting.
            Image {
                //Background Image to look like Radar Map
                source: !theme.inverted ? "gpsradarW.png" : "gpsradar.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: 460
                height: 460
                smooth: true
                clip: true
                // Use the Model Data to plot rectangles
                Rectangle {
                    id: rect1
                    color: "#2C6500"
                    width: 10
                    height: 10
                    x: 225 + Math.floor((accuracyModel.get(1).accx - avglat) * 200000)
                    y: 225 + Math.floor((accuracyModel.get(1).accy - avglong) * 200000)
                }
                Rectangle {
                    id: rect2
                    color: "#2C6500"
                    width: 10
                    height: 10
                    x: 225 + Math.floor((accuracyModel.get(2).accx - avglat) * 200000)
                    y: 225 + Math.floor((accuracyModel.get(2).accy - avglong) * 200000)
                }
                Rectangle {
                    id: rect3
                    color: "#2C6500"
                    width: 10
                    height: 10
                    x: 225 + Math.floor((accuracyModel.get(3).accx - avglat) * 200000)
                    y: 225 + Math.floor((accuracyModel.get(3).accy - avglong) * 200000)
                }
                Rectangle {
                    id: rect4
                    color: "#2C6500"
                    width: 10
                    height: 10
                    x: 225 + Math.floor((accuracyModel.get(4).accx - avglat) * 200000)
                    y: 225 + Math.floor((accuracyModel.get(4).accy - avglong) * 200000)
                }
                Rectangle {
                    id: rect5
                    color: "#2C6500"
                    width: 10
                    height: 10
                    x: 225 + Math.floor((accuracyModel.get(0).accx - avglat) * 200000)
                    y: 225 + Math.floor((accuracyModel.get(0).accy - avglong) * 200000)
                }

            }
            // ### SUB Spacer
            Rectangle {
                color: "transparent"
                height: 10
                width: parent.width
            }
            // Option to Nokia Map
            Rectangle {
                border.width: 1
                border.color: "#444444"
                color: theme.inverted ? "#222222" : "lightgrey"
                radius: 5
                width: parent.width - 10
                height:  ovimaptext.height + map3.height + ovimaptextbottom.height + 20
                anchors.horizontalCenter: parent.horizontalCenter

                // Mouse area for click to refresh
                MouseArea {
                    anchors.fill: parent
                    onClicked: { map3.url = "http://m.ovi.me/?c="+avglat+","+avglong+"&z=16&w=420&h=420&nord" }
                }
                // Text - Nokia Map of Average location
                Text {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.topMargin: 5
                    id: ovimaptext
                    text: "Nokia Map of Average location"
                    font.pixelSize: UIConstants.FONT_DEFAULT
                    color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND //"#818181"
                }
                // Map via Web View
                WebView {
                    id: map3
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: ovimaptext.bottom
                    anchors.topMargin: 5
                    url: "http://m.ovi.me/?c=0,0&z=16&w=420&h=420&nord"
                    preferredWidth: 420
                    preferredHeight: 420
                    scale: 1
                    smooth: false

                    // Loading Overlay with text
                    Rectangle {
                        anchors.centerIn: parent
                        id: map3loadingbox
                        width: 430
                        height: 430
                        color: "black"
                        opacity: 0
                        Text {
                            id: map3loading
                            text: "Loading New Map with Average Location"
                            color: "white"
                            smooth: true
                            font.pixelSize: UIConstants.FONT_DEFAULT
                            anchors.centerIn: parent
                            wrapMode: Text.WordWrap
                            width: parent.width - 20
                            horizontalAlignment : Text.AlignHCenter
                        }

                    }
                    onLoadStarted: {
                        map3loadingbox.opacity = 0.6
                    }
                    onLoadFinished: {
                        map3loadingbox.opacity = 0
                    }

                    // Mouse area for click to refresh
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { map3.url = "http://m.ovi.me/?c="+avglat+","+avglong+"&z=16&w=420&h=420&nord" }
                    }
                }
                Text {
                anchors.top: map3.bottom
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 5
                id: ovimaptextbottom
                text: "Tap map above to refresh"
                font.pixelSize: UIConstants.FONT_DEFAULT
                color: !theme.inverted ? UIConstants.COLOR_FOREGROUND : UIConstants.COLOR_INVERTED_FOREGROUND
                }
            }
            // ### SUB Spacer
            Rectangle {
                color: "transparent"
                height: 10
                width: parent.width
            }
        }
    }

    }

    Menu {
        id: menuShare
        visualParent: pageStack

        MenuLayout {
            MenuItem {
                id: copyPosition
                text: "Copy Avg position to clipboard"
                onClicked: {
                    Clippy.setText(("Lat: "+avglat+", Long:"+avglong))
                }
            }
            /*MenuItem {
                id: smsNow
                text: phonenumber === "" ? "No SMS Number" : "SMS to " + phonenumber
                onClicked: {
                    onClicked: phonenumber === "" ? appWindow.pageStack.push(smsPage) : SMS.SendSMS( phonenumber, smsmessage )
                }
            }
            MenuItem {
                id: newSMSNumber
                text: "Set new SMS number"
                onClicked: appWindow.pageStack.push(smsPage)
            }*/
        }
    }

    Menu {
        id: menuSettings
        visualParent: pageStack

        MenuLayout {
            MenuItem {
                id: chooseMeasurements
                text: (units == "m") ? "Use Imperial measurements." : "Use Metric measurements."
                onClicked: (units == "m") ? units = "f" : units = "m"
            }
            MenuItem {
                id: chooseNotation
                text: (unitsD == "g") ? "Use Decimal notation." : "Use Degrees notation."
                onClicked: (unitsD == "g") ? unitsD = "d" : unitsD = "g"
            }
            MenuItem {
                id: chooseTheme
                text: (theme.inverted) ? "Use Light theme." : "Use Dark theme."
                onClicked: (theme.inverted) ? (theme.inverted = false) : (theme.inverted = true)
            }
        }
    }


    ToolBarLayout {
        id: mainTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: parent.left
            onClicked: Qt.quit()
        }
        ToolIcon {
            platformIconId: "toolbar-refresh"
            onClicked: {
                positionSource.active = true
                samplenumber = 0
                avglat = 0
                totallat = 0
                avglong = 0
                totallong = 0
                avgalt = 0
                totalalt = 0
                avgspeed = 0
                totalspeed = 0
                avgaccx = 0
                totalaccx = 0
                avgaccy = 0
                totalaccy = 0
                applicationstartingtimer.running = true
                applicationupdatetimer.running = true
                sessiontimer.running = false
                //Show the searching for signal
                searchingbox.visible = true
                //Show the box covering the rest of the screen with black overaly
                searchingoverlay.visible = true
                activesignaltext.text = "No"
            }
        }
        ToolIcon {
            platformIconId: "toolbar-settings"
            onClicked: {
                (menuSettings.status == DialogStatus.Closed) ? menuSettings.open() : menuSettings.close()
            }
        }
        ToolIcon {
            platformIconId: "toolbar-share"
            onClicked: {
                (menuShare.status == DialogStatus.Closed) ? menuShare.open() : menuShare.close()
            }
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: appWindow.pageStack.push(infoPage)
        }
    }

}
