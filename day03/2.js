process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var santaX = 0;
    var santaY = 0;
    var roboX = 0;
    var roboY = 0;
    locations = {};
    addPresentMapping(locations, santaX, santaY);
    addPresentMapping(locations, roboX, roboY);
    directions = input.split("");
    for (var i = 0; i < directions.length; i += 2) {
        var dir = directions[i];
        if (dir == "<") {
            santaX--;
        }
        else if (dir == ">") {
            santaX++;
        }
        else if (dir == "^") {
            santaY++;
        }
        else if (dir == "v") {
            santaY--;
        }
        else {
            console.log("Bad direction: " + dir);
            continue;
        }
        addPresentMapping(locations, santaX, santaY);
    }
    for (var i = 1; i < directions.length; i += 2) {
        var dir = directions[i];
        if (dir == "<") {
            roboX--;
        }
        else if (dir == ">") {
            roboX++;
        }
        else if (dir == "^") {
            roboY++;
        }
        else if (dir == "v") {
            roboY--;
        }
        else {
            console.log("Bad direction: " + dir);
            continue;
        }
        addPresentMapping(locations, roboX, roboY);
    }
    console.log("These houses get at least one present: " + Object.keys(locations).length);
}

function addPresentMapping(table, x, y) {
    var key = (x << 16) + y;
    if (table[key] === undefined) {
        table[key] = 1;
    }
    else {
        table[key]++;
    }
}
