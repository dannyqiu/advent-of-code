process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var currentFloor = 0;
    var i;
    for (i = 0; i < input.length; ++i) {
        if (input[i] == "(") {
            currentFloor++;
        }
        else if (input[i] == ")") {
            currentFloor--;
        }
        else {
            console.log("Invalid character: " + input[i]);
        }
        if (currentFloor == -1) {
            break;
        }
    }
    if (currentFloor == -1) {
        // postitions are 1-indexed
        console.log("Position of character that makes Santa go into the basement: " + (i + 1));
    }
    else {
        console.log("Santa doesn't go into the basement!");
    }
}
