process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var currentFloor = 0;
    for (var i = 0; i < input.length; ++i) {
        if (input[i] == "(") {
            currentFloor++;
        }
        else if (input[i] == ")") {
            currentFloor--;
        }
        else {
            console.log("Invalid character: " + input[i]);
        }
    }
    console.log("Santa's floor: " + currentFloor);
}
