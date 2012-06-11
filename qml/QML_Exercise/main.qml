// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1
import "json_functions.js" as JSON_functions

Rectangle {
    id: mainWindow
    width: 800
    height: 600
    state: "WAITING"

    states: [
        State {
            name: "WAITING"
            PropertyChanges { target: txtState; text: "Waiting for user input ..."}
        },
        State {
            name: "LOADING"
            PropertyChanges { target: txtState; text: "Loading data from the network ..."}

        },
        State {
            name: "READY"
            PropertyChanges { target: txtState; text: "Data received"}
        },
        State {
            name: "ERROR"
            PropertyChanges { target: txtState; text: "Error!"}
        }

    ]

    Column {
        anchors.margins: 5
        anchors.fill: parent
        spacing: 5
        Row {
            id: toolBar

            spacing: 10
            width: parent.width

            TextField {
                id: txtURLInput
                placeholderText: "Write the URL of the web service"
                width: parent.width - cmbMethod.width - btnGo.width - toolBar.spacing*2
                text: "http://www.mitwiz.com/api/v1/events/search/?token=36769e11ca288d1c1cfef36e1f2a9871&q=place:vigo"
            }

            ComboBox {
                id: cmbMethod
                anchors.verticalCenter: toolBar.verticalCenter

                model: ListModel {
                    ListElement { name: "GET" }
                    ListElement { name: "POST" }
                }
            }

            Button {
                id: btnGo

                anchors.verticalCenter: toolBar.verticalCenter
                width: 80
                text: "Go"
                onClicked:  {
                    if (txtURLInput.text.trim() == "")   {
                        txtData.text = "Error: You must introduce an URL in the text field";
                        mainWindow.state = "ERROR";
                    }
                    else    {
                        var answer_url = new XMLHttpRequest();
                        answer_url.onreadystatechange = function () {
                                    if (answer_url.readyState == XMLHttpRequest.DONE)   {
                                        if (answer_url.status == 200)   {
                                            try {
                                                var json_data = JSON.parse(answer_url.responseText);
                                            }
                                            catch (exception)   {
                                                txtData.text = "Error:  There was a problem with the JSON retourned by the server (malformed or not JSON?)";
                                                mainWindow.state = "ERROR";
                                            }

                                            // We use [] if it is a list of documents and {} if it is a document with its pairs key-value
                                            if (json_data["0"] != null)   {
                                                txtData.text = "[\n"+ JSON_functions.process_JSON(json_data) + "]\n";
                                            }
                                            else {
                                                txtData.text = "{\n" + JSON_functions.process_JSON(json_data) + "}\n";
                                            }
                                            mainWindow.state = "READY";
                                        }
                                        else    {
                                            txtData.text = "Error:  There was a problem with the URL. The server returner error code " + answer_url.status;
                                            mainWindow.state = "ERROR";
                                        }
                                    }
                        }
                    }
                    answer_url.open(cmbMethod.selectedText, txtURLInput.text.trim());
                    answer_url.send();
                    mainWindow.state = "LOADING";
                }
            }

        }

        Row {
            id: dataRow

            width: parent.width
            height: parent.height - toolBar.height - parent.spacing - txtState.height

            TextArea    {
                id: txtData
                readOnly: true
                width: parent.width
                height: parent.height
                text: "The example URL shows next events in Vigo City (Pontevedra, Spain) from Mitwiz web service"
            }
        }

        TextArea {
            id: txtState
            readOnly: true
            anchors.fill: parent.fill
            height: 31
            frame: false
        }

    }
}
