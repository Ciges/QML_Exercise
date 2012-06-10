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
                text: "http://api.trakt.tv/search/movies.json/e521ecb2eb453ca1eff7583ab4d7d1a6/batman";
            }
            Button {
                id: btnGo

                anchors.verticalCenter: toolBar.verticalCenter
                width: 80
                text: "Go"
                onClicked:  {
                    if (txtURLInput.text.trim() == "")   {
                        txtData.text = "Error: You must introduce an URL in the text field";
                    }
                    else    {
                        var answer_url = new XMLHttpRequest();
                        answer_url.onreadystatechange = function () {
                                    if (answer_url.readyState == XMLHttpRequest.DONE)   {
                                        if (answer_url.status == 200)   {
                                            var json_data = answer_url.responseText;
                                            txtData.text = json_data;
                                        }
                                        else    {
                                            txtData.text = "Error:  There was a problem with the URL. The server returner error code" + answer_url.status
                                        }
                                    }
                                }
                        answer_url.open("GET", txtURLInput.text.trim());
                        answer_url.send();
                    }
                }

            }

        }
        Row {
            id: dataRow

            width: parent.width
            height: parent.height - toolBar.height - parent.spacing

            TextArea    {
                id: txtData
                readOnly: true
                width: parent.width
                height: parent.height
            }
        }
    }
}
