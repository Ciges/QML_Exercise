// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtDesktop 0.1

Rectangle {
    id: mainWindows
    width: 800
    height: 600

    // Recursive fonction that returns as text and elegantlly indented the structure of a JSON document
    function process_JSON(json_data, prefix)    {

        if (prefix == null) {
            prefix = "    "
        }

        var result = "";
        var key_name = "";
        for (var key in json_data)  {
            var value = json_data[key];
            var pat = new RegExp("^[0-9]$");
            if (!pat.test(key))  {
                key_name = "\"" + key + "\" :  ";
            }

            if (typeof(value) === 'string') {
                result += prefix + key_name + "\"" + value + "\",\n";
            }
            else if (typeof(value) === 'number')    {
                result += prefix + key_name + value + ",\n";
            }
            else if (typeof(value) === 'undefined') {
                result += prefix + key_name + " Undefined,\n";
            }
            else if (typeof(value) === 'object')    {
                result += prefix + key_name + "\n";
                // It is a list of elements or another document?
                if (value["0"] != null)   {
                    result += prefix + "[\n"+ process_JSON(value, prefix + prefix) + prefix + "]\n";
                }
                else {
                    result += prefix + "{\n"+ process_JSON(value, prefix + prefix) + prefix + "}\n";
                }
            }
        }

        return result ;
    }

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
                                            var json_data = JSON.parse(answer_url.responseText);
                                            // We use [] if it is a list of documents and {} if it is a document with its pairs key-value
                                            if (json_data["0"] != null)   {
                                                txtData.text = "[\n"+ process_JSON(json_data) + "]\n";
                                            }
                                            else {
                                                txtData.text = "{\n" + process_JSON(json_data) + "}\n";
                                            }
                                        }
                                        else    {
                                            txtData.text = "Error:  There was a problem with the URL. The server returner error code" + answer_url.status
                                        }
                                    }
                        }
                    }
                    answer_url.open("GET", txtURLInput.text.trim());
                    answer_url.send();
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
