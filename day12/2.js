process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var content = JSON.parse(input);
    console.log("Sum of all the numbers: " + sumNumbers(content));
}

function sumNumbers(content) {
    var total = 0;
    if (Array.isArray(content)) {
        for (var i = 0; i < content.length; ++i) {
            total += sumNumbers(content[i]);
        }
    }
    else if (typeof content == "object") {
        if (!hasRedValue(content)) {
            for (var key in content) {
                total += sumNumbers(content[key]);
            }
        }
    }
    else if (typeof content == "number") {
        total = content;
    }
    return total;
}

function hasRedValue(content) {
    for (key in content) {
        if ("red" === content[key]) {
            console.log(content[key]);
            return true;
        }
    }
    return false;
    /* // This solution ignores objects with "red" appearing in any child object
    if (Array.isArray(content)) {
        for (var i = 0; i < content.length; ++i) {
            if (typeof content[i] == "object" && hasRedValue(content[i])) {
                return true;
            }
        }
        return false;
    }
    else if (typeof content == "object") {
        var contentKeys = Object.keys(content);
        for (var i = 0; i < contentKeys.length; ++i) {
            if (hasRedValue(content[contentKeys[i]])) {
                return true;
            }
        }
        return false;
    }
    return content === "red";
    */
}
