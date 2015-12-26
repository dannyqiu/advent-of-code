process.stdin.setEncoding('utf8');
process.stdin.on('readable', processData);

function processData() {
    var input = process.stdin.read();
    if (input == null) {
        return;
    }
    var santaX = 0;
    var santaY = 0;
    locations = {}
    addPresentMapping(locations, santaX, santaY);
    directions = input.split("");
    directions.forEach(function(dir) {
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
            return;
        }
        addPresentMapping(locations, santaX, santaY);
    });
    /*
    var filteredLocations = Object.keys(locations).filter(function(loc) {
        return locations[loc] > 1;
    });
    */
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
