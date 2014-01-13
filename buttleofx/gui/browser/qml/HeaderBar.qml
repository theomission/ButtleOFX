import QtQuick 2.1

Rectangle {
    id: headerBar
	color : "lightblue"

    property string folder
    signal changeFolder(string folder)
    property string parentFolder

	Row{
		spacing: 10;

		Image{
			id: previous;
			source: "./img/previous.png"
			sourceSize.width : parent.width
			sourceSize.height : 40

			MouseArea{
				anchors.fill: parent
                onClicked: {
                    console.debug("Undo")
                }
			}
		}
		Image{
			id: next
			source: "./img/next.png"
			sourceSize.width: parent.width
			sourceSize.height: 40

			MouseArea{
				anchors.fill: parent
                onClicked: console.log("Redo")
			}
		}
		Image{
			id: folder
			source: "./img/Folder-icon.png"
			sourceSize.width: parent.width
			sourceSize.height: 40

			MouseArea{
				anchors.fill: parent
                onClicked: {
                    changeFolder(parentFolder)
                }
			}
		}

		TextEdit {
			id : texteditPath
			y: 10
            height: parent.height
            width: 900

            text: headerBar.folder
            onTextChanged: {
                changeFolder(text)
            }
		}
		
	}

}
