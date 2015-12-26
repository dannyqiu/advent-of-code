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
        var memoryRep = eval(line[i]);
        var memoryRepLength = memoryRep.length;
        var codeLength = line[i].length;
        totalDifference += (codeLength - memoryRepLength);
    }
    console.log("Difference in characters: " + totalDifference);
}
