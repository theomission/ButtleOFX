import QtQuick 1.1

/*ParamInt is an input field*/


Item {
    id: containerParamInt
    implicitWidth: 300
    implicitHeight: 30

    /*Container of the textInput*/
    Row{
        id: paramIntInputContainer
        spacing: 10

        /*Title of the paramInt */
        Text {
            id: paramIntTitle
            width: 80
            text: model.object.text + " : "
            color: "white"
           // font.pointSize: 8
            anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
        }

        /*Input field accepting only number between 0 and 255*/
        Rectangle{
            height: 20
            width:40
            color: "#212121"
            border.width: 1
            border.color: "#333"
            radius: 3
            TextInput{
                id: paramIntInput
                text: model.object.value
                anchors.left: parent.left
                anchors.leftMargin: 5
                maximumLength: 3
                color: activeFocus ? "white" : "grey"
                width: 40
                selectByMouse : true
                onAccepted: model.object.value = paramIntInput.text
                validator: IntValidator{
                    bottom: model.object.minimum
                    top:  model.object.maximum
                }
            }
        }
    }

}