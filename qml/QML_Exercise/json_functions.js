.pragma library

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
