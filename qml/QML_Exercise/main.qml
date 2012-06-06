// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1

Rectangle {
    id: mainWindows
    width: 800
    height: 600

    Column {
        anchors.margins: 5
        anchors.fill: parent
        spacing: 10
        Row {
            id: toolBar

            spacing: 10
            width: parent.width
            TextField {
                id: txtURLInput
                placeholderText: "Write the URL of the web service"
                width: parent.width - btnGo.width - toolBar.spacing
            }
            Button {
                id: btnGo

                anchors.verticalCenter: toolBar.verticalCenter
                width: 80
                text: "Go"
                onClicked:  {
                    // TODO:
                }

            }

        }
        Row {
            id: dataVisualization

            width: parent.width
            height: parent.height - toolBar.height - parent.spacing

            TextArea    {
                id: txtArea
                readOnly: true
                anchors.fill: parent
            }
        }
    }
}
