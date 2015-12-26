process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var line = input.split("\n");
    var totalDifference = 0;
    for (var i = 0; i < line.length; ++i) {
        if (line[i] == '') {
            continue;
        }
        var escaped = '"' + addSlashes(line[i]) + '"';
        var escapedLength = escaped.length;
        var codeLength = line[i].length;
        totalDifference += (escapedLength - codeLength);
    }
    console.log("Difference in characters: " + totalDifference);
}

// from http://stackoverflow.com/questions/770523/escaping-strings-in-javascript
function addSlashes( str ) {
    return (str + '').replace(/[\\"']/g, '\\$&').replace(/\u0000/g, '\\0');
}
