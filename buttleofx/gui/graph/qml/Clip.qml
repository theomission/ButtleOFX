import QtQuick 2.0
import QuickMamba 1.0

Rectangle {
    id: clipRoot

    property string port
    property alias clipWrapper: m.clipWrapper
    property variant graphRoot
    property variant nodeRoot
    property alias clipSize: m.clipSize
    property bool accept: false
    property bool replace: false
    property bool enabled: m.enabled

    property bool readOnly
    property real miniatureScale
    property bool miniatureState

    QtObject {
        id: m
        property variant clipWrapper
        property double clipSize: 9
        property double radius: 0.5 * clipRoot.clipSize
        property bool enabled: true
    }

    objectName: "qmlClip_" + m.clipWrapper.fullName
    height: m.clipSize
    width: m.clipSize
    color: clipMouseArea.containsMouse ? "#00b2a1" : "#55bbbb"
    radius: width * 0.5

    // Synchronize QML graphic information (clip position) into the model,
    // to share it with connection objects
    property double x_inGraph
    property double y_inGraph
    property double xCenter_inGraph: x_inGraph + m.radius
    property double yCenter_inGraph: y_inGraph + m.radius
    onXCenter_inGraphChanged: {
        m.clipWrapper.xCoord = xCenter_inGraph
    }
    onYCenter_inGraphChanged: {
        m.clipWrapper.yCoord = yCenter_inGraph
    }

    Rectangle {
        id: clipName
        color: clipMouseArea.containsMouse ? "#fff" : "#333"
        radius: 3
        opacity: clipMouseArea.containsMouse ? 1 : 0
        height: 17
        width: clipNameText.width + 10
        x: clipRoot.port == "output" ? parent.x + 15 : parent.x - clipNameText.width - 15
        y: -5

        Text{
            id: clipNameText
            text: m.clipWrapper.name
            font.pointSize: 8
            color: "#999"
            x: 7
            y: 4
        }
    }

    DropArea {
        id: droparea
        objectName: "DropArea"
        width: 15
        height: 15
        keys: "clip_connection"
        onDropped: {
            // Accepts the drop and erase the handle
            drop.accept()

            dropHandle.state = ""

            var clipOut = null
            var clipIn = null
            if( m.clipWrapper.name == "Output" )
            {
                // Drop on output
                clipOut = m.clipWrapper
                clipIn = drag.source.clipWrapper
            }
            else
            {
                // Drop on input
                clipOut = drag.source.clipWrapper
                clipIn = m.clipWrapper
            }
            if(accept && !replace){
                _buttleManager.connectionManager.connectWrappers(clipOut, clipIn)
                drag.source.enabled = false
                m.enabled = false
            }

            if(accept && replace){
                _buttleManager.connectionManager.replace(m.clipWrapper, clipOut, clipIn)
                drag.source.enabled = false
                m.enabled = false
            }

        }
        onEntered: {
            accept = _buttleManager.connectionManager.canConnect(m.clipWrapper, drag.source.clipWrapper)
            replace = _buttleManager.connectionManager.connectionExists(m.clipWrapper, drag.source.clipWrapper)
            if(accept){
                dropHandle.state = "entereddrop"
            }else{
                    dropHandle.state = "cantconnect"
            }
            if(replace && accept)
                dropHandle.state = "canreplace"
        }
        onExited: {
            // Erase the handle
            dropHandle.state = ""
        }
    }
    // Area that accepts the drop
    Item {
        id: dropHandle
        property int handleRadius: m.radius + 3
        x: - 0.5 * (width - parent.width)
        y: - 0.5 * (height - parent.height)
        width: 2 * handleRadius + 1
        height: 2 * handleRadius + 1

        Rectangle {
            id: dropVisualHandle
            anchors.fill: parent
            opacity: 0
            radius: parent.handleRadius
            color: "#32d2cc"
        }
        states: [
            State {
               name: "entereddrop"
               PropertyChanges {
                  target: dropVisualHandle
                  opacity: 0.6
               }
            },
            State {
               name: "cantconnect"
               PropertyChanges {
                  target: dropVisualHandle
                  opacity: 0.6
                  color: "#212121"
               }
            },
            State {
               name: "canreplace"
               PropertyChanges {
                  target: dropVisualHandle
                  opacity: 0.6
                  color: "#f7ff76"
               }
            }
        ]
    }

    // MouseArea dedicated to the QML drag and drop
    MouseArea {
        enabled: !readOnly
        id: clipMouseArea
        anchors.fill: parent
        hoverEnabled: true
        drag.target: handle
        Drag.active: true


        // position of the center of the clip when starting a mouse event
        property int xStart
        property int yStart
        // position of the mouse when starting a mouse event
        property int mouseXStart
        property int mouseYStart

        onReleased: {
            var dropStatus = handle.Drag.drop()
            connections.tmpConnectionExists = false
            if (dropStatus !== Qt.IgnoreAction)
                console.log("Clip connexion accepted!")
        }

        // Invisble rectangle which is dragged from an output to an input
        Item {
            id: handle
            x: 0
            y: 0
            property int handleRadius: 5
            property variant clipWrapper: m.clipWrapper

            width: 2 * handleRadius + 1
            height: 2 * handleRadius + 1

            Drag.keys: "clip_connection"
            Drag.active: clipMouseArea.drag.active
            Drag.hotSpot.x: 0.5 * width
            Drag.hotSpot.y: 0.5 * height

            Rectangle {
                id: visualHandle
                opacity: 1
                radius: parent.handleRadius

                anchors.fill: parent

                color: "#32d2cc"
            }
            states: [
                State {
                   name: "nodragging"
                   when: ! handle.Drag.active || (_buttleManager.connectionManager.connectionExists(m.clipWrapper, m.clipWrapper))
                   PropertyChanges {
                      target: handle
                      opacity: 0
                      x: 0
                      y: 0
                   }
                },
                State {
                   name: "dragging"
                   when: drag.source.clipWrapper
                   PropertyChanges {
                      target: handle
                      opacity: 1
                      x: 0
                      y: 0
                      width: 0.6*width
                      height: 0.6*height
                   }
                },
                State {
                   name: "draggable"
                   when: handle.Drag.active
                   PropertyChanges {
                      target: handle
                      Drag.keys: "clip_connection"
                   }
                }
            ]
        }

        onPressed: {
            // take the focus of the MainWindow
            clipRoot.forceActiveFocus()
                mouseXStart = mouse.x
                mouseYStart = mouse.y
                xStart = xCenter_inGraph
                yStart = yCenter_inGraph

                // display of the tmpConnection with right coordinates
                connections.tmpConnectionExists = true
                connections.tmpClipName = m.clipWrapper.name

                connections.tmpConnectionX1 = xCenter_inGraph
                connections.tmpConnectionY1 = yCenter_inGraph
                connections.tmpConnectionX2 = xCenter_inGraph
                connections.tmpConnectionY2 = yCenter_inGraph
       }
       onPositionChanged: {
           if(!(_buttleManager.connectionManager.connectionExists(m.clipWrapper, m.clipWrapper))){
               // Update of the connection during the drag
               if(clipMouseArea.drag.active) {
                    if (connections.tmpClipName == "Output") {
                        connections.tmpConnectionX2 = x_inGraph + mouse.x
                        connections.tmpConnectionY2 = y_inGraph + mouse.y
                    } else {
                        connections.tmpConnectionX1 = x_inGraph + mouse.x
                        connections.tmpConnectionY1 = y_inGraph + mouse.y
                    }
                    //Hack to position correctly the handle (the drag in QML creates a gap)
                    handle.x = mouseX - handle.width/2
                    handle.y = mouseY - handle.height/2
               }
           }
        }
    }
}
