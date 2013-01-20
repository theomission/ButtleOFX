import QtQuick 1.1

/*ParamDouble3D containts two input field*/

Item {
    id: containerParamDouble3D
    implicitWidth: 300
    implicitHeight: 30

    /*Container of the two input field*/
     Row{
        id: paramDouble3DInputContainer
        spacing: 10

        // Title of the paramDouble
        Text {
            id: paramDouble3DTitle
            width: 80
            text: model.object.text + " : "
            color: "white"
           // font.pointSize: 8
            anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
        }  

        /* First input */
        Rectangle{
            height: 20
            width:40
            color: "#212121"
            border.width: 1
            border.color: "#333"
            radius: 3
            TextInput{
                id: paramDouble3Dinput1
                text: model.object.value1
                anchors.left: parent.left
                anchors.leftMargin: 5
                maximumLength: 5
                color: activeFocus ? "white" : "grey"
                width: 40
                selectByMouse : true
                onAccepted: model.object.value1 = paramDouble3Dinput1.text
                validator: DoubleValidator{
                    bottom: model.object.minimum
                    top:  model.object.maximum
                }
            }
        }

        /* Second input */
        Rectangle{
            height: 20
            width:40
            color: "#212121"
            border.width: 1
            border.color: "#333"
            radius: 3
            TextInput{
                id: paramDouble3Dinput2
                text: model.object.value2
                anchors.left: parent.left
                anchors.leftMargin: 5
                maximumLength: 5
                color: activeFocus ? "white" : "grey"
                width: 40
                activeFocusOnPress : true
                selectByMouse : true
                onAccepted: model.object.value2 = paramDouble3Dinput2.text
                validator: DoubleValidator{
                    bottom: model.object.minimum
                    top:  model.object.maximum
                }
            }
        }

        /* Third input */
        Rectangle{
            height: 20
            width:40
            color: "#212121"
            border.width: 1
            border.color: "#333"
            radius: 3
            TextInput{
                id: paramDouble3Dinput3
                text: model.object.value3
                anchors.left: parent.left
                anchors.leftMargin: 5
                maximumLength: 5
                color: activeFocus ? "white" : "grey"
                width: 40
                activeFocusOnPress : true
                selectByMouse : true
                onAccepted: model.object.value3 = paramDouble3Dinput3.text
                validator: DoubleValidator{
                    bottom: model.object.minimum
                    top:  model.object.maximum
                }
            }
        }
    }
}